library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.matrix_type.all;

-- VESA Signal 1280 x 1024 @ 60 Hz timing
entity vga_controller is
   generic (
      max_segments : integer := 32
   );
   port (
      clk_108       : in std_logic;
      rst           : in std_logic;
      apple_x       : in unsigned(5 downto 0);
      apple_y       : in unsigned(5 downto 0);
      snake_x_array : in posision_type;
      snake_y_array : in posision_type;
      snake_size    : in unsigned(7 downto 0);
      end_game      : in std_logic;
      vga_r         : out std_logic_vector(3 downto 0);
      vga_g         : out std_logic_vector(3 downto 0);
      vga_b         : out std_logic_vector(3 downto 0);
      vga_hs        : out std_logic;
      vga_vs        : out std_logic
   );
end vga_controller;

architecture rtl of vga_controller is

   constant pixel_size      : integer := 32;
   constant pixel_size_half : integer := 16;

   --11 bits: 0 to 2047
   signal current_h_cnt : unsigned(10 downto 0); -- 640 (active video) + 16 (front porch) + 96 (sync_pulse) + 48 (back porch) = 800
   signal next_h_cnt    : unsigned(10 downto 0); -- 1280 Active + 48 Front porch + 112 Sync pulse + Back porch 248 = 1688

   signal current_v_cnt : unsigned(10 downto 0); -- 400 (active video) + 12 (front porch) + 2 (sync_pulse)+ 35 (back porch) = 449
   signal next_v_cnt    : unsigned(10 downto 0); -- 1024 Active + 1 Front porch + 3 Sync pulse + 38 back porch = 1066

begin

   vga_hs <= '0' when current_h_cnt >= 1328 and current_h_cnt < 1440 else
      '1';
   vga_vs <= '1' when current_v_cnt >= 1025 and current_v_cnt < 1028 else
      '0';

   reg : process (clk_108)
   begin
      if rising_edge(clk_108) then
         if rst = '1' then
            current_h_cnt <= (others => '0');
            current_v_cnt <= (others => '0');
         else
            current_h_cnt <= next_h_cnt;
            current_v_cnt <= next_v_cnt;
         end if;
      end if;
   end process;

   comb_count : process (current_h_cnt, current_v_cnt)
   begin
      next_h_cnt <= current_h_cnt + 1;
      next_v_cnt <= current_v_cnt;

      if (current_h_cnt < 1688) then
         next_h_cnt <= current_h_cnt + 1;
      else
         next_h_cnt <= (others => '0');
         if (current_v_cnt < 1066) then
            next_v_cnt <= current_v_cnt + 1;
         else
            next_v_cnt <= (others => '0');
         end if;
      end if;
   end process;

   rgb_comb : process (all)
      variable temp_snake_x : unsigned(11 downto 0);
      variable temp_snake_y : unsigned(11 downto 0);
      variable temp_apple_x : unsigned(11 downto 0);
      variable temp_apple_y : unsigned(11 downto 0);
      variable dx           : signed(11 downto 0);
      variable dy           : signed(11 downto 0);
      variable pixel_body   : std_logic;
      variable pixel_food   : std_logic;
   begin
      vga_r <= (others => '0');
      vga_g <= (others => '0');
      vga_b <= (others => '0');

      if (current_h_cnt < 1280 and current_v_cnt < 1024) then -- active region
         vga_r <= x"9";
         vga_g <= x"d";
         vga_b <= x"7";

         pixel_body := '0';
         pixel_food := '0';

         for i in 0 to max_segments - 1 loop
            temp_snake_x := (snake_x_array(i) * to_unsigned(pixel_size, 6));
            temp_snake_y := (snake_y_array(i) * to_unsigned(pixel_size, 6));
            dx           := abs(signed('0' & current_h_cnt - temp_snake_x + to_unsigned(pixel_size_half, 12)));
            dy           := abs(signed('0' & current_v_cnt - temp_snake_y + to_unsigned(pixel_size_half, 12)));
            if (i < snake_size) then
               if (dx < to_signed(pixel_size_half, 12) and dy < to_signed(pixel_size_half, 12)) then
                  pixel_body := '1';
               end if;
            end if;
         end loop;

         temp_apple_x := (apple_x * to_unsigned(pixel_size, 6));
         temp_apple_y := (apple_y * to_unsigned(pixel_size, 6));
         dx           := abs(signed('0' & current_h_cnt - temp_apple_x + to_unsigned(pixel_size_half, 12)));
         dy           := abs(signed('0' & current_v_cnt - temp_apple_y + to_unsigned(pixel_size_half, 12)));
         if (dx < to_signed(pixel_size_half, 12) and dy < to_signed(pixel_size_half, 12)) then
            pixel_food := '1';
         end if;

         if (pixel_body = '1' and end_game = '1') then
            vga_r <= x"F";
            vga_g <= x"F";
            vga_b <= x"F";
         elsif (pixel_body = '1') then
            vga_r <= x"2";
            vga_g <= x"2";
            vga_b <= x"2";
         elsif (pixel_food = '1' and end_game = '1') then
            vga_r <= x"0";
            vga_g <= x"0";
            vga_b <= x"0";
         elsif (pixel_food = '1') then
            vga_r <= x"f";
            vga_g <= x"0";
            vga_b <= x"0";
         end if;
      end if;
   end process;

end architecture;
