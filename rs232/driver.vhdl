library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity driver is
    generic (
        CLOCK_FREQENCY: NATURAL := 100_000_000;
        BAUD_RATE : NATURAL := 9_600
    );
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        RXD_i : in STD_LOGIC;
        TXD_o : out STD_LOGIC
    );
end entity;

architecture driver of driver is
begin
end architecture;
