-------------------------------------------------------------------------------
-- Title      : tb_keyboard 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-- File       : tracking_top.vhd
-- Author     : Hemanth Prabhu
-- Company    : Lund University
-- Created    : 2013-08-17
-- Last update: 201x-0x-xx
-- Platform   : Modelsim
-------------------------------------------------------------------------------
-- Description: 
-- 		Testbench to emulate keyboard, seven segement display, led !!
-- 		Keyboard stimulus from input.txt
--		led and seven segment output is written into output_x.txt files
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Lund University
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use std.textio.all;
--use ieee.std_logic_textio.all;
use work.matrix_type.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_lab2 is
    generic (
        runner_cfg : string
    );
end tb_lab2;

architecture tb of tb_lab2 is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal led : std_logic_vector(15 downto 0);

begin
   
    top : entity work.top
    port map (
        clk => clk,
        rst => rst,
        led => led
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