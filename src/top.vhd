library ieee;
use ieee.std_logic_1164.all;

library work;
use work.matrix_type.all;

entity top is
    generic (
        countWidth : integer := 19
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        led : out std_logic_vector(15 downto 0)
    );
end top;

architecture structural of top is

begin

    led <= (others => not rst);

end structural;