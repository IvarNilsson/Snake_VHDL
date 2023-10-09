library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity random_number_PRNG is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        rand_32 : out unsigned(5 downto 0);
        rand_40 : out unsigned(5 downto 0)
    );
end random_number_PRNG;

architecture rtl of random_number_PRNG is
    signal prng_reg             : std_logic_vector(7 downto 0);
    signal prng_val1, prng_val2 : unsigned(5 downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
            prng_reg <= "10001000";
        elsif rising_edge(clk) then
            prng_reg <= prng_reg(6 downto 0) & (prng_reg(7) xor prng_reg(2));
        end if;
    end process;

    prng_val1 <= unsigned(prng_reg(5 downto 0));               -- Extract 6-bit random value for prng_out1
    prng_val2 <= unsigned(prng_reg(4 downto 0) & prng_reg(7)); -- Extract 6-bit random value for prng_out2

    process (prng_val1, prng_val2)
    begin
        if prng_val1 <= 32 then -- 0 to 32 in binary
            rand_32 <= prng_val1;
        else
            rand_32 <= unsigned('0' & prng_val1(4 downto 0));
        end if;

        if prng_val2 <= 40 then -- 0 to 40 in binary
            rand_40 <= prng_val2;
        else
            rand_40 <= unsigned('0' & prng_val2(4 downto 0));
        end if;
    end process;
end architecture;
