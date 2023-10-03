--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
--Date        : Tue Oct  3 09:23:05 2023
--Host        : jokern running 64-bit Ubuntu 22.04.3 LTS
--Command     : generate_target clk_wiz_wrapper.bd
--Design      : clk_wiz_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_wrapper is
  port (
    clk_100 : out STD_LOGIC;
    clk_25 : out STD_LOGIC;
    rst : in STD_LOGIC;
    sys_clock : in STD_LOGIC
  );
end clk_wiz_wrapper;

architecture STRUCTURE of clk_wiz_wrapper is
  component clk_wiz is
  port (
    rst : in STD_LOGIC;
    sys_clock : in STD_LOGIC;
    clk_100 : out STD_LOGIC;
    clk_25 : out STD_LOGIC
  );
  end component clk_wiz;
begin
clk_wiz_i: component clk_wiz
     port map (
      clk_100 => clk_100,
      clk_25 => clk_25,
      rst => rst,
      sys_clock => sys_clock
    );
end STRUCTURE;
