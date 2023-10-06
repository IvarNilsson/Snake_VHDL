library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.matrix_type.all;

entity segments is
   port (
      clk              : in std_logic;
      rst              : in std_logic;
      game_tick_edge   : in std_logic;
      movment          : in std_logic_vector(3 downto 0);
      add_segment_edge : in std_logic;
      snake_matrix     : out matrix_64_80
   );
end segments;
architecture rtl of segments is
   constant max_segments : natural := 8;

   type posision_type is array (max_segments - 1 downto 0) of unsigned(7 downto 0); -- first 8 bits row, second 8 bits col
   signal current_x_array : posision_type;
   signal current_y_array : posision_type;
   signal next_x_array    : posision_type;
   signal next_y_array    : posision_type;

   -- size of snake
   signal current_size : integer range 0 to max_segments;
   signal next_size    : integer range 0 to max_segments;

   signal current_add_buffer : integer range 0 to 31; -- shold never get big
   signal next_add_buffer    : integer range 0 to 31; -- shold never get big

   signal next_snake_matrix : matrix_64_80;

begin
   snake_matrix <= next_snake_matrix;

   process (clk)
   begin
      if rising_edge(clk) then
         if rst = '1' then
            current_x_array    <= (others => (others => '0'));
            current_y_array    <= (others => (others => '0'));
            current_x_array(0) <= x"28";
            current_y_array(0) <= x"20";
            current_size       <= 1;
            current_add_buffer <= 4;

         else
            current_x_array    <= next_x_array;
            current_y_array    <= next_y_array;
            current_size       <= next_size;
            current_add_buffer <= next_add_buffer;
         end if;
      end if;
   end process;

   process (current_add_buffer, current_x_array, current_y_array, current_size, add_segment_edge, movment, game_tick_edge)
   begin
      next_add_buffer <= current_add_buffer;
      next_x_array    <= current_x_array;
      next_y_array    <= current_y_array;
      next_size       <= current_size;

      if (add_segment_edge = '1') then
         next_add_buffer <= current_add_buffer + 1;
      end if;

      if (game_tick_edge = '1' and not(movment = "0000")) then

         if (current_add_buffer > 0) then
            -- move and add segment
            next_add_buffer <= current_add_buffer - 1;
            next_size       <= current_size + 1;

            if (movment = "1000") then -- up
               next_x_array(current_size) <= current_x_array(current_size - 1);
               next_y_array(current_size) <= current_y_array(current_size - 1) - 1;

            elsif (movment = "0100") then -- down
               next_x_array(current_size) <= current_x_array(current_size - 1);
               next_y_array(current_size) <= current_y_array(current_size - 1) + 1;

            elsif (movment = "0010") then --left 
               next_x_array(current_size) <= current_x_array(current_size - 1) - 1;
               next_y_array(current_size) <= current_y_array(current_size - 1);

            elsif (movment = "0001") then -- rigth
               next_x_array(current_size) <= current_x_array(current_size - 1) + 1;
               next_y_array(current_size) <= current_y_array(current_size - 1);
            end if;
         else
            --move

            next_x_array(max_segments - 2 downto 0) <= current_x_array(max_segments - 1 downto 1);
            next_y_array(max_segments - 2 downto 0) <= current_y_array(max_segments - 1 downto 1);

            if (movment = "1000") then -- up
               next_x_array(current_size - 1) <= current_x_array(current_size - 1);
               next_y_array(current_size - 1) <= current_y_array(current_size - 1) - 1;

            elsif (movment = "0100") then -- down
               next_x_array(current_size - 1) <= current_x_array(current_size - 1);
               next_y_array(current_size - 1) <= current_y_array(current_size - 1) + 1;

            elsif (movment = "0010") then --left 
               next_x_array(current_size - 1) <= current_x_array(current_size - 1) - 1;
               next_y_array(current_size - 1) <= current_y_array(current_size - 1);

            elsif (movment = "0001") then -- rigth
               next_x_array(current_size - 1) <= current_x_array(current_size - 1) + 1;
               next_y_array(current_size - 1) <= current_y_array(current_size - 1);
            end if;
         end if;
      end if;

   end process;

   gen_matrix2 : process (current_y_array, current_x_array)
   begin
      next_snake_matrix <= (others => (others => '0')); -- Initialize the temporary matrix

      for i in 0 to max_segments - 1 loop
         if (i < current_size) then
            next_snake_matrix(to_integer(current_y_array(i)))(to_integer(current_x_array(i))) <= '1';
         end if;
      end loop;

   end process;
end architecture;
