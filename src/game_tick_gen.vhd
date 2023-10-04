library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity game_tick_gen is
    generic (
        countWidth : in integer
    );
    port (
        clk            : in std_logic;
        rst            : in std_logic;
        game_tick_edge : out std_logic
    );
end game_tick_gen;
architecture rtl of game_tick_gen is

    signal current_count : unsigned(countWidth downto 0);
    signal next_count    : unsigned(countWidth downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_count <= (others => '0');
            else
                current_count <= next_count;
            end if;
        end if;
    end process;

    process (current_count)
    begin
        next_count     <= current_count + 1;
        game_tick_edge <= '0';

        if (current_count = 0) then
            game_tick_edge <= '1';
        end if;

    end process;

end architecture;
