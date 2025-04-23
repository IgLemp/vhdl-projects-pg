library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.utils.all;

entity driver is
    generic ( DOTS_PER_MILLIM : NATURAL := 32 ); -- dots per millimeter
    port (
        clk_i : in STD_LOGIC;
        frame_commit_i : in STD_LOGIC;

        dx_pos_i : in SIGNED (8 downto 0);
        dy_pos_i : in SIGNED (8 downto 0);
        dr_pos_i : in SIGNED (3 downto 0);
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
    signal frame_commit_last : STD_LOGIC := '0';

    signal x_pos : SIGNED (15 downto 0) := (others => '0');
    signal y_pos : SIGNED (15 downto 0) := (others => '0');
    signal btn_left  : STD_LOGIC := '0';

    signal btn_left_last_state : STD_LOGIC := '0';
    signal edit_lock : STD_LOGIC := '0';

    -- Outputed data
    signal selected_digit : UNSIGNED (3 downto 0) := "1000";
    alias digit_0_o : STD_LOGIC_VECTOR (7 downto 0) is digit_o (31 downto 24);
    alias digit_1_o : STD_LOGIC_VECTOR (7 downto 0) is digit_o (23 downto 16);
    alias digit_2_o : STD_LOGIC_VECTOR (7 downto 0) is digit_o (15 downto  8);
    alias digit_3_o : STD_LOGIC_VECTOR (7 downto 0) is digit_o (7  downto  0);

    signal digit_0 : UNSIGNED (3 downto 0) := (others => '0');
    signal digit_1 : UNSIGNED (3 downto 0) := (others => '0');
    signal digit_2 : UNSIGNED (3 downto 0) := (others => '0');
    signal digit_3 : UNSIGNED (3 downto 0) := (others => '0');
begin
    digit_0_o(7 downto 1) <= (short_to_seg(digit_0)(7 downto 1));
    digit_1_o(7 downto 1) <= (short_to_seg(digit_1)(7 downto 1));
    digit_2_o(7 downto 1) <= (short_to_seg(digit_2)(7 downto 1));
    digit_3_o(7 downto 1) <= (short_to_seg(digit_3)(7 downto 1));

    digit_0_o(0) <= '0' when selected_digit(0) = '1' else '1';
    digit_1_o(0) <= '0' when selected_digit(1) = '1' else '1';
    digit_2_o(0) <= '0' when selected_digit(2) = '1' else '1';
    digit_3_o(0) <= '0' when selected_digit(3) = '1' else '1';

    process (clk_i) begin
        if falling_edge(clk_i) then
            frame_commit_last <= frame_commit_i;

            if frame_commit_last = '1' and frame_commit_i = '0' then pipeline_state <= MOVE; end if;

            -- Swap states
            case pipeline_state is
                when IDLE =>
                when MOVE => pipeline_state <= CALC;
                when CALC => pipeline_state <= IDLE;
            end case;

            if pipeline_state = MOVE then
                if edit_lock = '0' then
                    x_pos <= x_pos + dx_pos_i;
                    y_pos <= y_pos + dy_pos_i;
                end if;

                btn_left_last_state <= btn_left;
                btn_left <= btn_left_i;
            end if;

            if pipeline_state = CALC then
                if edit_lock = '0' then
                    if (x_pos >   HALF_RANGE ) then
                        x_pos <= TO_SIGNED(-HALF_RANGE + 1, 16);
                        if (selected_digit /= "0001") then selected_digit <= ROTATE_RIGHT(selected_digit, 1); end if;
                    end if;

                    if (x_pos < (-HALF_RANGE)) then
                        x_pos <= TO_SIGNED( HALF_RANGE - 1, 16);
                        if (selected_digit /= "1000") then selected_digit <= ROTATE_LEFT (selected_digit, 1); end if;
                    end if;

                    case selected_digit is
                        when "1000" =>
                            if (y_pos > SCRL_RANGE) then y_pos <= (others => '0'); digit_3 <= digit_3 + 1; end if;
                            if (y_pos < 0         ) then y_pos <= (others => '0'); digit_3 <= digit_3 - 1; end if;
                        when "0100" =>
                            if (y_pos > SCRL_RANGE) then y_pos <= (others => '0'); digit_2 <= digit_2 + 1; end if;
                            if (y_pos < 0         ) then y_pos <= (others => '0'); digit_2 <= digit_2 - 1; end if;
                        when "0010" =>
                            if (y_pos > SCRL_RANGE) then y_pos <= (others => '0'); digit_1 <= digit_1 + 1; end if;
                            if (y_pos < 0         ) then y_pos <= (others => '0'); digit_1 <= digit_1 - 1; end if;
                        when "0001" =>
                            if (y_pos > SCRL_RANGE) then y_pos <= (others => '0'); digit_0 <= digit_0 + 1; end if;
                            if (y_pos < 0         ) then y_pos <= (others => '0'); digit_0 <= digit_0 - 1; end if;
                        when others =>
                    end case;
                end if;

                if btn_left_last_state = '0' and btn_left = '1' then
                    edit_lock <= not edit_lock;
                end if;
            end if;
        end if;
    end process;
end architecture;
