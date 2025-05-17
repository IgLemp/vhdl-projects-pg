library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity encoder is
    generic (
        CLOCK_FREQENCY: NATURAL := 100_000_000;
        BAUD_RATE     : NATURAL :=       9_600
    );
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        TXD_o : out STD_LOGIC;

        send_i :       in STD_LOGIC_VECTOR (7 downto 0);
        send_ready_i : in STD_LOGIC
    );
end entity;

architecture encoder of encoder is
    constant SEGMENT_LENGTH : NATURAL := CLOCK_FREQENCY / BAUD_RATE;
    constant QUARTER_LENGTH : NATURAL := SEGMENT_LENGTH / 4;
    signal counter : NATURAL := 0;

    signal current_bit : UNSIGNED (3 downto 0);

    type STATE_T is (IDLE, START, WORKING, STOP);
    signal state : STATE_T := IDLE;

    signal send_ready_p : STD_LOGIC := '1';
begin
    process (clk_i, rst_i) begin
        if rst_i = '1' then
            TXD_o <= '1';
            send_ready_p <= '0';
        elsif falling_edge(clk_i) then
            send_ready_p <= send_ready;

            -- Frame synch
            -- Detect frame start on falling edge
            if (state = IDLE) and (not send_ready) and (send_ready_p) then state <= START; end if;

            -- Here we offset the counter by quarter segment length
            if state = START then
                TXD_o <= '0';
                if counter = SEGMENT_LENGTH then
                    state <= WORKING;
                    counter <= 0;
                    -- Notice the lack of setting current_bit to 1
                else counter <= counter + 1; end if;
            end if;

            if state = WORKING then
                if (counter = SEGMENT_LENGTH) and (current_bit /= 8) then
                    case current_bit is
                        when "0000" => TXD_o <= send_i(0);
                        when "0001" => TXD_o <= send_i(1);
                        when "0010" => TXD_o <= send_i(2);
                        when "0011" => TXD_o <= send_i(3);
                        when "0100" => TXD_o <= send_i(4);
                        when "0101" => TXD_o <= send_i(5);
                        when "0110" => TXD_o <= send_i(6);
                        when "0111" => TXD_o <= send_i(7);
                        when others =>
                    end case;

                    counter <= 0; -- Reset counter
                    current_bit <= current_bit + 1; -- Advance bit
                end if;

                -- Set state to STOP'
                -- Comparing with decoder, this position is downset by 1
                if current_bit = 7 then state <= STOP; end if;
            end if;

            -- Send data to driver
            if STATE = STOP then
                current_bit <= "0000";
                TXD_o <= '1';
                state <= IDLE;
            end if;
        end if;
    end process;
end architecture;
