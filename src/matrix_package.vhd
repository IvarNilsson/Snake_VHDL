library ieee;
use ieee.std_logic_1164.all;
package matrix_type is
   type matrix_lab_1_std_vector_type is array (840 downto 0) of std_logic_vector(3 downto 0);
   type matrix_4_8 is array (3 downto 0) of std_logic_vector(7 downto 0);
   --type matrix_4_24_type is array (3 downto 0) of std_logic_vector(23 downto 0);
end package matrix_type;