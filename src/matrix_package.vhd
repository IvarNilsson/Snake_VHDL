library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package matrix_type is

   type matrix_32_40 is array (31 downto 0) of std_logic_vector(39 downto 0);
   type posision_type is array (128 - 1 downto 0) of unsigned(5 downto 0); -- only 6 bits needed

end package matrix_type;
