library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity johnson is
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        led_o : out STD_LOGIC_VECTOR (3 downto 0)
    );
end johnson;

architecture johnson of johnson is
    signal state : UNSIGNED (3 downto 0);
begin
    process (clk_i, rst_i) is begin
        if rst_i = '1' then
            state <= "0000";
        elsif rising_edge(clk_i) then
            state <= (state(2) & state(1) & state(0) & not state(3));
        end if;
    end process;
    led_o <= STD_LOGIC_VECTOR(state);
end architecture johnson;
