library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.env.finish;


entity tb_johnson is
end tb_johnson;

architecture behaviour of tb_johnson is
    component johnson is
        port (
            clk_i : in STD_LOGIC;
            rst_i : in STD_LOGIC;
            led_o : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal rst_i : STD_LOGIC;
    signal clk_i : STD_LOGIC;
    signal led_o : STD_LOGIC_VECTOR (3 downto 0);
begin
    uut : johnson port map (
        clk_i => clk_i,
        rst_i => rst_i,
        led_o => led_o
    );

    -- Period is 20 us
    clk_i <= '1' after 10 us when clk_i = '0' else '0' after 10 us;

    tb : process is
        variable reference : UNSIGNED (3 downto 0) := "0001";
    begin
        rst_i <= '0'; wait for 5 us;
        rst_i <= '1'; wait for 5 us;
        rst_i <= '0'; wait for 5 us;

        for i in 0 to 7 loop
            wait on clk_i;
            reference := (reference(2) & reference(1) & reference(0) & not reference(3));
        end loop;
        assert led_o = STD_LOGIC_VECTOR(reference) report "[FAIL] " & TO_STRING(reference) & " expected " & TO_STRING(led_o);

        reference := "0000";
        rst_i <= '0'; wait for 1 us;
        rst_i <= '1'; wait for 1 us;
        rst_i <= '0'; wait for 1 us;

        for i in 0 to 9 loop
            wait on clk_i;
            reference := (reference(2) & reference(1) & reference(0) & not reference(3));
        end loop;
        assert led_o = STD_LOGIC_VECTOR(reference) report "[FAIL] " & TO_STRING(reference) & " expected " & TO_STRING(led_o);


        ---- DETERMINISTIC TESTS ----
        -- Without reset
        --rst_i <= '1'; wait for 10 us; rst_i <= '0'; wait for 10 us; assert led_o = "0001" report "[FAIL] expected 0001 got " & TO_STRING(led_o);
        --clk_i <= '1'; wait for 10 us; clk_i <= '0'; wait for 10 us; assert led_o = "0010" report "[FAIL] expected 0010 got " & TO_STRING(led_o);
        --clk_i <= '1'; wait for 10 us; clk_i <= '0'; wait for 10 us; assert led_o = "0100" report "[FAIL] expected 0100 got " & TO_STRING(led_o);
        --clk_i <= '1'; wait for 10 us; clk_i <= '0'; wait for 10 us; assert led_o = "1000" report "[FAIL] expected 1000 got " & TO_STRING(led_o);

        -- With reset
        --rst_i <= '1'; wait for 10 us; rst_i <= '0'; wait for 10 us; assert led_o = "0001" report "[FAIL] expected 0001 got " & TO_STRING(led_o);
        --clk_i <= '1'; wait for 10 us; clk_i <= '0'; wait for 10 us; assert led_o = "0010" report "[FAIL] expected 0010 got " & TO_STRING(led_o);
        --rst_i <= '1'; wait for 10 us; rst_i <= '0'; wait for 10 us; assert led_o = "0001" report "[FAIL] expected 0001 got " & TO_STRING(led_o);
        --clk_i <= '1'; wait for 10 us; clk_i <= '0'; wait for 10 us; assert led_o = "0010" report "[FAIL] expected 0010 got " & TO_STRING(led_o);
        finish;
    end process;
end architecture behaviour;
