library IEEE;
use IEEE.std_logic_1164.all;
use std.env.finish;

entity tb_dzielnik is
end tb_dzielnik;

architecture behaviour of tb_dzielnik is
    component dzielnik is
        generic ( N : INTEGER := 2 );
        port (
            clk_i : in  STD_LOGIC;
            rst_i : in  STD_LOGIC;
            led_o : out STD_LOGIC
        );
    end component;

    constant PERIOD : time := 10 ns;
    constant DUTY_CYCLE : real := 0.5;
    signal clock : STD_LOGIC := '1';

    signal clk_i : STD_LOGIC;
    signal rst_i : STD_LOGIC;
    signal led_o : STD_LOGIC;
begin
    uut : dzielnik
        generic map ( N => 6 )
        port map (
            clk_i => clock,
            rst_i => rst_i,
            led_o => led_o
        );

    clock <= '1' after (PERIOD - (PERIOD * DUTY_CYCLE)) when clock = '0' else
             '0' after (PERIOD * DUTY_CYCLE);

    tb : process is
    begin
        rst_i <= '0'; wait for 5 ns;
        rst_i <= '1'; wait for 5 ns;
        rst_i <= '0'; wait for 5 ns;

        -- No asserts because I dont understand sequences with clocks so
        -- I cannot guaranty anything related to timing
        for i in 255 downto 0 loop
            wait on clock;
            if i = 50 then
                rst_i <= '0'; wait for 1 ns;
                rst_i <= '1'; wait for 1 ns;
                rst_i <= '0'; wait for 1 ns;
            end if;
        end loop;

        finish;
    end process;
end architecture behaviour;
