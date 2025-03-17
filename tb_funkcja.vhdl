library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.env.finish;

entity tb_funkcja is
end tb_funkcja;

architecture behaviour of tb_funkcja is
    component funkcja is
        port (
            sw_i       : in  STD_LOGIC_VECTOR(3 downto 0);
            led7_an_o  : out STD_LOGIC_VECTOR(3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal sw_i       : STD_LOGIC_VECTOR(3 downto 0);
    signal led7_an_o  : STD_LOGIC_VECTOR(3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR(7 downto 0);
begin
    uut : funkcja port map (
        sw_i       => sw_i,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    tb : process is
        variable number_of_ones : INTEGER range 0 to 4 := 0;
        variable current_number : INTEGER range 0 to 32 := 0;

        constant SEG_ZERO  : STD_LOGIC_VECTOR(7 downto 0) := "11000000";
        constant SEG_ONE   : STD_LOGIC_VECTOR(7 downto 0) := "11001111";
        constant SEG_TWO   : STD_LOGIC_VECTOR(7 downto 0) := "10100100";
        constant SEG_THREE : STD_LOGIC_VECTOR(7 downto 0) := "10110000";
        constant SEG_FOUR  : STD_LOGIC_VECTOR(7 downto 0) := "10011001";

        function count_ones(inpt : STD_LOGIC_VECTOR) return INTEGER is
            variable ones : INTEGER := 0;
        begin
            for i in inpt'range loop
                if inpt(i) = '1' then ones := ones + 1; end if;
            end loop;
            return ones;
        end function count_ones;

        function lcd_to_int(inpt : STD_LOGIC_VECTOR) return INTEGER is
        begin
            if inpt = SEG_ZERO  then return 0; end if;
            if inpt = SEG_ONE   then return 1; end if;
            if inpt = SEG_TWO   then return 2; end if;
            if inpt = SEG_THREE then return 3; end if;
            if inpt = SEG_FOUR  then return 4; end if;
        end function lcd_to_int;
    begin
        while current_number < 31 loop
            sw_i <= STD_LOGIC_VECTOR(TO_UNSIGNED(current_number, sw_i'length));

            number_of_ones := count_ones(STD_LOGIC_VECTOR(TO_UNSIGNED(current_number, sw_i'length)));

            wait for 100 ms;
            if number_of_ones = 0 then assert led7_seg_o = SEG_ZERO  report "[FAIL] " & TO_STRING(sw_i) & " => 0 found " & TO_STRING(lcd_to_int(led7_seg_o)); end if;
            if number_of_ones = 1 then assert led7_seg_o = SEG_ONE   report "[FAIL] " & TO_STRING(sw_i) & " => 1 found " & TO_STRING(lcd_to_int(led7_seg_o)); end if;
            if number_of_ones = 2 then assert led7_seg_o = SEG_TWO   report "[FAIL] " & TO_STRING(sw_i) & " => 2 found " & TO_STRING(lcd_to_int(led7_seg_o)); end if;
            if number_of_ones = 3 then assert led7_seg_o = SEG_THREE report "[FAIL] " & TO_STRING(sw_i) & " => 3 found " & TO_STRING(lcd_to_int(led7_seg_o)); end if;
            if number_of_ones = 4 then assert led7_seg_o = SEG_FOUR  report "[FAIL] " & TO_STRING(sw_i) & " => 4 found " & TO_STRING(lcd_to_int(led7_seg_o)); end if;

            number_of_ones := 0;
            current_number := current_number + 1;

            finish;
        end loop;
    end process;

end architecture behaviour;
