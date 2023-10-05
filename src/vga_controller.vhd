library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.matrix_type.all;

-- VESA Signal 1280 x 1024 @ 60 Hz timing
entity vga_controller is
    port (
        clk_108 : in std_logic;
        rst     : in std_logic;

        snake_matrix : in matrix_64_80;

        vga_r  : out std_logic_vector(3 downto 0);
        vga_g  : out std_logic_vector(3 downto 0);
        vga_b  : out std_logic_vector(3 downto 0);
        vga_hs : out std_logic;
        vga_vs : out std_logic
    );
end vga_controller;

architecture rtl of vga_controller is

    --11 bits: 0 to 2047
    signal current_h_cnt : unsigned(10 downto 0); -- 640 (active video) + 16 (front porch) + 96 (sync_pulse) + 48 (back porch) = 800
    signal next_h_cnt    : unsigned(10 downto 0); -- 1280 Active + 48 Front porch + 112 Sync pulse + Back porch 248 = 1688

    signal current_v_cnt : unsigned(10 downto 0); -- 400 (active video) + 12 (front porch) + 2 (sync_pulse)+ 35 (back porch) = 449
    signal next_v_cnt    : unsigned(10 downto 0); -- 1024 Active + 1 Front porch + 3 Sync pulse + 38 back porch = 1066

begin

    vga_hs <= '0' when current_h_cnt >= 1328 and current_h_cnt < 1440 else
        '1';
    vga_vs <= '1' when current_v_cnt >= 1025 and current_v_cnt < 1028 else
        '0';

    reg : process (clk_108)
    begin
        if rising_edge(clk_108) then
            if rst = '1' then
                current_h_cnt <= (others => '0');
                current_v_cnt <= (others => '0');
            else
                current_h_cnt <= next_h_cnt;
                current_v_cnt <= next_v_cnt;
            end if;
        end if;
    end process;

    comb_states : process (current_h_cnt, current_v_cnt)
    begin
        next_h_cnt <= current_h_cnt + 1;
        next_v_cnt <= current_v_cnt;

        if (current_h_cnt < 1688) then
            next_h_cnt <= current_h_cnt + 1;
        else
            next_h_cnt <= (others => '0');
            if (current_v_cnt < 1066) then
                next_v_cnt <= current_v_cnt + 1;
            else
                next_v_cnt <= (others => '0');
            end if;
        end if;
    end process;

    rgb_comb : process (current_h_cnt, current_v_cnt, snake_matrix)
        variable temp_snake_row : std_logic_vector(79 downto 0);
    begin
        vga_r <= (others => '0');
        vga_g <= (others => '0');
        vga_b <= (others => '0');

        if (current_h_cnt < 1280 and current_v_cnt < 1024) then

            temp_snake_row := snake_matrix((to_integer(current_v_cnt))/16);

            if temp_snake_row((to_integer(current_h_cnt))/16) = '1' then

                -- border of snake segment 
                if (current_h_cnt mod 16 = 0 or current_v_cnt mod 16 = 0) then --fix this to a 2 pixel border after test (i thin add or ... mod 16 = 15)
                    -- border
                    vga_r <= x"9";
                    vga_g <= x"d";
                    vga_b <= x"7";
                else
                    -- snake
                    vga_r <= x"2";
                    vga_g <= x"2";
                    vga_b <= x"2";
                end if;

            else
                -- background
                vga_r <= x"9";
                vga_g <= x"d";
                vga_b <= x"7";
            end if;

        end if;
    end process;

end architecture;
