library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity tb_parity is
end tb_parity;

architecture behaviour of tb_parity is
    component parity is
        port (
            sw_i       : in  STD_LOGIC_VECTOR(7 downto 0);
            led7_an_o  : out STD_LOGIC_VECTOR(3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal sw_i       : STD_LOGIC_VECTOR(7 downto 0);
    signal led7_an_o  : STD_LOGIC_VECTOR(3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR(7 downto 0);
begin
    uut : parity port map (
        sw_i       => sw_i,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    tb : process is
        constant SEG_ODD  : STD_LOGIC_VECTOR(7 downto 0) := "11000000";
        constant SEG_EVEN : STD_LOGIC_VECTOR(7 downto 0) := "11000110";
    begin
        sw_i <= "00000000"; wait for 100 ms; assert led7_seg_o = SEG_EVEN report "[FAIL]: 00000000";
        sw_i <= "00000001"; wait for 100 ms; assert led7_seg_o = SEG_ODD  report "[FAIL]: 00000001";
        sw_i <= "00000011"; wait for 100 ms; assert led7_seg_o = SEG_EVEN report "[FAIL]: 00000011";
        sw_i <= "00000111"; wait for 100 ms; assert led7_seg_o = SEG_ODD  report "[FAIL]: 00000111";
        sw_i <= "00001111"; wait for 100 ms; assert led7_seg_o = SEG_EVEN report "[FAIL]: 00001111";
        sw_i <= "00011111"; wait for 100 ms; assert led7_seg_o = SEG_ODD  report "[FAIL]: 00011111";
        sw_i <= "00111111"; wait for 100 ms; assert led7_seg_o = SEG_EVEN report "[FAIL]: 00111111";
        sw_i <= "01111111"; wait for 100 ms; assert led7_seg_o = SEG_ODD  report "[FAIL]: 01111111";
        sw_i <= "11111111"; wait for 100 ms; assert led7_seg_o = SEG_EVEN report "[FAIL]: 11111111";
        finish;
    end process;
end architecture behaviour;
