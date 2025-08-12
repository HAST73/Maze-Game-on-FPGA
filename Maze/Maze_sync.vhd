----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:27:42 03/25/2025 
-- Design Name: 
-- Module Name:    Maze_sync - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Maze_sync is
    Port (
        CLK    : in  STD_LOGIC;
        HSYNC  : out STD_LOGIC;
        VSYNC  : out STD_LOGIC;
        RED    : out STD_LOGIC_VECTOR (0 downto 0);
        GREEN  : out STD_LOGIC_VECTOR (0 downto 0);
        BLUE   : out STD_LOGIC_VECTOR (0 downto 0);
        LED0   : out STD_LOGIC;
		  KEY_CODE    : in STD_LOGIC_VECTOR(7 downto 0);
		  KEY_PRESSED : in STD_LOGIC

    );
end Maze_sync;

architecture Behavioral of Maze_sync is

    -- Zmniejszony aktywny obszar: 600x440
    constant H_ACTIVE       : integer := 600;
    constant H_FRONT_PORCH  : integer := 31; -- 16 + 15 (przesuniêcie w prawo)
    constant H_SYNC_PULSE   : integer := 96;
    constant H_BACK_PORCH   : integer := 48;
    constant H_TOTAL        : integer := H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    constant V_ACTIVE       : integer := 440;
    constant V_FRONT_PORCH  : integer := 10;
    constant V_SYNC_PULSE   : integer := 2;
    constant V_BACK_PORCH   : integer := 33;
    constant V_TOTAL        : integer := V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    signal h_count, v_count : integer range 0 to 2047 := 0;

begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if h_count = H_TOTAL - 1 then
                h_count <= 0;
                if v_count = V_TOTAL - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;

    -- synchronizacja
    HSYNC <= '0' when (h_count >= H_ACTIVE + H_FRONT_PORCH and h_count < H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE) else '1';
    VSYNC <= '0' when (v_count >= V_ACTIVE + V_FRONT_PORCH and v_count < V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE) else '1';

    -- LED0 miga co ramkê
    LED0 <= '1' when v_count = 0 and h_count = 0 else '0';

    -- pod³¹czenie do generatora obrazu
    U1: entity work.Image_Generator
    port map (
        CLK     => CLK,
        h_count => h_count,
        v_count => v_count,
        RED     => RED,
        GREEN   => GREEN,
        BLUE    => BLUE,
		  KEY_CODE    => KEY_CODE,
        KEY_PRESSED => KEY_PRESSED
    );

end Behavioral;