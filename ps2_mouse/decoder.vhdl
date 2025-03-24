library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity driver is
    generic ( CLOCK_CONVERSION : NATURAL := 30_000 );
    port (
        ps2_clk_i  : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        x_position    : out SIGNED (15 downto 0);
        y_position    : out SIGNED (15 downto 0);
        roll_position : out SIGNED (15 downto 0);
        button_left   : out STD_LOGIC;
        button_right  : out STD_LOGIC
    );
end entity;

architecture driver of driver is
    type FRAME_T is (HEAD, X_MOV, Y_MOV, TAIL);
    type ERROR_T is (OK, SYNCH_FUCKED, FRAME_FUCKED);

    signal counter : UNSIGNED (3 downto 0);
    signal frame_bits : STD_LOGIC_VECTOR (7 downto 0);
    signal frame_position : FRAME_T := HEAD;
    signal error_state: ERROR_T := OK;

    --signal synch_buffer : UNSIGNED (10 downto 0) := (others => '0');

    -- Processing data
    signal x_negative : STD_LOGIC := '0';
    signal y_negative : STD_LOGIC := '0';

    -- Outputed data
    signal x_position    : SIGNED (15 downto 0) := (others => '0');
    signal y_position    : SIGNED (15 downto 0) := (others => '0');
    signal roll_position : SIGNED (15 downto 0) := (others => '0');
    signal button_left  : STD_LOGIC := '0';
    signal button_right : STD_LOGIC := '0';

begin
    process (ps2_clk_i) begin
        if falling_edge(ps2_clk_i) then
            -- Desynch checks, hopefully doesn't happen
            if counter =  0 then if ps2_data_i /= '0' then error_state <= SYNCH_FUCKED; end if; end if;
            if counter = 10 then if ps2_data_i /= '1' then error_state <= SYNCH_FUCKED; end if; end if;

            if frame_position = HEAD and counter = 4 then
                if ps2_data_i /= '1' then error_state <= SYNCH_FUCKED; end if;
            end if;

            if frame_position = TAIL and (counter = 7 or counter = 8) then
                if ps2_data_i /= '0' then error_state <= SYNCH_FUCKED; end if;
            end if;

            -- Check for parity, mouse sends 1 if yes, xor returns 1 if no
            if counter = 9 and (xor frame_bits = ps2_data_i) then error_state <= FRAME_FUCKED; end if;

            -- Save frame bits for fursther processing at the end
            if counter > 0 and counter < 9 then
                frame_bits(TO_INTEGER(counter - 1)) <= ps2_data_i;
            end if;

            -- Swap to next frame
            if counter = 10 then
                counter <= (others => '0');
                case frame_position is
                    when HEAD  => frame_position <= X_MOV;
                    when X_MOV => frame_position <= Y_MOV;
                    when Y_MOV => frame_position <= TAIL;
                    when TAIL  => frame_position <= HEAD;
                end case;

                -- We won't handle the posibility of fucked frames
                case frame_position is
                    when HEAD =>
                        button_left  <= frame_bits(0);
                        button_right <= frame_bits(1);
                        x_negative <= frame_bits(4);
                        y_negative <= frame_bits(5);
                    when X_MOV =>
                        x_position <= x_position + SIGNED(x_negative & frame_bits);
                    when Y_MOV =>
                        y_position <= y_position + SIGNED(y_negative & frame_bits);
                    when TAIL =>
                        roll_position <= roll_position + SIGNED(frame_bits(3 downto 0));
                end case;
            end if;
        end if;
    end process;
end architecture;
