library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity pll is
    Port (
        CLKIN_IN    : in  STD_LOGIC;
        RST_IN      : in  STD_LOGIC;
        CLKFX_OUT   : out STD_LOGIC;
        LOCKED_OUT  : out STD_LOGIC
    );
end pll;

architecture Behavioral of pll is

    signal CLKFB      : STD_LOGIC;
    signal CLK0_BUF   : STD_LOGIC;
    signal CLKFX_BUF  : STD_LOGIC;
    signal CLKFX_INT  : STD_LOGIC;

begin

    DCM_inst : DCM
        generic map (
            CLK_FEEDBACK        => "1X",
            CLKDV_DIVIDE        => 2.0,
            CLKFX_DIVIDE        => 8,
            CLKFX_MULTIPLY      => 4,
            CLKIN_DIVIDE_BY_2   => FALSE,
            CLKIN_PERIOD        => 20.0,
            CLKOUT_PHASE_SHIFT  => "NONE",
            DESKEW_ADJUST       => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE  => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            STARTUP_WAIT        => FALSE
        )
        port map (
            CLKIN    => CLKIN_IN,
            CLKFB    => CLKFB,
            RST      => RST_IN,
            CLK0     => CLK0_BUF,
            CLKFX    => CLKFX_BUF,
            LOCKED   => LOCKED_OUT,
            CLKDV    => open,
            CLK2X    => open,
            CLKFX180 => open,
            CLK90    => open,
            CLK180   => open,
            CLK270   => open
        );

    -- BUFG dla CLK0
    BUFG_CLK0 : BUFG port map (
        I => CLK0_BUF,
        O => CLKFB
    );

    -- BUFG dla CLKFX
    BUFG_CLKFX : BUFG port map (
        I => CLKFX_BUF,
        O => CLKFX_INT
    );

    -- Wyjœcie
    CLKFX_OUT <= CLKFX_INT;

end Behavioral;