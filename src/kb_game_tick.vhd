library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity kb_game_tick is
   port (
      clk                    : in std_logic;
      rst                    : in std_logic;
      prepare_game_tick_edge : in std_logic;
      key_controll           : in std_logic_vector(3 downto 0); -- up, down, left, right
      movment                : out std_logic_vector(3 downto 0)
   );
end kb_game_tick;

architecture rtl of kb_game_tick is

   signal current_movment : std_logic_vector(3 downto 0);
   signal next_movment    : std_logic_vector(3 downto 0);

begin
   movment <= current_movment;

   reg : process (clk, rst)
   begin
      if rising_edge(clk) then
         if (rst = '1') then
            current_movment <= (others => '0');
         else
            current_movment <= next_movment;
         end if;
      end if;
   end process;

   comb_state : process (current_movment, prepare_game_tick_edge, key_controll)
   begin
      next_movment <= current_movment;

      if prepare_game_tick_edge = '1' then
         if (key_controll = "0000") then -- pause
            next_movment <= "0000";

         elsif (not(current_movment = "1000") and key_controll = "0100") then -- block up to down
            next_movment <= "0100";

         elsif (not(current_movment = "0100") and key_controll = "1000") then -- block down to up
            next_movment <= "1000";

         elsif (not(current_movment = "0010") and key_controll = "0001") then -- block left to right
            next_movment <= "0001";

         elsif (not(current_movment = "0001") and key_controll = "0010") then -- block down to up
            next_movment <= "0010";

         end if;
      end if;

   end process;
end architecture;
