library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.matrix_type.all;

entity movment_engine is
    port (
        clk            : in std_logic;
        rst            : in std_logic;
        game_tick_edge : in std_logic;
        key_controll   : in std_logic_vector(3 downto 0);
        snake_matrix   : out matrix_64_80
    );
end movment_engine;
architecture rtl of movment_engine is

    signal current_snake_matrix : matrix_64_80;
    signal next_snake_matrix    : matrix_64_80;

begin
    snake_matrix <= current_snake_matrix;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_snake_matrix     <= (others => (others => '0'));
                current_snake_matrix(32) <= x"00000000010000000000";
            else
                current_snake_matrix <= next_snake_matrix;
            end if;
        end if;
    end process;

    process (current_snake_matrix, game_tick_edge, key_controll)
        variable temp_snake_row_left  : std_logic_vector(19 downto 0);
        variable temp_snake_row_right : std_logic_vector(19 downto 0);

    begin
        next_snake_matrix <= current_snake_matrix;

        if (game_tick_edge = '1') then

            -- up
            if (key_controll = "1000") then
                for row in 0 to 18 loop
                    next_snake_matrix(row) <= current_snake_matrix(row + 1);
                end loop;
                next_snake_matrix(19) <= (others => '0');

                -- down
            elsif (key_controll = "0100") then
                for row in 0 to 18 loop
                    next_snake_matrix(row + 1) <= current_snake_matrix(row);
                end loop;
                next_snake_matrix(0) <= (others => '0');

                -- left
            elsif (key_controll = "0010") then
                for row in 0 to 19 loop
                    temp_snake_row_left := current_snake_matrix(row);
                    next_snake_matrix(row) <= '0' & temp_snake_row_left(19 downto 1);
                end loop;

                -- right
            elsif (key_controll = "0001") then
                for row in 0 to 19 loop
                    temp_snake_row_right := current_snake_matrix(row);
                    next_snake_matrix(row) <= temp_snake_row_right(18 downto 0) & '0';
                end loop;

            end if;
        end if;

    end process;

end architecture;
