library IEEE;
use IEEE.std_logic_1164.all;

package basys3 is
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
end package;
