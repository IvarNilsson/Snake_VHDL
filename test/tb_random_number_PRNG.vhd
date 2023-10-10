library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_random_number_PRNG is
   generic (
      runner_cfg : string
   );
end tb_random_number_PRNG;

architecture tb of tb_random_number_PRNG is

   constant max_segments : integer := 128;

   constant period : time := 10 ns;

   signal clk_108 : std_logic := '0';
   signal rst     : std_logic := '1';

   signal rand_32 : unsigned(5 downto 0);
   signal rand_40 : unsigned(5 downto 0);

begin

   clk_108 <= not clk_108 after period / 2;
   rst     <= '0' after period * 5;

   random_number_PRNG : entity work.random_number_PRNG
      port map(
         clk     => clk_108,
         rst     => rst,
         rand_32 => rand_32,
         rand_40 => rand_40
      );

   main_p : process
   begin
      test_runner_setup(runner, runner_cfg);
      while test_suite loop
         if run("wave") then

            wait for 350000 ns;

         elsif run("long") then

            wait for 350000 ns;

         elsif run("auto") then

            wait for 350000 ns;

            --check(counter_mealy = expected_res, "mealy wrong expected: " & to_string(expected_res) & "   got: " & to_string(counter_mealy), warning);
            --check(counter_moore = expected_res, "moore wrong expected: " & to_string(expected_res) & "   got: " & to_string(counter_moore), warning);
            info("test done");
         end if;
      end loop;

      test_runner_cleanup(runner);
   end process;

   test_runner_watchdog(runner, 100 ms);

end architecture;
