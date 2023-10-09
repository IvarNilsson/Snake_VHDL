library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_kb_sync_edge is
    generic (
        runner_cfg : string
    );
end tb_kb_sync_edge;

architecture tb of tb_kb_sync_edge is
    constant period : time := 10 ns;

    signal clk                 : std_logic := '0';
    signal rst                 : std_logic := '1';
    signal kb_clk_raw          : std_logic := '0';
    signal kb_data_raw         : std_logic := '0';
    signal kb_clk_falling_edge : std_logic;
    signal kb_data             : std_logic;

begin

    clk <= not clk after period;
    rst <= '0' after period * 2;

    kb_clk_raw <= not kb_clk_raw after period * 5;
    kb_data_raw    <= kb_clk_raw;

    kb_sync_edge : entity work.kb_sync_edge
        port map(
            clk                 => clk,
            rst                 => rst,
            kb_clk_raw          => kb_clk_raw,
            kb_data_raw         => kb_data_raw,
            kb_clk_falling_edge => kb_clk_falling_edge,
            kb_data             => kb_data
        );

    main_p : process
    begin
        test_runner_setup(runner, runner_cfg);
        while test_suite loop
            if run("wave") then

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
