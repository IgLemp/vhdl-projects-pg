library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.env.finish;

entity tb_led_disp is
end entity;

architecture tb_led_disp of tb_led_disp is
    component led_disp is
        generic ( SWAP_INTERVAL : NATURAL := 100_000 );
        port (
            clk_i : in STD_LOGIC;
            rst_i : in STD_LOGIC;
            btn_i : in STD_LOGIC_VECTOR (3 downto 0);
            sw_i  : in STD_LOGIC_VECTOR (7 downto 0);
            led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal clk_i : STD_LOGIC;
    signal rst_i : STD_LOGIC;
    signal btn_i : STD_LOGIC_VECTOR (3 downto 0);
    signal sw_i  : STD_LOGIC_VECTOR (7 downto 0);
    signal led7_an_o  : STD_LOGIC_VECTOR (3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR (7 downto 0);
begin
    uut : led_disp
    generic map ( SWAP_INTERVAL => 10 )
    port map (
        clk_i      => clk_i,
        rst_i      => rst_i,
        btn_i      => btn_i,
        sw_i       => sw_i,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    clk_i <= '1' after 10 ns when clk_i = '0' else '0' after 10 ns;

    tb : process
    begin
        rst_i <= '0'; wait for 1 us;
        rst_i <= '1'; wait for 1 us;
        rst_i <= '0';

        wait on clk_i;
        btn_i <= "1000";
        sw_i  <= "00000000";

        for i in 0 to 63 loop
            sw_i <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 8));
            wait for 1 ms;
            case btn_i is
                when "1000" => btn_i <= "0001";
                when "0001" => btn_i <= "0010";
                when "0010" => btn_i <= "0100";
                when "0100" => btn_i <= "1000";
                when others => btn_i <= "0000";
            end case;
			wait for 2 ms;
        end loop;
        finish;
    end process;
end architecture;
