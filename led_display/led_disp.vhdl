library IEEE;
use IEEE.std_logic_1164.all;
use work.display;
use work.ende;

entity led_disp is
    generic ( SWAP_INTERVAL : NATURAL := 100_000);
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        btn_i : in STD_LOGIC_VECTOR (3 downto 0);
        sw_i  : in STD_LOGIC_VECTOR (7 downto 0);
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end led_disp;

architecture led_disp of led_disp is
    signal digit_bus : STD_LOGIC_VECTOR (31 downto 0);
begin
    encoder_decoder : entity work.ende
    port map (
        clk_i   => clk_i,
        btn_i   => btn_i,
        sw_i    => sw_i,
        digit_o => digit_bus
    );

    display: entity work.display
    generic map ( SWAP_INTERVAL => SWAP_INTERVAL )
    port map (
        clk_i      => clk_i,
        rst_i      => '0',
        digit_i    => digit_bus,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );
end architecture led_disp;
