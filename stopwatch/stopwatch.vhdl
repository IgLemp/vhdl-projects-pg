library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.NUMERIC_BIT.all;
use work.display;
use work.driver;

entity stopwatch is
    generic (
        SWAP_INTERVAL : NATURAL := 100_000;
        MILLI_CYCLE   : NATURAL := 100_000
    );
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        start_stop_button_i : in STD_LOGIC;
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end entity;

architecture stopwatch of stopwatch is
    signal digit_bus : STD_LOGIC_VECTOR (31 downto 0);
begin
    display : entity work.display
    generic map ( SWAP_INTERVAL => SWAP_INTERVAL )
    port map (
        clk_i      => clk_i,
        rst_i      => '0',
        digit_i    => digit_bus,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    driver : entity work.driver
    generic map ( MILLI_CYCLE => MILLI_CYCLE )
    port map (
        clk_i               => clk_i,
        rst_i               => rst_i,
        start_stop_button_i => start_stop_button_i,
        digit_o             => digit_bus
    );
end architecture;
