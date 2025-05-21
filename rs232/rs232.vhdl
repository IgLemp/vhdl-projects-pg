library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.decoder;
use work.encoder;
use work.driver;

entity rs232 is
    generic (
        CLOCK_FREQENCY: NATURAL := 100_000_000;
        BAUD_RATE     : NATURAL :=       9_600
    );
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        RXD_i : in STD_LOGIC;
        TXD_o : out STD_LOGIC
    );
end entity;

architecture rs232 of rs232 is
    signal send : STD_LOGIC_VECTOR (7 downto 0);
    signal send_ready : STD_LOGIC;

    signal recv : STD_LOGIC_VECTOR (7 downto 0);
    signal recv_ready : STD_LOGIC;
begin
    decoder : entity work.decoder
    generic map (
        CLOCK_FREQENCY => CLOCK_FREQENCY,
        BAUD_RATE      => BAUD_RATE
    )
    port map (
        clk_i => clk_i,
        rst_i => rst_i,
        RXD_i => RXD_i,

        recv_o       => recv,
        recv_ready_o => recv_ready
    );

    driver : entity work.driver
    port map (
        clk_i => clk_i,
        rst_i => rst_i,

        recv_i => recv,
        send_o => send,

        recv_ready_i => recv_ready,
        send_ready_o => send_ready
    );

    encoder : entity work.encoder
    generic map (
        CLOCK_FREQENCY => CLOCK_FREQENCY,
        BAUD_RATE      => BAUD_RATE
    )
    port map (
        clk_i => clk_i,
        rst_i => rst_i,
        RXD_i => RXD_i,

        send_o       => send,
        send_ready_o => send_ready
    );
end architecture;
