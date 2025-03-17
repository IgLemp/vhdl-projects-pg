library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.stopwatch;
use std.env.finish;

entity tb_stopwatch is begin
end entity;

architecture tb_stopwatch of tb_stopwatch is
    component stopwatch is
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
    end component;

    signal clk_i : STD_LOGIC;
    signal rst_i : STD_LOGIC;
    signal start_stop_button_i : STD_LOGIC;
    signal led7_an_o  : STD_LOGIC_VECTOR (3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR (7 downto 0);
begin
    uut : stopwatch
    generic map (
        SWAP_INTERVAL => 10,
        MILLI_CYCLE   => 10
    )
    port map(
        clk_i               => clk_i,
        rst_i               => rst_i,
        start_stop_button_i => start_stop_button_i,
        led7_an_o           => led7_an_o,
        led7_seg_o          => led7_seg_o
    );

    clk_i <= '1' after 10 ns when clk_i = '0' else '0' after 10 ns;

    tb : process is
    begin
        rst_i <= '0';
        start_stop_button_i <= '0';

        rst_i <= '0'; wait for 1 us;
        rst_i <= '1'; wait for 1 us;
        rst_i <= '0';

        start_stop_button_i <= '0'; wait for 1 us;
        start_stop_button_i <= '1'; wait for 1 us;
        start_stop_button_i <= '0';
        wait for 1 ms;

        start_stop_button_i <= '0'; wait for 1 us;
        start_stop_button_i <= '1'; wait for 1 us;
        start_stop_button_i <= '0';
        wait for 1 ms;

        rst_i <= '0'; wait for 1 us;
        rst_i <= '1'; wait for 1 us;
        rst_i <= '0';
        wait for 1 ms;

        start_stop_button_i <= '0'; wait for 1 us;
        start_stop_button_i <= '1'; wait for 1 us;
        start_stop_button_i <= '0';
        wait for 1 ms;

        start_stop_button_i <= '0'; wait for 1 us;
        start_stop_button_i <= '1'; wait for 1 us;
        start_stop_button_i <= '0';
        wait for 1 ms;

        start_stop_button_i <= '0'; wait for 1 us;
        start_stop_button_i <= '1'; wait for 1 us;
        start_stop_button_i <= '0';
        wait for 1 ms;

        finish;
    end process;
end architecture;
