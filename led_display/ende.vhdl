library IEEE;
use IEEE.std_logic_1164.all;
use work.basys3.all;

entity ende is
    port(
        clk_i : in STD_LOGIC;
        btn_i : in STD_LOGIC_VECTOR (3 downto 0);
        sw_i  : in STD_LOGIC_VECTOR (7 downto 0);
        digit_o : out STD_LOGIC_VECTOR (31 downto 0)
    );
end entity;

architecture ende of ende is
    signal digit_3 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal digit_2 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal digit_1 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal digit_0 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

    signal dots_in  : STD_LOGIC_VECTOR (3 downto 0);
    signal digit_in : STD_LOGIC_VECTOR (3 downto 0);

    function short_to_seg(inpt: STD_LOGIC_VECTOR (3 downto 0)) return STD_LOGIC_VECTOR is
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
            when others => return SEG_NULL;
        end case;
    end function short_to_seg;
begin
    dots_in  <= sw_i(7 downto 4);
    digit_in <= sw_i(3 downto 0);
    digit_o <= (digit_3 & digit_2 & digit_1 & digit_0);

    process (clk_i) begin
        if rising_edge(clk_i)
        then
            if btn_i(3) = '1' then digit_3(7 downto 1) <= short_to_seg(digit_in)(7 downto 1); end if;
            if btn_i(2) = '1' then digit_2(7 downto 1) <= short_to_seg(digit_in)(7 downto 1); end if;
            if btn_i(1) = '1' then digit_1(7 downto 1) <= short_to_seg(digit_in)(7 downto 1); end if;
            if btn_i(0) = '1' then digit_0(7 downto 1) <= short_to_seg(digit_in)(7 downto 1); end if;
            digit_3(0) <= dots_in(3);
            digit_2(0) <= dots_in(2);
            digit_1(0) <= dots_in(1);
            digit_0(0) <= dots_in(0);
        end if;
    end process;
end architecture;
