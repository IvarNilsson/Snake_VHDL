library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrix_type.all;

entity top is
   generic (
      countWidth : integer := 23
   );
   port (
      sys_clk     : in std_logic;
      rst         : in std_logic;
      kb_clk_raw  : in std_logic;
      kb_data_raw : in std_logic;
      led         : out std_logic_vector(15 downto 0);
      vga_r       : out std_logic_vector(3 downto 0);
      vga_g       : out std_logic_vector(3 downto 0);
      vga_b       : out std_logic_vector(3 downto 0);
      vga_hs      : out std_logic;
      vga_vs      : out std_logic
   );
end top;

architecture structural of top is

   constant max_segments : integer := 128;

   signal clk_108 : std_logic;
   --signal rst     : std_logic; -- active high

   signal game_tick_edge         : std_logic;
   signal prepare_game_tick_edge : std_logic;
   signal after_game_tick_edge   : std_logic;

   signal kb_clk_falling_edge : std_logic;
   signal kb_data             : std_logic;
   signal valid_scan_code     : std_logic;
   signal scan_code           : std_logic_vector(7 downto 0);
   signal key_controll        : std_logic_vector(3 downto 0);
   signal movment             : std_logic_vector(3 downto 0);

   signal snake_x_array : posision_type;
   signal snake_y_array : posision_type;
   signal snake_size    : unsigned(7 downto 0);
   signal apple_x       : unsigned(5 downto 0);
   signal apple_y       : unsigned(5 downto 0);

   signal end_game : std_logic;

begin
   --rst              <= not rst_avtive_low;
   led(14 downto 4) <= (others => rst);
   led(15)          <= end_game;
   led(3 downto 0)  <= key_controll;

   kb_sync_edge : entity work.kb_sync_edge
      port map(
         clk                 => clk_108,
         rst                 => rst,
         kb_clk_raw          => kb_clk_raw,
         kb_data_raw         => kb_data_raw,
         kb_clk_falling_edge => kb_clk_falling_edge,
         kb_data             => kb_data
      );

   kb_scancode : entity work.kb_scancode
      port map(
         clk                 => clk_108,
         rst                 => rst,
         kb_clk_falling_edge => kb_clk_falling_edge,
         kb_data             => kb_data,
         valid_scan_code     => valid_scan_code,
         scan_code_out       => scan_code
      );

   kb_ctrl : entity work.kb_ctrl
      port map(
         clk             => clk_108,
         rst             => rst,
         valid_scan_code => valid_scan_code,
         scan_code_in    => scan_code,
         key_controll    => key_controll
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
         countWidth => countWidth
      )
      port map(
         clk                    => clk_108,
         rst                    => rst,
         prepare_game_tick_edge => prepare_game_tick_edge,
         game_tick_edge         => game_tick_edge,
         after_game_tick_edge   => after_game_tick_edge

      );

   segments : entity work.segments
      generic map(
         max_segments => max_segments
      )
      port map(
         clk                  => clk_108,
         rst                  => rst,
         after_game_tick_edge => after_game_tick_edge,
         movment              => movment,
         apple_x              => apple_x,
         apple_y              => apple_y,
         snake_x_array        => snake_x_array,
         snake_y_array        => snake_y_array,
         snake_size           => snake_size,
         end_game             => end_game
      );

   vga_controller : entity work.vga_controller
      generic map(
         max_segments => max_segments
      )
      port map(
         clk_108       => clk_108,
         rst           => rst,
         apple_x       => apple_x,
         apple_y       => apple_y,
         snake_x_array => snake_x_array,
         snake_y_array => snake_y_array,
         snake_size    => snake_size,
         end_game      => end_game,
         vga_r         => vga_r,
         vga_g         => vga_g,
         vga_b         => vga_b,
         vga_hs        => vga_hs,
         vga_vs        => vga_vs
      );

   clk_wiz_wrapper : entity work.clk_wiz_wrapper
      port map(
         sys_clock => sys_clk,
         rst       => rst,
         clk_108   => clk_108
      );

end architecture;
