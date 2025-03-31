library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.utils.all;

entity driver is
    generic ( DOTS_PER_MILLIM : NATURAL := 32 ); -- dots per millimeter
    port (
        ps2_clk_i : in STD_LOGIC;
        frame_commit_i : in STD_LOGIC;

        dx_pos_i : in SIGNED (11 downto 0);
        dy_pos_i : in SIGNED (11 downto 0);
        dr_pos_i : in SIGNED (13 downto 0);

        btn_left_i  : in STD_LOGIC;
        btn_right_i : in STD_LOGIC;

        digit_o : out STD_LOGIC_VECTOR (31 downto 0)
    );
end entity;

architecture driver of driver is
    constant STEP_RANGE : NATURAL := DOTS_PER_MILLIM * 50; -- Cell range: 5 centimerers
    constant HALF_RANGE : NATURAL := STEP_RANGE / 2;       -- Half cell range
    constant FULL_RANGE : NATURAL := STEP_RANGE * 4;       -- Range from bottom to top cell
    constant SCRL_RANGE : NATURAL := STEP_RANGE * 4;

    type PIPELINE_STATE_T is (IDLE, MOVE, CALC);

    -- Internal state data
    signal pipeline_state : PIPELINE_STATE_T := IDLE;

    signal x_pos : SIGNED (15 downto 0) := (others => '0');
    signal r_pos : SIGNED (15 downto 0) := (others => '0');
    signal btn_left  : STD_LOGIC := '0';

    signal btn_left_last_state : STD_LOGIC := '0';
    signal edit_lock : STD_LOGIC := '0';

    -- Outputed data
    signal selected_digit : UNSIGNED (3 downto 0) := "1000";
    alias digit_0_o : UNSIGNED (3 downto 0) is digit_o (31 downto 24);
    alias digit_1_o : UNSIGNED (3 downto 0) is digit_o (23 downto 16);
    alias digit_2_o : UNSIGNED (3 downto 0) is digit_o (15 downto  8);
    alias digit_3_o : UNSIGNED (3 downto 0) is digit_o (7  downto  0);

    signal digit_0 : UNSIGNED (3 downto 0);
    signal digit_1 : UNSIGNED (3 downto 0);
    signal digit_2 : UNSIGNED (3 downto 0);
    signal digit_3 : UNSIGNED (3 downto 0);
begin
    digit_0_o <= short_to_seg(digit_0)(7 downto 1);
    digit_1_o <= short_to_seg(digit_1)(7 downto 1);
    digit_2_o <= short_to_seg(digit_2)(7 downto 1);
    digit_3_o <= short_to_seg(digit_3)(7 downto 1);

    digit_0_o(0) <= '0' when selected_digit(0) = '1' else '1';
    digit_1_o(0) <= '0' when selected_digit(1) = '1' else '1';
    digit_2_o(0) <= '0' when selected_digit(2) = '1' else '1';
    digit_3_o(0) <= '0' when selected_digit(3) = '1' else '1';

    process (ps2_clk_i) begin
        if falling_edge(ps2_clk_i) then
            -- Swap states
            case pipeline_state is
                when IDLE => pipeline_state <= MOVE;
                when MOVE => pipeline_state <= CALC;
                when CALC => pipeline_state <= IDLE;
            end case;

            if pipeline_state = MOVE then
                x_pos <= x_pos + dx_pos_i;
                r_pos <= r_pos + dr_pos_i;

                btn_left_last_state <= btn_left;
                btn_left <= btn_left_i;
            end if;

            if pipeline_state = CALC then
                if edit_lock = '0' then
                    if (x_pos >   HALF_RANGE ) and (selected_digit /= "0001")
                        then x_pos <= TO_SIGNED(-HALF_RANGE, 16); ROTATE_RIGHT(selected_digit, 1);
                    end if;

                    if (x_pos < (-HALF_RANGE)) and (selected_digit /= "1000")
                        then x_pos <= TO_SIGNED( HALF_RANGE, 16); ROTATE_LEFT (selected_digit, 1);
                    end if;

                    case selected_digit is
                        when "1000" =>
                            if (r_pos > SCRL_RANGE) then r_pos <= (others => '0'); digit_0 <= digit_0 + 1; end if;
                            if (r_pos < 0         ) then r_pos <= (others => '0'); digit_0 <= digit_0 - 1; end if;
                        when "0100" =>
                            if (r_pos > SCRL_RANGE) then r_pos <= (others => '0'); digit_1 <= digit_1 + 1; end if;
                            if (r_pos < 0         ) then r_pos <= (others => '0'); digit_1 <= digit_1 - 1; end if;
                        when "0010" =>
                            if (r_pos > SCRL_RANGE) then r_pos <= (others => '0'); digit_2 <= digit_2 + 1; end if;
                            if (r_pos < 0         ) then r_pos <= (others => '0'); digit_2 <= digit_2 - 1; end if;
                        when "0001" =>
                            if (r_pos > SCRL_RANGE) then r_pos <= (others => '0'); digit_3 <= digit_3 + 1; end if;
                            if (r_pos < 0         ) then r_pos <= (others => '0'); digit_3 <= digit_3 - 1; end if;
                    end case;
                end if;

                if btn_left_last_state = '0' and btn_left = '1' then
                    edit_lock <= not edit_lock;
                end if;
            end if;
        end if;
    end process;
end architecture;
