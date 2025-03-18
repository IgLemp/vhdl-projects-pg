library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.NUMERIC_BIT.all;
use work.display;
use work.driver;

entity ps2_mouse is
    generic (
        SWAP_INTERVAL    : NATURAL := 100_000;
        CLOCK_CONVERSION : NATURAL := 30_000
    );
    port (
        clk_i      : in STD_LOGIC;
        ps2_clk_i  : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end entity;

architecture ps2_mouse of ps2_mouse is
    signal digit_bus : STD_LOGIC_VECTOR (31 downto 0);
begin
    display : entity work.display
    generic map ( SWAP_INTERVAL => SWAP_INTERVAL )
    port map (
        clk_i      => clk_i,
        digit_i    => digit_bus,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    driver : entity work.driver
    generic map ( CLOCK_CONVERSION => 30_000 )
    port map (
        clk_i      => clk_i,
        ps2_clk_i  => ps2_clk_i,
        ps2_data_i => ps2_data_i,
        digit_o    => digit_bus
    );
end architecture;
