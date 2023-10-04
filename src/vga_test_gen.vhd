library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.matrix_type.all;

entity vga_test_gen is
    generic (
        countWidth : in integer
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        snake_matrix : out matrix_20_20
    );
end vga_test_gen;
architecture rtl of vga_test_gen is

    signal current_count : unsigned(countWidth downto 0);
    signal next_count    : unsigned(countWidth downto 0);

    signal current_game_tick : integer range 0 to 21;
    signal next_game_tick    : integer range 0 to 21;
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_count     <= (others => '0');
                current_game_tick <= 0;
            else
                current_count     <= next_count;
                current_game_tick <= next_game_tick;
            end if;
        end if;
    end process;

    process (current_count, current_game_tick)
    begin
        next_count     <= current_count + 1;
        next_game_tick <= current_game_tick;

        if (current_count = 0) then
            next_game_tick <= current_game_tick + 1;
        end if;

        if (current_game_tick = 20) then
            next_game_tick <= 0;
        end if;
    end process;

    process (current_game_tick)
    begin
        snake_matrix    <= (others => (others => '0'));
        snake_matrix(0) <= std_logic_vector(to_unsigned(2 ** current_game_tick, 20));
        snake_matrix(1) <= (others => '1');
    end process;

end architecture;
