library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity kb_ctrl_stimuli is
    port (
        clk          : in std_logic;
        rst          : in std_logic;
        key_controll : out std_logic_vector(3 downto 0) -- up, down, left, right
    );
end kb_ctrl_stimuli;

architecture rtl of kb_ctrl_stimuli is

    type state_type is (idle, up, down, left, right);
    signal current_state : state_type;
    signal next_state    : state_type;

    signal current_count : integer;
    signal next_count    : integer;

begin
    reg : process (clk, rst)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                current_count <= 0;
                current_state <= idle;
            else
                current_count <= next_count;
                current_state <= next_state;
            end if;
        end if;
    end process;

    comb_state : process (current_state, current_count)
    begin
        next_state   <= current_state;
        key_controll <= (others => '0');
        next_count   <= current_count + 1;

        case current_state is
            when idle =>
                if (current_count = 16 - 1) then
                    next_state <= up;
                end if;

            when up =>
                key_controll <= "1000";
                if (current_count = 16 * 7 - 1) then
                    next_state <= left;
                end if;

            when left =>
                key_controll <= "0010";
                if (current_count = 16 * 13 - 1) then
                    next_state <= down;
                end if;

            when down =>
                key_controll <= "0100";
                if (current_count = 16 * 19 - 1) then
                    next_state <= right;
                end if;

            when right =>
                key_controll <= "0001";
                if (current_count = 16 * 25 - 1) then
                    next_state <= idle;
                    next_count <= 0;
                end if;

            when others =>
                report("error_1");
        end case;
    end process;
end architecture;
