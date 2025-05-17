library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity driver is
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;

        recv_i : in  STD_LOGIC_VECTOR (7 downto 0);
        send_o : out STD_LOGIC_VECTOR (7 downto 0);

        recv_ready_i : in  STD_LOGIC;
        send_ready_o : out STD_LOGIC
    );
end entity;

architecture driver of driver is
    signal data_b : STD_LOGIC_VECTOR (7 downto 0);

    type STATE_T is (IDLE, CALC, SEND);
    signal state : STATE_T := IDLE;

    signal recv_ready_p : STD_LOGIC := '0';
begin
    process (clk_i, rst_i) begin
        if rst_i = '1' then
            recv_ready_p <= '0';
            data_b <= (others => '0');
            state <= IDLE;
        elsif falling_edge(clk_i) then
            recv_ready_p <= recv_ready_i;

            -- Switch to active state after "falling edge"
            if (state = IDLE) and (not recv_ready_i) and (recv_ready_p) then state <= CALC; end if;

            -- Calculate the value and save to buffer
            if (state = CALC) then
                data_b <= std_logic_vector(unsigned(recv_i) + signed(16#20#, 8), 8)
                state <= SEND;
            end if;

            -- Signal the message is ready to send and send it
            if (state = SEND) then
                send_o <= data_b;
                send_ready_o <= '1';
            end if;

            -- Dont remember to set off the falling edge
            if (state = IDLE) then send_ready_o <= '0'; end if;
        end if;
    end process;
end architecture;
