library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity clk_wiz_wrapper is
   port (
      clk_108   : out std_logic;
      rst       : in std_logic;
      sys_clock : in std_logic
   );
end clk_wiz_wrapper;

architecture STRUCTURE of clk_wiz_wrapper is
   component clk_wiz is
      port (
         rst       : in std_logic;
         sys_clock : in std_logic;
         clk_108   : out std_logic
      );
   end component clk_wiz;
begin
   clk_wiz_i : component clk_wiz
      port map(
         clk_108   => clk_108,
         rst       => rst,
         sys_clock => sys_clock
      );
   end STRUCTURE;
