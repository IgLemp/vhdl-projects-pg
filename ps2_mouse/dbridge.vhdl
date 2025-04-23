library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

-- Speciffic to this design
-- Make a generic one later
entity dbridge is
    port (
        clk_i : in STD_LOGIC;

        frame_commit_i : in STD_LOGIC;
        dx_pos_i : in SIGNED (8 downto 0);
        dy_pos_i : in SIGNED (8 downto 0);
        dr_pos_i : in SIGNED (3 downto 0);
        btn_left_i  : in STD_LOGIC;
        btn_right_i : in STD_LOGIC;

        frame_commit_o : out STD_LOGIC;
        dx_pos_o : out SIGNED (8 downto 0);
        dy_pos_o : out SIGNED (8 downto 0);
        dr_pos_o : out SIGNED (3 downto 0);
        btn_left_o  : out STD_LOGIC;
        btn_right_o : out STD_LOGIC
    );
end entity;
architecture dbridge of dbridge is
    signal frame_commit_b : STD_LOGIC;
    signal dx_pos_b : SIGNED (8 downto 0);
    signal dy_pos_b : SIGNED (8 downto 0);
    signal dr_pos_b : SIGNED (3 downto 0);
    signal btn_left_b :  STD_LOGIC;
    signal btn_right_b : STD_LOGIC;
begin
    process (clk_i) begin
        if falling_edge(clk_i) then
            frame_commit_b <= frame_commit_i;
            dx_pos_b <= dx_pos_i;
            dy_pos_b <= dy_pos_i;
            dr_pos_b <= dr_pos_i;
            btn_left_b  <= btn_left_i;
            btn_right_b <= btn_right_i;

            frame_commit_o <= frame_commit_b;
            dx_pos_o <= dx_pos_b;
            dy_pos_o <= dy_pos_b;
            dr_pos_o <= dr_pos_b;
            btn_left_o  <= btn_left_b;
            btn_right_o <= btn_right_b;
        end if;
    end process;
end architecture;
