library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.matrix_type.all;

entity segment_colision is
   port (
      clk             : in std_logic;
      rst             : in std_logic;
      game_tick_edge  : in std_logic;
      movment         : in std_logic_vector(3 downto 0);
      snake_matrix    : in matrix_32_40;
      head_posision_x : in unsigned(5 downto 0);
      head_posision_y : in unsigned(5 downto 0);
      --apple_posision_x : in unsigned(5 downto 0);
      --apple_posision_y : in unsigned(5 downto 0);
      add_segment_edge : out std_logic;
      end_game_edge    : out std_logic
   );
end segment_colision;
architecture rtl of segment_colision is
   signal add_segment   : std_logic;
   signal add_segment_d : std_logic;

   signal current_apple_posision_x : unsigned(5 downto 0);
   signal current_apple_posision_y : unsigned(5 downto 0);
   signal next_apple_posision_x    : unsigned(5 downto 0);
   signal next_apple_posision_y    : unsigned(5 downto 0);

begin
   add_segment_edge <= add_segment and (not add_segment_d);

   reg : process (clk)
   begin
      if rising_edge(clk) then
         if rst = '1' then
            add_segment_d            <= '1';
            current_apple_posision_x <= (others => '0');
            current_apple_posision_y <= (others => '0');
         else
            add_segment_d            <= add_segment;
            current_apple_posision_x <= next_apple_posision_x;
            current_apple_posision_y <= next_apple_posision_y;
         end if;
      end if;
   end process;

   apple : process (add_segment_edge, current_apple_posision_x, current_apple_posision_y)
   begin
      next_apple_posision_x <= current_apple_posision_x;
      next_apple_posision_y <= current_apple_posision_y;
      if (add_segment_edge) then
         next_apple_posision_x <= current_apple_posision_x + 1;
         next_apple_posision_y <= current_apple_posision_y + 1;
      end if;
   end process;

   colision : process (game_tick_edge, movment, snake_matrix, head_posision_y, head_posision_x, current_apple_posision_x, current_apple_posision_y)
   begin
      end_game_edge <= '0';
      add_segment   <= '0';
      if (game_tick_edge = '1') then
         -- up
         if (movment = "1000") then
            if (head_posision_y - 1 < 0) then
               end_game_edge <= '1';
            elsif (snake_matrix(to_integer(head_posision_y - 1))(to_integer(head_posision_x)) = '1') then
               end_game_edge <= '1';
            elsif (head_posision_x = current_apple_posision_x and head_posision_y - 1 = current_apple_posision_y) then
               add_segment <= '1';
            end if;

            -- down
         elsif (movment = "0100") then
            if (head_posision_y + 1 > 31) then
               end_game_edge <= '1';
            elsif (snake_matrix(to_integer(head_posision_y + 1))(to_integer(head_posision_x)) = '1') then
               end_game_edge <= '1';
            elsif (head_posision_x = current_apple_posision_x and head_posision_y + 1 = current_apple_posision_y) then
               add_segment <= '1';
            end if;

            -- left
         elsif (movment = "0010") then
            if (head_posision_x - 1 < 0) then
               end_game_edge <= '1';
            elsif (snake_matrix(to_integer(head_posision_y))(to_integer(head_posision_x - 1)) = '1') then
               end_game_edge <= '1';
            elsif (head_posision_x - 1 = current_apple_posision_x and head_posision_y = current_apple_posision_y) then
               add_segment <= '1';
            end if;

            -- right
         elsif (movment = "0001") then
            if (head_posision_x + 1 > 39) then
               end_game_edge <= '1';
            elsif (snake_matrix(to_integer(head_posision_y))(to_integer(head_posision_x + 1)) = '1') then
               end_game_edge <= '1';
            elsif (head_posision_x + 1 = current_apple_posision_x and head_posision_y = current_apple_posision_y) then
               add_segment <= '1';
            end if;
         end if;
      end if;
   end process;

end architecture;
