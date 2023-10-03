library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity vga_controller is
    port (
        --clk_100 : in std_logic;
        clk_25  : in std_logic;
        rst     : in std_logic;

        vga_r  : out std_logic_vector(3 downto 0);
        vga_g  : out std_logic_vector(3 downto 0);
        vga_b  : out std_logic_vector(3 downto 0);
        vga_hs : out std_logic;
        vga_vs : out std_logic

        -- clk_out : out std_logic;
        -- hcnt : out unsigned(10 downto 0);
        -- vcnt : out unsigned(10 downto 0)
    );
end vga_controller;

architecture rtl of vga_controller is

    signal h_cnt : unsigned(9 downto 0);
    signal v_cnt : unsigned(9 downto 0);
begin

    --clk_out <= pix_clock;
    --hcnt <= h_cnt;
    --vcnt <= v_cnt;

    vga_hs <= '0' when h_cnt >= 656 and h_cnt < 752 else
        '1';
    vga_vs <= '1' when v_cnt = 412 or v_cnt = 413 else
        '0';
    control : process (clk_25, rst)
    begin

        if (rst = '1') then
            h_cnt <= to_unsigned(0, h_cnt'length);
            v_cnt <= to_unsigned(0, v_cnt'length);
        elsif rising_edge(clk_25) then

            if (h_cnt < 640 and v_cnt < 400) then
                if (h_cnt = 0 or v_cnt = 0 or
                    h_cnt = 639 or v_cnt = 399) then
                    vga_r <= X"F";
                    vga_g <= X"0";
                    vga_b <= X"0";
                elsif (h_cnt(0) = '1' and v_cnt(1) = '1') then
                    vga_r <= X"F";
                    vga_g <= X"F";
                    vga_b <= X"F";
                else
                    vga_r <= X"0";
                    vga_g <= X"F";
                    vga_b <= X"0";
                end if;
            else
                vga_r <= X"0";
                vga_g <= X"0";
                vga_b <= X"0";
            end if;

            if (h_cnt < 800) then
                h_cnt <= h_cnt + 1;
            else
                h_cnt <= to_unsigned(0, h_cnt'length);
                if (v_cnt < 449) then
                    v_cnt <= v_cnt + 1;
                else
                    v_cnt <= to_unsigned(0, v_cnt'length);
                end if;
            end if;
        end if;
    end process;

end architecture;
