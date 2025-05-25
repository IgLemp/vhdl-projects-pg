library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.env.finish;

entity tb_rs232 is
end entity;

architecture tb_rs232 of tb_rs232 is
    component rs232 is
        generic (
            CLOCK_FREQENCY: NATURAL := 100_000_000;
            BAUD_RATE     : NATURAL :=       9_600
        );
        port (
            clk_i : in STD_LOGIC;
            rst_i : in STD_LOGIC;
            RXD_i : in STD_LOGIC;
            TXD_o : out STD_LOGIC
        );
    end component;

    constant CLOCK_FREQENCY: NATURAL := 100_000_000;
    constant BAUD_RATE     : NATURAL :=       9_600;

    constant RS_PERIOD      : NATURAL := 1 / BAUD_RATE;
    constant RS_HALF_PERIOD : NATURAL := RS_PERIOD / 2;

    signal clk_i : STD_LOGIC := 0;
    signal rst_i : STD_LOGIC := 0;
    signal RXD_i : STD_LOGIC := 0;
    signal TXD_o : STD_LOGIC := 0;

    -- DEBUG
    signal frame_s : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
begin
    uut : rs232
    generic map (
        CLOCK_FREQENCY => 100_000_000,
        BAUD_RATE      =>       9_600
    )
    port map (
        clk_i => clk_i,
        rst_i => rst_i,
        RXD_i => RXD_i,
        TXD_o => TXD_o
    );

    -- 100 MHz
    clk_i <= '1' after 5 ns when clk_i = '0' else '0' after 5 ns;

    -- 9600 Hz
    clk_rs <= '1' after 104 us when clk_i = '0' else '0' after 104 us;
    --clk_rs <= '1' after RS_HALF_PERIOD ns when clk_rs = '0' else '0' after RS_HALF_PERIOD ns;


    tb : process is
        variable frame : STD_LOGIC_VECTOR (9 downto 0);
    begin
        rst_i <= 0; wait for 20 ns;
        rst_i <= 1; wait for 20 ns;
        rst_i <= 0; wait for 20 ns;

        -- Send 0x53
        frame <= "0" & "01010011" & "1";
        for i in 0 to 9 loop RXD_i <= frame(i); wait for 208 us; end loop;
        wait for 208 us;

        -- Send 0x53   4% faster: 217 us
        frame <= "0" & "01010011" & "1";
        for i in 0 to 9 loop RXD_i <= frame(i); wait for 217 us; end loop;
        wait for 208 us;

        -- Send 0x53   4% slower: 198 us
        frame <= "0" & "01010011" & "1";
        for i in 0 to 9 loop RXD_i <= frame(i); wait for 198 us; end loop;
        wait for 208 us;

        -- Wait for response
        for i in 0 to 11 loop wait for 208 us; end loop;

        finish;
    end process;
end architecture;
