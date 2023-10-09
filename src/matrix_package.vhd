library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package matrix_type is
   --type matrix_640_4 is array (639 downto 0) of std_logic_vector(3 downto 0);
   --type matrix_480_640_4 is array (479 downto 0) of matrix_640_4;

   --type matrix_20_20 is array (19 downto 0) of std_logic_vector(19 downto 0);
   --   type matrix_64_80 is array (63 downto 0) of std_logic_vector(79 downto 0);
   type matrix_32_40 is array (31 downto 0) of std_logic_vector(39 downto 0);
   type posision_type is array (128 - 1 downto 0) of unsigned(5 downto 0); -- only 6 bits needed

end package matrix_type;
