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

    signal clk_108 : std_logic := '0';
    signal rst     : std_logic := '1';

    signal game_tick_edge : std_logic;

    signal vga_r  : std_logic_vector(3 downto 0);
    signal vga_g  : std_logic_vector(3 downto 0);
    signal vga_b  : std_logic_vector(3 downto 0);
    signal vga_hs : std_logic;
    signal vga_vs : std_logic;

    signal snake_matrix : matrix_64_80 := (others => (others => '0'));

begin

    clk_108 <= not clk_108 after period / 2;
    rst     <= '0' after period * 5;

    game_tick_gen : entity work.game_tick_gen
        generic map(
            countWidth => 4
        )
        port map(
            clk            => clk_108,
            rst            => rst,
            game_tick_edge => game_tick_edge
        );

    vga_controller : entity work.vga_controller
        port map(
            clk_108      => clk_108,
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
