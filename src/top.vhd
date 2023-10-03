library ieee;
use ieee.std_logic_1164.all;
--use work.matrix_type.all;

entity top is
    generic (
        countWidth : integer := 19
    );
    port (
        sys_clk        : in std_logic;
        rst_avtive_low : in std_logic;
        led            : out std_logic_vector(15 downto 0);

        vga_r  : out std_logic_vector(3 downto 0);
        vga_g  : out std_logic_vector(3 downto 0);
        vga_b  : out std_logic_vector(3 downto 0);
        vga_hs : out std_logic;
        vga_vs : out std_logic
    );
end top;

architecture structural of top is
    signal clk_25  : std_logic;
    signal clk_100 : std_logic;
    signal rst     : std_logic; -- active high
    
begin
    rst <= not rst_avtive_low;
    led <= (others => not rst);

    vga_controller : entity work.vga_controller
        port map(
            clk_25 => clk_25,
            rst    => rst,
            vga_r  => vga_r,
            vga_g  => vga_g,
            vga_b  => vga_b,
            vga_hs => vga_hs,
            vga_vs => vga_vs
        );

    clk_wiz_wrapper : entity work.clk_wiz_wrapper
        port map(
            sys_clock => sys_clk,
            rst       => rst,
            clk_100   => clk_100,
            clk_25    => clk_25
        );

end architecture;
