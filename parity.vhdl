library IEEE;
use IEEE.std_logic_1164.all;

entity parity is
    port (
        sw_i       : in  STD_LOGIC_VECTOR(7 downto 0);
        led7_an_o  : out STD_LOGIC_VECTOR(3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR(7 downto 0)
    );
end parity;

architecture parity of parity is
    constant SEG_ODD  : STD_LOGIC_VECTOR(7 downto 0) := "11000000";
    constant SEG_EVEN : STD_LOGIC_VECTOR(7 downto 0) := "11000110";

    signal odd : STD_LOGIC;
begin
    led7_an_o <= "0111";
    odd <= sw_i(7) xor sw_i(6) xor sw_i(5) xor sw_i(4) xor
           sw_i(3) xor sw_i(2) xor sw_i(1) xor sw_i(0);
    led7_seg_o <= SEG_ODD when odd = '1' else SEG_EVEN;
end architecture parity;
