library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED;

entity funkcja is
    port (
        sw_i       : in  STD_LOGIC_VECTOR(3 downto 0);
        led7_an_o  : out STD_LOGIC_VECTOR(3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR(7 downto 0)
    );
end funkcja;

architecture funkcja of funkcja is
    constant SEG_ZERO  : STD_LOGIC_VECTOR(7 downto 0) := "11000000";
    constant SEG_ONE   : STD_LOGIC_VECTOR(7 downto 0) := "11001111";
    constant SEG_TWO   : STD_LOGIC_VECTOR(7 downto 0) := "10100100";
    constant SEG_THREE : STD_LOGIC_VECTOR(7 downto 0) := "10110000";
    constant SEG_FOUR  : STD_LOGIC_VECTOR(7 downto 0) := "10011001";

    signal ones : INTEGER range 0 to 4;

    function count_ones(inpt : STD_LOGIC_VECTOR) return INTEGER is
        variable ones : INTEGER := 0;
    begin
        for i in inpt'range loop
            if inpt(i) = '1' then ones := ones + 1; end if;
        end loop;
        return ones;
    end function count_ones;
begin
    led7_an_o <= "0111";
    ones <= count_ones(sw_i);
    led7_seg_o <= SEG_ZERO  when ones = 0 else
                  SEG_ONE   when ones = 1 else
                  SEG_TWO   when ones = 2 else
                  SEG_THREE when ones = 3 else
                  SEG_FOUR  when ones = 4;
end architecture funkcja;
