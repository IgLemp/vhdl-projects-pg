library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.env.finish;


entity tb_gray is
end tb_gray;

architecture behaviour of tb_gray is
    component gray is
        port (
            clk_i : in STD_LOGIC;
            rst_i : in STD_LOGIC;
            led_o : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    signal clk_i : STD_LOGIC;
    signal rst_i : STD_LOGIC;
    signal led_o : STD_LOGIC_VECTOR (2 downto 0);

    function bin_to_gray(inpt : UNSIGNED) return STD_LOGIC_VECTOR is
        variable outp : STD_LOGIC_VECTOR (inpt'range);
    begin
        outp(inpt'length - 1) := inpt(inpt'length - 1);
        for i in inpt'length - 2 downto 0 loop
            outp(i) := inpt(i + 1) xor inpt(i);
        end loop;
        return outp;
    end function bin_to_gray;
begin
    uut : gray port map (
        clk_i => clk_i,
        rst_i => rst_i,
        led_o => led_o
    );

    clk_i <= '1' after 10 ms when clk_i = '0' else
             '0' after 10 ms;

    tb : process is
        variable num : UNSIGNED (2 downto 0) := "000";
    begin
        -- Clear undefined states
        rst_i <= '0';
        wait for 10 ms;

        -- Init
        rst_i <= '1'; wait for 10 ms; rst_i <= '0';

        assert led_o = "000" report "[FAIL] expected 000 got " & TO_STRING(led_o);

        wait for 10 ms;
        num := "000";
        for i in 6 downto 0 loop
            num := num + 1;
            wait for 20 ms;
            assert led_o = bin_to_gray(num) report "[FAIL] expected " & TO_STRING(bin_to_gray(num)) & " got " & TO_STRING(led_o);
        end loop;

        wait for 10 ms;
        num := "000";
        for i in 6 downto 0 loop
            wait for 20 ms;
            if num = 3 then num := "000"; rst_i <= '1'; wait for 5 ms; rst_i <= '0'; end if;
            assert led_o = bin_to_gray(num) report "[FAIL] expected " & TO_STRING(bin_to_gray(num)) & " got " & TO_STRING(led_o);
            num := num + 1;
        end loop;

        rst_i <= '1'; wait for 10 ms; rst_i <= '0';
        finish;
    end process;
end architecture behaviour;
