library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity kb_scancode is
   port (
      clk                 : in std_logic;
      rst                 : in std_logic;
      kb_clk_falling_edge : in std_logic;
      kb_data             : in std_logic;
      valid_scan_code     : out std_logic;
      scan_code_out       : out std_logic_vector(7 downto 0)
   );
end kb_scancode;

architecture rtl of kb_scancode is
   signal current_counter : unsigned(3 downto 0) := (others => '0');
   signal next_counter    : unsigned(3 downto 0) := (others => '0');

   signal current_scan_code : unsigned(7 downto 0);
   signal next_scan_code    : unsigned(7 downto 0);

   signal next_valid_scan_code    : std_logic;
   signal current_valid_scan_code : std_logic;

begin
   scan_code_out   <= std_logic_vector(current_scan_code);
   valid_scan_code <= current_valid_scan_code;

   reg : process (clk, rst)
   begin
      if rising_edge(clk) then
         if (rst = '1') then
            current_valid_scan_code <= '0';
            current_scan_code       <= (others => '0');
            current_counter         <= (others => '0');
         else
            current_valid_scan_code <= next_valid_scan_code;
            current_counter         <= next_counter;
            current_scan_code       <= next_scan_code;
         end if;
      end if;
   end process;

   comb : process (kb_clk_falling_edge, current_counter, current_scan_code, kb_data, current_valid_scan_code)
   begin
      if (kb_clk_falling_edge = '1') then
         next_counter <= current_counter + 1;

         if current_counter = "1010" then
            next_counter <= "0000";
         end if;

         next_scan_code(6 downto 0) <= current_scan_code(7 downto 1);
         next_scan_code(7)          <= kb_data;

         next_valid_scan_code <= '0';
         if current_counter = "1000" then
            next_valid_scan_code <= '1';
         end if;

      else
         next_valid_scan_code <= current_valid_scan_code;
         next_counter         <= current_counter;
         next_scan_code       <= current_scan_code;
      end if;
   end process;

end architecture;
