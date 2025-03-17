library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity display is
    generic ( SWAP_INTERVAL : NATURAL := 100_000 );
    port (
        clk_i   : in STD_LOGIC;
        digit_i : in STD_LOGIC_VECTOR (31 downto 0);
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end entity;

architecture display of display is
    signal counter : NATURAL := 0;
    signal selected : UNSIGNED (3 downto 0) := "0001";

    alias digit_3 : STD_LOGIC_VECTOR (7 downto 0) is digit_i(31 downto 24);
    alias digit_2 : STD_LOGIC_VECTOR (7 downto 0) is digit_i(23 downto 16);
    alias digit_1 : STD_LOGIC_VECTOR (7 downto 0) is digit_i(15 downto 8 );
    alias digit_0 : STD_LOGIC_VECTOR (7 downto 0) is digit_i(7  downto 0 );
begin
    led7_an_o <= STD_LOGIC_VECTOR(selected);

    process (clk_i) begin
        if rising_edge(clk_i)
        then
            case selected is
			    when "0001" => led7_seg_o <= digit_0;
			    when "0010" => led7_seg_o <= digit_1;
			    when "0100" => led7_seg_o <= digit_2;
			    when "1000" => led7_seg_o <= digit_3;
                when others => led7_seg_o <= digit_0;
            end case;
            if counter = TO_UNSIGNED(SWAP_INTERVAL, 32) - 1
            then
                counter <= 0;
                selected <= ROTATE_LEFT(selected, 1);
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end architecture;
