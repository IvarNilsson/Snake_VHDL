library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.matrix_type.all;

entity segments is
   port (
      clk                  : in std_logic;
      rst                  : in std_logic;
      after_game_tick_edge : in std_logic;
      movment              : in std_logic_vector(3 downto 0);
      --add_segment_edge     : in std_logic;
      head_posision_x : out unsigned(5 downto 0);
      head_posision_y : out unsigned(5 downto 0);
      snake_matrix    : out matrix_32_40
   );
end segments;
architecture rtl of segments is
   constant max_segments : natural := 32;

   type posision_type is array (max_segments - 1 downto 0) of unsigned(5 downto 0); -- only 6 bits needed
   signal current_x_array : posision_type;
   signal current_y_array : posision_type;
   signal next_x_array    : posision_type;
   signal next_y_array    : posision_type;

   signal current_add_segment : std_logic;
   signal next_add_segment    : std_logic;
   signal current_end         : std_logic;
   signal next_end            : std_logic;

   signal current_apple_x : unsigned(5 downto 0);
   signal current_apple_y : unsigned(5 downto 0);
   signal next_apple_x    : unsigned(5 downto 0);
   signal next_apple_y    : unsigned(5 downto 0);

   signal current_head_x : unsigned(5 downto 0);
   signal current_head_y : unsigned(5 downto 0);
   signal next_head_x    : unsigned(5 downto 0);
   signal next_head_y    : unsigned(5 downto 0);

   -- size of snake
   signal current_size : integer range 0 to max_segments := 1;
   signal next_size    : integer range 0 to max_segments;

   signal current_add_buffer : integer range 0 to 31; -- should never get big
   signal next_add_buffer    : integer range 0 to 31; -- should never get big

   signal next_snake_matrix : matrix_32_40;

begin
   snake_matrix <= next_snake_matrix;

   --head_posision_x <= current_x_array(current_size - 1);
   --head_posision_y <= current_y_array(current_size - 1);

   process (clk)
   begin
      if rising_edge(clk) then
         if rst = '1' then
            current_x_array    <= (others => (others => '0'));
            current_y_array    <= (others => (others => '0'));
            current_size       <= 1;
            current_add_buffer <= 0;
            current_head_x     <= to_unsigned(20, 6);
            current_head_y     <= to_unsigned(16, 6);

            current_apple_x     <= to_unsigned(20, 6);
            current_apple_y     <= to_unsigned(12, 6);
            current_add_segment <= '0';
            current_end         <= '0';

         else
            current_x_array    <= next_x_array;
            current_y_array    <= next_y_array;
            current_size       <= next_size;
            current_add_buffer <= next_add_buffer;
            current_head_x     <= next_head_x;
            current_head_y     <= next_head_y;

            current_apple_x     <= next_apple_x;
            current_apple_y     <= next_apple_y;
            current_add_segment <= next_add_segment;
            current_end         <= next_end;
         end if;
      end if;
   end process;

   move : process (current_add_buffer, current_x_array, current_y_array, current_size, current_add_segment, movment, after_game_tick_edge)
      variable temp_head_x : unsigned(5 downto 0);
      variable temp_head_y : unsigned(5 downto 0);
   begin
      next_add_buffer <= current_add_buffer;
      next_x_array    <= current_x_array;
      next_y_array    <= current_y_array;
      next_size       <= current_size;
      if (current_add_segment = '1') then
         next_add_buffer <= current_add_buffer + 3;
      end if;

      temp_head_x := current_head_x;
      temp_head_y := current_head_y;

      if (after_game_tick_edge = '1' and not(movment = "0000")) then
         if (movment = "1000") then -- up
            temp_head_x := current_head_x;
            temp_head_y := current_head_y - 1;

         elsif (movment = "0100") then -- down
            temp_head_x := current_head_x;
            temp_head_y := current_head_y + 1;

         elsif (movment = "0010") then --left 
            temp_head_x := current_head_x - 1;
            temp_head_y := current_head_y;

         elsif (movment = "0001") then -- rigth
            temp_head_x := current_head_x + 1;
            temp_head_y := current_head_y;
         end if;

         if (current_add_buffer > 0) then
            -- move and add segment
            next_add_buffer <= current_add_buffer - 1;
            next_size       <= current_size + 1;

            next_x_array(current_size) <= next_head_x;
            next_y_array(current_size) <= next_head_y;
         else
            --move
            next_x_array(max_segments - 2 downto 0) <= current_x_array(max_segments - 1 downto 1);
            next_y_array(max_segments - 2 downto 0) <= current_y_array(max_segments - 1 downto 1);

            next_x_array(current_size - 1) <= next_head_x;
            next_y_array(current_size - 1) <= next_head_y;
         end if;
      end if;

      next_head_x <= temp_head_x;
      next_head_y <= temp_head_y;
   end process;

   colisions : process (current_end, current_head_x, current_head_y, current_apple_x, current_apple_y)
   begin
      next_add_segment <= '0';
      next_end         <= current_end;
      next_apple_x     <= current_apple_x;
      next_apple_y     <= current_apple_y;

      if (current_head_x >= 40 or current_head_y >= 32) then
         next_end <= '1';
      elsif (current_head_x = current_apple_x and current_head_y = current_apple_y) then
         next_add_segment <= '1';
         next_apple_x     <= current_apple_x - 1;
         next_apple_y     <= current_apple_y - 1;
      end if;
   end process;

   gen_matrix2 : process (current_y_array, current_x_array, current_size)
   begin
      next_snake_matrix <= (others => (others => '0')); -- Initialize the temporary matrix

      for i in 0 to max_segments - 1 loop
         if (i < current_size) then
            next_snake_matrix(to_integer(current_y_array(i)))(to_integer(current_x_array(i))) <= '1';
         end if;
      end loop;

   end process;
end architecture;
