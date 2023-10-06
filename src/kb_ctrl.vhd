library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity kb_ctrl is
   port (
      clk             : in std_logic;
      rst             : in std_logic;
      valid_scan_code : in std_logic;
      scan_code_in    : in std_logic_vector(7 downto 0);
      key_controll    : out std_logic_vector(3 downto 0) -- up, down, left, right
   );
end kb_ctrl;

architecture rtl of kb_ctrl is

   type state_type is (idle, up, down, left, right);
   signal current_state : state_type;
   signal next_state    : state_type;

   signal valid_scan_code_edge : std_logic;
   signal valid_scan_code_d    : std_logic;

   constant up_code    : std_logic_vector(7 downto 0) := x"75";
   constant down_code  : std_logic_vector(7 downto 0) := x"72";
   constant left_code  : std_logic_vector(7 downto 0) := x"6B";
   constant right_code : std_logic_vector(7 downto 0) := x"74";
   constant space_code : std_logic_vector(7 downto 0) := x"29";

begin
   valid_scan_code_edge <= (not valid_scan_code_d) and valid_scan_code;

   reg : process (clk, rst)
   begin
      if rising_edge(clk) then
         if (rst = '1') then
            valid_scan_code_d <= '1';
            current_state     <= idle;
         else
            valid_scan_code_d <= valid_scan_code;
            current_state     <= next_state;
         end if;
      end if;
   end process;

   comb_state : process (current_state, valid_scan_code_edge, scan_code_in)
   begin
      next_state   <= current_state;
      key_controll <= (others => '0');

      case current_state is
         when idle =>
            if (valid_scan_code_edge = '1') then
               if (scan_code_in = up_code) then
                  next_state <= up;
               elsif (scan_code_in = down_code) then
                  next_state <= down;
               elsif (scan_code_in = left_code) then
                  next_state <= left;
               elsif (scan_code_in = right_code) then
                  next_state <= right;
               end if;
            end if;

         when up =>
            key_controll <= "1000";
            if (valid_scan_code_edge = '1') then
               if (scan_code_in = space_code) then
                  next_state <= idle;
               elsif (scan_code_in = left_code) then
                  next_state <= left;
               elsif (scan_code_in = right_code) then
                  next_state <= right;
               end if;
            end if;

         when down =>
            key_controll <= "0100";
            if (valid_scan_code_edge = '1') then
               if (scan_code_in = space_code) then
                  next_state <= idle;
               elsif (scan_code_in = left_code) then
                  next_state <= left;
               elsif (scan_code_in = right_code) then
                  next_state <= right;
               end if;
            end if;

         when left =>
            key_controll <= "0010";
            if (valid_scan_code_edge = '1') then
               if (scan_code_in = space_code) then
                  next_state <= idle;
               elsif (scan_code_in = up_code) then
                  next_state <= up;
               elsif (scan_code_in = down_code) then
                  next_state <= down;
               end if;
            end if;

         when right =>
            key_controll <= "0001";
            if (valid_scan_code_edge = '1') then
               if (scan_code_in = space_code) then
                  next_state <= idle;
               elsif (scan_code_in = up_code) then
                  next_state <= up;
               elsif (scan_code_in = down_code) then
                  next_state <= down;
               end if;
            end if;

         when others =>
            report("error_1");
      end case;
   end process;
end architecture;
