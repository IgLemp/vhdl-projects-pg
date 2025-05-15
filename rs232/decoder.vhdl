library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity decoder is
    generic (
        CLOCK_FREQENCY: NATURAL := 100_000_000;
        BAUD_RATE     : NATURAL :=       9_600
    );
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        RXD_i : in STD_LOGIC;

        recv_o :     out STD_LOGIC_VECTOR (7 downto 0);
        recv_ready : out STD_LOGIC
    );
end entity;

architecture decoder of decoder is
    constant SEGMENT_LENGTH : NATURAL := CLOCK_FREQENCY / BAUD_RATE;
    constant QUARTER_LENGTH : NATURAL := SEGMENT_LENGTH / 4;
    signal counter : NATURAL := 0;

    signal current_bit : UNSIGNED (3 downto 0) := "0000";

    signal RXD_b : STD_LOGIC := '0'; -- Buffered
    signal RXD_s_p : STD_LOGIC := '0'; -- Synced previous RXD signal
    signal RXD_s :   STD_LOGIC := '0'; -- Synced current  RXD signal

    signal frame_bits : STD_LOGIC_VECTOR (9 downto 0);
    alias message_bits : STD_LOGIC_VECTOR (7 downto 0) is frame_bits (8 downto 1);

    type STATE_T is (IDLE, START, WORKING, STOP);
    signal state : STATE_T := IDLE;
begin
    process (clk_i) begin
        if falling_edge(rst_i) then
            RXD_b <= '0';
            RXD_s <= '0';
        elsif falling_edge(clk_i) then
            -- 2FF input sync and last signal
            RXD_b   <= RXD_i;
            RXD_s_p <= RXD_b;
            RXD_s   <= RXD_s_p;

            -- Frame synch
            -- Detect frame start on falling edge
            if (state = IDLE) and (not RXD_s) and (RXD_s_p) then state <= START; end if;

            -- Here we offset the counter by quarter segment length
            if state = START then
                if counter = QUARTER_LENGTH then
                    state <= WORKING;
                    counter <= 0;
                    current_bit <= current_bit + 1;
                else counter <= counter + 1; end if;
            end if;

            if state = WORKING then
                if (counter = SEGMENT_LENGTH) and (current_bit /= 8) then
                    case current_bit is
                        when "0000" => frame_bits(0) <= RXD_s;
                        when "0001" => frame_bits(1) <= RXD_s;
                        when "0010" => frame_bits(2) <= RXD_s;
                        when "0011" => frame_bits(3) <= RXD_s;
                        when "0100" => frame_bits(4) <= RXD_s;
                        when "0101" => frame_bits(5) <= RXD_s;
                        when "0110" => frame_bits(6) <= RXD_s;
                        when "0111" => frame_bits(7) <= RXD_s;
                        when "1000" => frame_bits(8) <= RXD_s;
                        when "1001" => frame_bits(9) <= RXD_s; -- This is never reached
                        when others =>
                    end case;

                    counter <= 0; -- Reset counter
                    current_bit <= current_bit + 1; -- Advance bit
                end if;

                -- Set state to STOP
                -- Not technically nesscecery since we don't do anything on stop
                -- Buuuut idk migh use someday...
                if current_bit = 8 then state <= STOP; end if;
            end if;

            -- Send data to driver
            if STATE = STOP then
                recv_ready <= '1';
                current_bit <= "0000";
                state <= IDLE;
            end if;

            -- Reset recv_ready
            if state = IDLE then recv_ready <= '0'; end if;
        end if;
    end process;
end architecture;
