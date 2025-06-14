library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity decoder is
    port (
        ps2_clk_i  : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;

        frame_commit_o : out STD_LOGIC;

        dx_pos_o : out SIGNED (8 downto 0);
        dy_pos_o : out SIGNED (8 downto 0);
        dr_pos_o : out SIGNED (3 downto 0);
        btn_left_o  : out STD_LOGIC;
        btn_right_o : out STD_LOGIC
    );
end entity;

architecture decoder of decoder is
    type FRAME_T is (HEAD, X_MOV, Y_MOV, TAIL);

    signal counter : UNSIGNED (3 downto 0) := (others => '0');
    signal frame_bits : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
    alias message_bits : STD_LOGIC_VECTOR (7 downto 0) is frame_bits (8 downto 1);
    signal frame_position : FRAME_T := HEAD;

    -- Processing data
    signal x_neg : STD_LOGIC := '0';
    signal y_neg : STD_LOGIC := '0';

    -- Internal state data
    signal dx_pos : SIGNED (8 downto 0) := (others => '0');
    signal dy_pos : SIGNED (8 downto 0) := (others => '0');
    signal dr_pos : SIGNED (3 downto 0) := (others => '0');
    signal btn_left  : STD_LOGIC;
    signal btn_right : STD_LOGIC;
begin
    process (ps2_clk_i) begin
        if falling_edge(ps2_clk_i) then
            -- Incremet counter
            if counter /= 10 then counter <= counter + 1; end if;

            case counter is
                when "0000" => frame_bits(0)  <= ps2_data_i;
                when "0001" => frame_bits(1)  <= ps2_data_i;
                when "0010" => frame_bits(2)  <= ps2_data_i;
                when "0011" => frame_bits(3)  <= ps2_data_i;
                when "0100" => frame_bits(4)  <= ps2_data_i;
                when "0101" => frame_bits(5)  <= ps2_data_i;
                when "0110" => frame_bits(6)  <= ps2_data_i;
                when "0111" => frame_bits(7)  <= ps2_data_i;
                when "1000" => frame_bits(8)  <= ps2_data_i;
                when "1001" => frame_bits(9)  <= ps2_data_i;
                when "1010" => frame_bits(10) <= ps2_data_i;
                when others =>
            end case;

            -- Swap to next frame
            -- NOTICE: This logic runs on per frame basis!!!
            if counter = 10 then
                counter <= (others => '0');
                case frame_position is
                    when HEAD  => frame_position <= X_MOV;
                    when X_MOV => frame_position <= Y_MOV;
                    when Y_MOV => frame_position <= TAIL;
                    when TAIL  => frame_position <= HEAD;
                end case;

                -- We won't handle the posibility of screwed frames
                case frame_position is
                    when HEAD =>
                        btn_left  <= message_bits(0);
                        btn_right <= message_bits(1);
                        x_neg <= message_bits(4);
                        y_neg <= message_bits(5);
                    when X_MOV => dx_pos <= SIGNED(x_neg & message_bits);
                    when Y_MOV => dy_pos <= SIGNED(y_neg & message_bits);
                    when TAIL => dr_pos <= SIGNED(message_bits(3 downto 0));
                end case;
            end if;

            -- Commit buffers to output
            if (frame_position = TAIL) and (counter = 10) then
                dx_pos_o <= dx_pos;
                dy_pos_o <= dy_pos;
                dr_pos_o <= dr_pos;
                btn_left_o  <= btn_left;
                btn_right_o <= btn_right;
            end if;

            -- Signal that data has been set
            if (frame_position = TAIL) and (counter = 10)
                then frame_commit_o <= '1';
                else frame_commit_o <= '0';
            end if;
        end if;
    end process;
end architecture;
