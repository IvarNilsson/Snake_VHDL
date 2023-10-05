library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity kb_game_tick is
    port (
        clk                    : in std_logic;
        rst                    : in std_logic;
        prepare_game_tick_edge : in std_logic;
        key_controll           : in std_logic_vector(3 downto 0); -- up, down, left, right
        movment                : out std_logic_vector(3 downto 0)
    );
end kb_game_tick;

architecture rtl of kb_game_tick is

    type state_type is (idle, up, down, left, right);
    signal current_state : state_type;
    signal next_state    : state_type;

    signal current_movment : std_logic_vector(3 downto 0);
    signal next_movment    : std_logic_vector(3 downto 0);

begin
    movment <= current_movment;

    reg : process (clk, rst)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                current_movment <= (others => '0');
                current_state   <= idle;
            else
                current_movment <= next_movment;
                current_state   <= next_state;
            end if;
        end if;
    end process;

    comb_state : process (current_state, current_movment, prepare_game_tick_edge, key_controll)
    begin
        next_state   <= current_state;
        next_movment <= (others => '0');

        case current_state is
            when idle =>
                next_movment <= "0000";
                if (prepare_game_tick_edge = '1') then
                    if (key_controll = "1000") then
                        next_state <= up;
                    elsif (key_controll = "0100") then
                        next_state <= down;
                    elsif (key_controll = "0010") then
                        next_state <= left;
                    elsif (key_controll = "0001") then
                        next_state <= right;
                    end if;
                end if;

            when up =>
                next_movment <= "1000";
                if (prepare_game_tick_edge = '1') then
                    if (key_controll = "0000") then
                        next_state <= idle;
                    elsif (key_controll = "0010") then
                        next_state <= left;
                    elsif (key_controll = "0001") then
                        next_state <= right;
                    end if;
                end if;

            when down =>
                next_movment <= "0100";
                if (prepare_game_tick_edge = '1') then
                    if (key_controll = "0000") then
                        next_state <= idle;
                    elsif (key_controll = "0010") then
                        next_state <= left;
                    elsif (key_controll = "0001") then
                        next_state <= right;
                    end if;
                end if;

            when left =>
                next_movment <= "0010";
                if (prepare_game_tick_edge = '1') then
                    if (key_controll = "0000") then
                        next_state <= idle;
                    elsif (key_controll = "1000") then
                        next_state <= up;
                    elsif (key_controll = "0100") then
                        next_state <= down;
                    end if;
                end if;

            when right =>
                next_movment <= "0001";
                if (prepare_game_tick_edge = '1') then
                    if (key_controll = "0000") then
                        next_state <= idle;
                    elsif (key_controll = "1000") then
                        next_state <= up;
                    elsif (key_controll = "0100") then
                        next_state <= down;
                    end if;
                end if;

            when others =>
                report("error_1");
        end case;
    end process;
end architecture;
