library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.matrix_type.all;

-- 640 x 480 60 Hz
entity vga_controller is
    port (
        --clk_100 : in std_logic;
        clk_25 : in std_logic;
        rst    : in std_logic;

        snake_matrix : in matrix_20_20;

        vga_r  : out std_logic_vector(3 downto 0);
        vga_g  : out std_logic_vector(3 downto 0);
        vga_b  : out std_logic_vector(3 downto 0);
        vga_hs : out std_logic;
        vga_vs : out std_logic
    );
end vga_controller;

architecture rtl of vga_controller is

    --10 bits: 0 to 1024
    signal current_h_cnt : unsigned(10 downto 0); -- 640 (active video) + 16 (front porch) + 96 (sync_pulse) + 48 (back porch) = 800
    signal next_h_cnt    : unsigned(10 downto 0);

    signal current_v_cnt : unsigned(10 downto 0); -- 400 (active video) + 12 (front porch) + 2 (sync_pulse)+ 35 (back porch) = 449
    signal next_v_cnt    : unsigned(10 downto 0);

begin

    vga_hs <= '0' when current_h_cnt >= 656 and current_h_cnt < 752 else
        '1';
    vga_vs <= '1' when current_v_cnt = 412 or current_v_cnt = 413 else
        '0';

    reg : process (clk_25)
    begin
        if rising_edge(clk_25) then
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

        if (current_h_cnt < 800) then
            next_h_cnt <= current_h_cnt + 1;
        else
            next_h_cnt <= (others => '0');
            if (current_v_cnt < 449) then
                next_v_cnt <= current_v_cnt + 1;
            else
                next_v_cnt <= (others => '0');
            end if;
        end if;
    end process;

    rgb_comb : process (current_h_cnt, current_v_cnt, snake_matrix)
        variable temp_snake_row : std_logic_vector(19 downto 0);
    begin
        vga_r <= (others => '0');
        vga_g <= (others => '0');
        vga_b <= (others => '0');

        if (current_h_cnt < 640 and current_v_cnt < 400) then
            vga_r <= "0010";
            vga_g <= "0010";
            vga_b <= "0010";
            if (current_h_cnt > 119 and current_h_cnt < 521) then

                temp_snake_row := snake_matrix((to_integer(current_v_cnt))/20);

                if temp_snake_row((to_integer(current_h_cnt) - 40)/20) = '1' then
                    vga_r <= x"F";
                    vga_g <= x"F";
                    vga_b <= x"F";

                else
                    vga_r <= "0111"; --grey?
                    vga_g <= "0111"; --grey?
                    vga_b <= "0111"; --grey?

                end if;

            end if;
        end if;
    end process;

end architecture;
