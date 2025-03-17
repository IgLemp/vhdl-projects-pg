library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

package utils is
    constant SEG_ZERO  : STD_LOGIC_VECTOR (7 downto 0) := "00000011";
    constant SEG_ONE   : STD_LOGIC_VECTOR (7 downto 0) := "10011111";
    constant SEG_TWO   : STD_LOGIC_VECTOR (7 downto 0) := "00100101";
    constant SEG_THREE : STD_LOGIC_VECTOR (7 downto 0) := "00001101";
    constant SEG_FOUR  : STD_LOGIC_VECTOR (7 downto 0) := "10011001";
    constant SEG_FIVE  : STD_LOGIC_VECTOR (7 downto 0) := "01001001";
    constant SEG_SIX   : STD_LOGIC_VECTOR (7 downto 0) := "01000001";
    constant SEG_SEVEN : STD_LOGIC_VECTOR (7 downto 0) := "00011111";
    constant SEG_EIGHT : STD_LOGIC_VECTOR (7 downto 0) := "00000001";
    constant SEG_NINE  : STD_LOGIC_VECTOR (7 downto 0) := "00001001";
    constant SEG_A     : STD_LOGIC_VECTOR (7 downto 0) := "00010001";
    constant SEG_B     : STD_LOGIC_VECTOR (7 downto 0) := "11000001";
    constant SEG_C     : STD_LOGIC_VECTOR (7 downto 0) := "11100101";
    constant SEG_D     : STD_LOGIC_VECTOR (7 downto 0) := "10000101";
    constant SEG_E     : STD_LOGIC_VECTOR (7 downto 0) := "01100001";
    constant SEG_F     : STD_LOGIC_VECTOR (7 downto 0) := "01110001";
    constant SEG_NULL  : STD_LOGIC_VECTOR (7 downto 0) := "11111111";
    constant SEG_DASH  : STD_LOGIC_VECTOR (7 downto 0) := "11111101";
    constant SEG_UNDF  : STD_LOGIC_VECTOR (7 downto 0) := "UUUUUUUU";

    function short_to_seg(inpt: UNSIGNED (3 downto 0)) return STD_LOGIC_VECTOR;
end package;

package body utils is
    function short_to_seg(inpt: UNSIGNED (3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case inpt is
            when "0000" => return SEG_ZERO;
            when "0001" => return SEG_ONE;
            when "0010" => return SEG_TWO;
            when "0011" => return SEG_THREE;
            when "0100" => return SEG_FOUR;
            when "0101" => return SEG_FIVE;
            when "0110" => return SEG_SIX;
            when "0111" => return SEG_SEVEN;
            when "1000" => return SEG_EIGHT;
            when "1001" => return SEG_NINE;
            when "1010" => return SEG_A;
            when "1011" => return SEG_B;
            when "1100" => return SEG_C;
            when "1101" => return SEG_D;
            when "1111" => return SEG_F;
            when "1110" => return SEG_E;
            when others => return SEG_UNDF;
        end case;
    end function short_to_seg;
end package body;
