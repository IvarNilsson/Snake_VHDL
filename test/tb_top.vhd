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

    signal key_controll : std_logic_vector(3 downto 0);
    signal movment      : std_logic_vector(3 downto 0);

    signal game_tick_edge         : std_logic;
    signal prepare_game_tick_edge : std_logic;
    signal after_game_tick_edge   : std_logic;

    signal add_segment_edge : std_logic := '0';

    signal vga_r  : std_logic_vector(3 downto 0);
    signal vga_g  : std_logic_vector(3 downto 0);
    signal vga_b  : std_logic_vector(3 downto 0);
    signal vga_hs : std_logic;
    signal vga_vs : std_logic;

    signal snake_matrix : matrix_64_80 := (others => (others => '0'));

    signal snake_0  : std_logic_vector(79 downto 0);
    signal snake_1  : std_logic_vector(79 downto 0);
    signal snake_2  : std_logic_vector(79 downto 0);
    signal snake_3  : std_logic_vector(79 downto 0);
    signal snake_4  : std_logic_vector(79 downto 0);
    signal snake_5  : std_logic_vector(79 downto 0);
    signal snake_6  : std_logic_vector(79 downto 0);
    signal snake_7  : std_logic_vector(79 downto 0);
    signal snake_8  : std_logic_vector(79 downto 0);
    signal snake_9  : std_logic_vector(79 downto 0);
    signal snake_10 : std_logic_vector(79 downto 0);
    signal snake_11 : std_logic_vector(79 downto 0);
    signal snake_12 : std_logic_vector(79 downto 0);
    signal snake_13 : std_logic_vector(79 downto 0);
    signal snake_14 : std_logic_vector(79 downto 0);
    signal snake_15 : std_logic_vector(79 downto 0);
    signal snake_16 : std_logic_vector(79 downto 0);
    signal snake_17 : std_logic_vector(79 downto 0);
    signal snake_18 : std_logic_vector(79 downto 0);
    signal snake_19 : std_logic_vector(79 downto 0);
    signal snake_20 : std_logic_vector(79 downto 0);
    signal snake_21 : std_logic_vector(79 downto 0);
    signal snake_22 : std_logic_vector(79 downto 0);
    signal snake_23 : std_logic_vector(79 downto 0);
    signal snake_24 : std_logic_vector(79 downto 0);
    signal snake_25 : std_logic_vector(79 downto 0);
    signal snake_26 : std_logic_vector(79 downto 0);
    signal snake_27 : std_logic_vector(79 downto 0);
    signal snake_28 : std_logic_vector(79 downto 0);
    signal snake_29 : std_logic_vector(79 downto 0);
    signal snake_30 : std_logic_vector(79 downto 0);
    signal snake_31 : std_logic_vector(79 downto 0);
    signal snake_32 : std_logic_vector(79 downto 0);
    signal snake_33 : std_logic_vector(79 downto 0);
    signal snake_34 : std_logic_vector(79 downto 0);
    signal snake_35 : std_logic_vector(79 downto 0);
    signal snake_36 : std_logic_vector(79 downto 0);
    signal snake_37 : std_logic_vector(79 downto 0);
    signal snake_38 : std_logic_vector(79 downto 0);
    signal snake_39 : std_logic_vector(79 downto 0);
    signal snake_40 : std_logic_vector(79 downto 0);
    signal snake_41 : std_logic_vector(79 downto 0);
    signal snake_42 : std_logic_vector(79 downto 0);
    signal snake_43 : std_logic_vector(79 downto 0);
    signal snake_44 : std_logic_vector(79 downto 0);
    signal snake_45 : std_logic_vector(79 downto 0);
    signal snake_46 : std_logic_vector(79 downto 0);
    signal snake_47 : std_logic_vector(79 downto 0);
    signal snake_48 : std_logic_vector(79 downto 0);
    signal snake_49 : std_logic_vector(79 downto 0);
    signal snake_50 : std_logic_vector(79 downto 0);
    signal snake_51 : std_logic_vector(79 downto 0);
    signal snake_52 : std_logic_vector(79 downto 0);
    signal snake_53 : std_logic_vector(79 downto 0);
    signal snake_54 : std_logic_vector(79 downto 0);
    signal snake_55 : std_logic_vector(79 downto 0);
    signal snake_56 : std_logic_vector(79 downto 0);
    signal snake_57 : std_logic_vector(79 downto 0);
    signal snake_58 : std_logic_vector(79 downto 0);
    signal snake_59 : std_logic_vector(79 downto 0);
    signal snake_60 : std_logic_vector(79 downto 0);
    signal snake_61 : std_logic_vector(79 downto 0);
    signal snake_62 : std_logic_vector(79 downto 0);
    signal snake_63 : std_logic_vector(79 downto 0);

begin

    clk_108 <= not clk_108 after period / 2;
    rst     <= '0' after period * 5;

    process (all)
    begin
        if (add_segment_edge = '1') then
            add_segment_edge <= not add_segment_edge after period;
        else
            add_segment_edge <= not add_segment_edge after period * 400;
        end if;
    end process;

    snake_0  <= snake_matrix(0);
    snake_1  <= snake_matrix(1);
    snake_2  <= snake_matrix(2);
    snake_3  <= snake_matrix(3);
    snake_4  <= snake_matrix(4);
    snake_5  <= snake_matrix(5);
    snake_6  <= snake_matrix(6);
    snake_7  <= snake_matrix(7);
    snake_8  <= snake_matrix(8);
    snake_9  <= snake_matrix(9);
    snake_10 <= snake_matrix(10);
    snake_11 <= snake_matrix(11);
    snake_12 <= snake_matrix(12);
    snake_13 <= snake_matrix(13);
    snake_14 <= snake_matrix(14);
    snake_15 <= snake_matrix(15);
    snake_16 <= snake_matrix(16);
    snake_17 <= snake_matrix(17);
    snake_18 <= snake_matrix(18);
    snake_19 <= snake_matrix(19);
    snake_20 <= snake_matrix(20);
    snake_21 <= snake_matrix(21);
    snake_22 <= snake_matrix(22);
    snake_23 <= snake_matrix(23);
    snake_24 <= snake_matrix(24);
    snake_25 <= snake_matrix(25);
    snake_26 <= snake_matrix(26);
    snake_27 <= snake_matrix(27);
    snake_28 <= snake_matrix(28);
    snake_29 <= snake_matrix(29);
    snake_30 <= snake_matrix(30);
    snake_31 <= snake_matrix(31);
    snake_32 <= snake_matrix(32);
    snake_33 <= snake_matrix(33);
    snake_34 <= snake_matrix(34);
    snake_35 <= snake_matrix(35);
    snake_36 <= snake_matrix(36);
    snake_37 <= snake_matrix(37);
    snake_38 <= snake_matrix(38);
    snake_39 <= snake_matrix(39);
    snake_40 <= snake_matrix(40);
    snake_41 <= snake_matrix(41);
    snake_42 <= snake_matrix(42);
    snake_43 <= snake_matrix(43);
    snake_44 <= snake_matrix(44);
    snake_45 <= snake_matrix(45);
    snake_46 <= snake_matrix(46);
    snake_47 <= snake_matrix(47);
    snake_48 <= snake_matrix(48);
    snake_49 <= snake_matrix(49);
    snake_50 <= snake_matrix(50);
    snake_51 <= snake_matrix(51);
    snake_52 <= snake_matrix(52);
    snake_53 <= snake_matrix(53);
    snake_54 <= snake_matrix(54);
    snake_55 <= snake_matrix(55);
    snake_56 <= snake_matrix(56);
    snake_57 <= snake_matrix(57);
    snake_58 <= snake_matrix(58);
    snake_59 <= snake_matrix(59);
    snake_60 <= snake_matrix(60);
    snake_61 <= snake_matrix(61);
    snake_62 <= snake_matrix(62);
    snake_63 <= snake_matrix(63);

    kb_ctrl_stimuli : entity work.kb_ctrl_stimuli
        port map(
            clk          => clk_108,
            rst          => rst,
            key_controll => key_controll
        );

    kb_game_tick : entity work.kb_game_tick
        port map(
            clk                    => clk_108,
            rst                    => rst,
            prepare_game_tick_edge => prepare_game_tick_edge,
            key_controll           => key_controll,
            movment                => movment
        );

    game_tick_gen : entity work.game_tick_gen
        generic map(
            countWidth => 3
        )
        port map(
            clk                    => clk_108,
            rst                    => rst,
            prepare_game_tick_edge => prepare_game_tick_edge,
            game_tick_edge         => game_tick_edge,
            after_game_tick_edge   => after_game_tick_edge
        );

    --movment_engine : entity work.movment_engine
    --    port map(
    --        clk            => clk_108,
    --        rst            => rst,
    --        game_tick_edge => game_tick_edge,
    --        movment        => movment,
    --        snake_matrix   => snake_matrix
    --    );

    segments : entity work.segments
        port map(
            clk              => clk_108,
            rst              => rst,
            game_tick_edge   => game_tick_edge,
            movment          => movment,
            add_segment_edge => add_segment_edge,
            snake_matrix     => snake_matrix
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
