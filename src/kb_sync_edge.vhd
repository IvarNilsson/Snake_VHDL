-------------------------------------------------------------------------------
-- Title      : sync_keyboard.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity kb_sync_edge is
    port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        kb_clk_raw          : in std_logic;
        kb_data_raw         : in std_logic;
        kb_clk_falling_edge : out std_logic;
        kb_data             : out std_logic
    );
end kb_sync_edge;

architecture rtl of kb_sync_edge is
    signal kb_clk_d  : std_logic;
    signal kb_clk_dd : std_logic;

    signal kb_data_sync_d  : std_logic;
    signal kb_data_sync_dd : std_logic;

begin

    kb_clk_falling_edge <= (not kb_clk_d) and kb_clk_dd;
    kb_data             <= kb_data_sync_dd;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                kb_clk_d        <= '0';
                kb_clk_dd       <= '0';
                kb_data_sync_d  <= '0';
                kb_data_sync_dd <= '0';

            else
                kb_clk_d  <= kb_clk_raw;
                kb_clk_dd <= kb_clk_d;

                kb_data_sync_d  <= kb_data_raw;
                kb_data_sync_dd <= kb_data_sync_d;
            end if;
        end if;
    end process;
end architecture;
