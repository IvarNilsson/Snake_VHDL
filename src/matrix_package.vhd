library ieee;
use ieee.std_logic_1164.all;
package matrix_type is
   --type matrix_640_4 is array (639 downto 0) of std_logic_vector(3 downto 0);
   --type matrix_480_640_4 is array (479 downto 0) of matrix_640_4;

   type matrix_20_20 is array (19 downto 0) of std_logic_vector(19 downto 0);
end package matrix_type;
