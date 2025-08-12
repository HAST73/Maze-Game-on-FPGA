----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:33:04 03/24/2025 
-- Design Name: 
-- Module Name:    Maze_m - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Top-level module for VGA maze generator
--              Generates pixel clock using DCM, and routes video signals.
--
-- Dependencies: pll (DCM), Maze_sync
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Maze_m is
    Port (
        CLK    : in  STD_LOGIC;
        HSYNC  : out STD_LOGIC;
        VSYNC  : out STD_LOGIC;
        RED    : out STD_LOGIC_VECTOR (0 downto 0);
        GREEN  : out STD_LOGIC_VECTOR (0 downto 0);
        BLUE   : out STD_LOGIC_VECTOR (0 downto 0);
        LED0   : out STD_LOGIC;
		  PS2_Clk  : in STD_LOGIC;
		  PS2_Data : in STD_LOGIC
    );
end Maze_m;

architecture Behavioral of Maze_m is

    -- Component declaration for PLL/DCM
    component pll is
        port (
            CLKIN_IN   : in  std_logic;
            RST_IN     : in  std_logic;
            CLKFX_OUT  : out std_logic;
            LOCKED_OUT : out std_logic
        );
    end component;
	 
	 component PS2_Kbd
	     Port (
            PS2_Clk    : in  STD_LOGIC;
            PS2_Data   : in  STD_LOGIC;
            Clk_50MHz  : in  STD_LOGIC;
            Clk_Sys    : in  STD_LOGIC;
            DO         : out STD_LOGIC_VECTOR(7 downto 0);
            DO_Rdy     : out STD_LOGIC;
            E0         : out STD_LOGIC;
            F0         : out STD_LOGIC
        );
	 end component;

	 signal KEY_CODE    : STD_LOGIC_VECTOR(7 downto 0);
	 signal KEY_PRESSED : STD_LOGIC;

    signal CLK_PIXEL : std_logic;
    signal LOCKED    : std_logic;

    -- Keep LOCKED to avoid being optimized out
    attribute KEEP : string;
    attribute KEEP of LOCKED : signal is "true";

begin

    -- Instantiate PLL to generate 25MHz pixel clock from 50MHz input
    pixel_clock : pll
        port map (
            CLKIN_IN   => CLK,
            RST_IN     => '0',
            CLKFX_OUT  => CLK_PIXEL,
            LOCKED_OUT => LOCKED
        );

    -- Instantiate VGA sync/display module
    display : entity work.Maze_sync
	     port map (
            CLK         => CLK_PIXEL,
            HSYNC       => HSYNC,
            VSYNC       => VSYNC,
            RED         => RED,
            GREEN       => GREEN,
            BLUE        => BLUE,
            LED0        => open,
            KEY_CODE    => KEY_CODE,
            KEY_PRESSED => KEY_PRESSED
        );

    -- Route PLL lock status to LED0
    LED0 <= LOCKED;
	 
	 U_KBD: PS2_Kbd
        port map (
            PS2_Clk    => PS2_CLK,
            PS2_Data   => PS2_DATA,
            Clk_50MHz  => CLK,
            Clk_Sys    => CLK,
            DO         => KEY_CODE,
            DO_Rdy     => KEY_PRESSED,
            E0         => open,
            F0         => open
        );

end Behavioral;