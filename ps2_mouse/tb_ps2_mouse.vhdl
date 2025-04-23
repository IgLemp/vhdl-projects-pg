library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.env.finish;

entity tb_ps2_mouse is
end entity;

architecture tb_ps2_mouse of tb_ps2_mouse is
    component ps2_mouse is
        generic ( SWAP_INTERVAL : NATURAL := 100_000 );
        port (
            clk_i      : in STD_LOGIC;
            ps2_clk_i  : in STD_LOGIC;
            ps2_data_i : in STD_LOGIC;
            led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal clk_i      : STD_LOGIC;
    signal ps2_clk_i  : STD_LOGIC;
    signal ps2_data_i : STD_LOGIC;
    signal led7_an_o  : STD_LOGIC_VECTOR (3 downto 0);
    signal led7_seg_o : STD_LOGIC_VECTOR (7 downto 0);

    constant DOTS_PER_MILLIM : NATURAL := 32;
    constant STEP_RANGE : NATURAL := DOTS_PER_MILLIM * 50; -- Cell range: 5 centimerers
    constant HALF_RANGE : NATURAL := STEP_RANGE / 2;       -- Half cell range
    constant FULL_RANGE : NATURAL := STEP_RANGE * 4;       -- Range from bottom to top cell
    constant SCRL_RANGE : NATURAL := STEP_RANGE * 4;

    -- DEBUG
    signal frame_s : STD_LOGIC_VECTOR (43 downto 0) := (others => '0');

    function xor_v(v : STD_LOGIC_VECTOR) return STD_LOGIC
    is variable acc : STD_LOGIC := '0';
    begin for i in v'range loop acc := acc xor v(i); end loop; return acc;
    end function;

    function make_frame (
        dx_pos : SIGNED (8 downto 0);
        dy_pos : SIGNED (8 downto 0);
        dr_pos : SIGNED (3 downto 0);
        btn_left  : STD_LOGIC;
        btn_right : STD_LOGIC
    ) return STD_LOGIC_VECTOR is
        variable head  : STD_LOGIC_VECTOR (7 downto 0);
        variable x_mov : STD_LOGIC_VECTOR (7 downto 0);
        variable y_mov : STD_LOGIC_VECTOR (7 downto 0);
        variable tail  : STD_LOGIC_VECTOR (7 downto 0);
    begin
        head  := ('0' & '0' & dy_pos(8) & dx_pos(8) & '1' & '0' & btn_right & btn_left);
        x_mov := (STD_LOGIC_VECTOR(dx_pos(7 downto 0)));
        y_mov := (STD_LOGIC_VECTOR(dy_pos(7 downto 0)));
        tail  := ("00" & "00" & STD_LOGIC_VECTOR(dr_pos));

        return (
            '1' & xor_v(head)  & head  & '0' &
            '1' & xor_v(x_mov) & x_mov & '0' &
            '1' & xor_v(y_mov) & y_mov & '0' &
            '1' & xor_v(tail)  & tail  & '0'
        );
    end function;
begin
    uut : ps2_mouse
    generic map ( SWAP_INTERVAL => 100_000 )
    port map (
        clk_i => clk_i,
        ps2_clk_i  => ps2_clk_i,
        ps2_data_i => ps2_data_i,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    clk_i     <= '1' after 5 ns    when clk_i = '0'     else '0' after 5 ns;
    ps2_clk_i <= '1' after 16.5 ns when ps2_clk_i = '0' else '0' after 16.5 ns;

    tb : process is
        variable frame : STD_LOGIC_VECTOR (43 downto 0);
    begin
        -- Null test
        frame := make_frame("001111110", "011111111", "0011", '0', '0');
        frame_s <= frame;
        for i in 43 downto 0 loop wait on ps2_clk_i; ps2_data_i <= frame(i); end loop;

        -- Number: 0449

--        -- Second digit ---------------------------------------------------------------------------
--        -- mouse move
--        frame := make_frame(TO_SIGNED(511, 9), "0", "0", '0', '0');
--        for i in 3 to 0 loop
--            for i in 43 downto 0 loop wait on ps2_clk_i; ps2_data_i <= frame(i); end loop;
--        end loop;

--        -- input number
--        frame := make_frame("0", "0", TO_SIGNED(15, 9), '0', '0');
--        for i in 1706 to 0 loop
--            for i in 43 downto 0 loop wait on ps2_clk_i; ps2_data_i <= frame(i); end loop;
--        end loop;

--        -- Third digit ----------------------------------------------------------------------------
--        -- mouse move
--        frame := make_frame(TO_SIGNED(511, 9), "0", "0", '0', '0');
--        for i in 3 to 0 loop
--            for i in 43 downto 0 loop wait on ps2_clk_i; ps2_data_i <= frame(i); end loop;
--        end loop;

--        -- input number
--        frame := make_frame("0", "0", TO_SIGNED(15, 9), '0', '0');
--        for i in 1706 to 0 loop
--            for i in 43 downto 0 loop wait on ps2_clk_i; ps2_data_i <= frame(i); end loop;
--        end loop;

--        -- Fourth digit ---------------------------------------------------------------------------
--        -- mouse move
--        frame := make_frame(TO_SIGNED(511, 9), "0", "0", '0', '0');
--        for i in 3 to 0 loop
--            for i in 43 downto 0 loop wait on ps2_clk_i; ps2_data_i <= frame(i); end loop;
--        end loop;

--        -- input number
--        frame := make_frame("0", "0", TO_SIGNED(15, 9), '0', '0');
--        for i in 3840 to 0 loop
--            for i in 43 downto 0 loop wait on ps2_clk_i; ps2_data_i <= frame(i); end loop;
--        end loop;

--        finish;
    end process;
end architecture;
