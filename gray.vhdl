library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity gray is
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        led_o : out STD_LOGIC_VECTOR (2 downto 0)
    );
end gray;

architecture gray of gray is
    signal state : UNSIGNED (2 downto 0);
begin
    process (clk_i, rst_i) is begin
        if rst_i = '1'
            then state <= "000";
        elsif rising_edge(clk_i) then state <= state + 1; end if;
    end process;
    led_o <= (state(2) & (state(2) xor state(1)) & (state(1) xor state(0)));
end architecture gray;
