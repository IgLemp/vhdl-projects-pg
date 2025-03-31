library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.display;
use work.driver;
use work.decoder;

entity ps2_mouse is
    generic ( SWAP_INTERVAL : NATURAL := 100_000 );
    port (
        clk_i      : in STD_LOGIC;
        ps2_clk_i  : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end entity;

architecture ps2_mouse of ps2_mouse is
    signal ps2_clk  : STD_LOGIC;
    signal ps2_data : STD_LOGIC;

    signal frame_commit : STD_LOGIC;

    signal dx_pos : SIGNED (8 downto 0);
    signal dy_pos : SIGNED (8 downto 0);
    signal dr_pos : SIGNED (3 downto 0);
    signal btn_left  : STD_LOGIC;
    signal btn_right : STD_LOGIC;

    signal digit : STD_LOGIC_VECTOR (31 downto 0);
begin
    decoder : entity work.decoder
    port map (
        ps2_clk_i  => ps2_clk_i,
        ps2_data_i => ps2_data_i,

        frame_commit_o => frame_commit,

        dx_pos_o => dx_pos,
        dy_pos_o => dy_pos,
        dr_pos_o => dr_pos,
        btn_left_o  => btn_left,
        btn_right_o => btn_right
    );

    driver : entity work.driver
    port map (
        ps2_clk_i => ps2_clk_i,
        frame_commit_i => frame_commit,

        dx_pos_i => dx_pos,
        dy_pos_i => dy_pos,
        dr_pos_i => dr_pos,

        btn_left_i  => btn_left,
        btn_right_i => btn_right,

        digit_o => digit
    );

    display : entity work.display
    generic map ( SWAP_INTERVAL => SWAP_INTERVAL )
    port map (
        clk_i      => clk_i,
        digit_i    => digit,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );
end architecture;
