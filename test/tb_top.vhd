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

entity tb_top is
    generic (
        runner_cfg : string
    );
end tb_top;

architecture tb of tb_top is
    constant period : time := 10 ns;

    signal clk_100 : std_logic := '0';
    signal clk_25  : std_logic := '0';
    signal rst     : std_logic := '1';

    signal vga_r  : std_logic_vector(3 downto 0);
    signal vga_g  : std_logic_vector(3 downto 0);
    signal vga_b  : std_logic_vector(3 downto 0);
    signal vga_hs : std_logic;
    signal vga_vs : std_logic;

    signal snake_matrix : matrix_20_20;

begin

    clk_100 <= not clk_100 after period / 2;
    clk_25  <= not clk_25 after period / 2 * 4;
    rst     <= '0' after period * 5;

    vga_test_gen : entity work.vga_test_gen
        generic map(
            countWidth => 2
        )
        port map(
            clk          => clk_100,
            rst          => rst,
            snake_matrix => snake_matrix
        );

    vga_controller : entity work.vga_controller
        port map(
            clk_25       => clk_25,
            rst          => rst,
            snake_matrix => snake_matrix,
            vga_r        => vga_r,
            vga_g        => vga_g,
            vga_b        => vga_b,
            vga_hs       => vga_hs,
            vga_vs       => vga_vs
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
