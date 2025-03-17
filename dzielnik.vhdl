library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity dzielnik is
    generic ( N : INTEGER := 2 );
    port (
        clk_i : in  STD_LOGIC;
        rst_i : in  STD_LOGIC;
        led_o : out STD_LOGIC
    );
end dzielnik;

architecture dzielnik of dzielnik is
    signal counter : NATURAL;
    signal out_b : STD_LOGIC;
begin
    led_o <= out_b;
    process (clk_i, rst_i) is begin
        if rst_i = '1'
        then
            counter <= 0;
            out_b <= '0';
        elsif rising_edge(clk_i)
        then
            counter <= counter + 1;
            if counter = (N - 1) / 2
            then out_b <= not out_b; counter <= 0;
            end if;
        end if;
    end process;
end architecture dzielnik;
