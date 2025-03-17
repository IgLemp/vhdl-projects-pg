library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.utils.all;

entity driver is
    generic ( MILLI_CYCLE : NATURAL := 100_000 );
    port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        start_stop_button_i : in STD_LOGIC;
        digit_o : out STD_LOGIC_VECTOR (31 downto 0)
    );
end entity;

architecture driver of driver is
    type E_STATE is (START, STOP, RESET, OVERFLOW);
    signal state : E_STATE := RESET;
    signal ticks : NATURAL := 1;
    signal lock  : NATURAL := MILLI_CYCLE * 5;

    signal timer_ss : UNSIGNED (7 downto 0) := (others => '0');
    signal timer_dd : UNSIGNED (7 downto 0) := (others => '0');

    alias ss_major : UNSIGNED (3 downto 0) is timer_ss (7 downto 4);
    alias ss_minor : UNSIGNED (3 downto 0) is timer_ss (3 downto 0);
    alias dd_major : UNSIGNED (3 downto 0) is timer_dd (7 downto 4);
    alias dd_minor : UNSIGNED (3 downto 0) is timer_dd (3 downto 0);
begin
    with state select digit_o <=
        (short_to_seg(ss_major), short_to_seg(ss_minor), short_to_seg(dd_major), short_to_seg(dd_minor)) when START,
        (short_to_seg(ss_major), short_to_seg(ss_minor), short_to_seg(dd_major), short_to_seg(dd_minor)) when STOP,
        (SEG_ZERO,               SEG_ZERO,               SEG_ZERO,               SEG_ZERO)               when RESET,
        (SEG_DASH,               SEG_DASH,               SEG_DASH,               SEG_DASH)               when OVERFLOW;
    process (clk_i, rst_i) begin
        if rst_i = '1' then
            state <= RESET;
            ticks <= 1;
            timer_ss <= (others => '0');
            timer_dd <= (others => '0');
        elsif rising_edge(clk_i) then
            -- Tick states
            ticks <= ticks + 1 when state = START;
            lock  <= lock  + 1 when lock /= MILLI_CYCLE * 5;

            if (start_stop_button_i = '1') and (lock = MILLI_CYCLE * 5) then
                lock <= 1;
                case state is
                    when START    => state <= STOP;
                    when STOP     => state <= RESET; ticks <= 0; timer_dd <= (others => '0'); timer_ss <= (others => '0');
                    when RESET    => state <= START;
                    when OVERFLOW => state <= STOP;  ticks <= 0; timer_dd <= (others => '0'); timer_ss <= (others => '0');
                end case;
            end if;

            -- The rest of states are unimportant here since the chane
            -- of internal buffers of the clock and output to display is
            -- handled by asynchronous combinatory logic above the process
            if state = START then
                -- Assuming f = 10 MHz => T = 10 ns
                if ticks = MILLI_CYCLE  then
                    ticks <= 1;
                    -- Cascading BCD addition
                    if    (ss_major = 5) and (ss_minor = 9) and (dd_major = 5) and (dd_minor = 9) then
                        state <= OVERFLOW;
                    elsif                    (ss_minor = 9) and (dd_major = 5) and (dd_minor = 9) then
                        ss_major <= ss_major + 1;
                        ss_minor <= (others => '0');
                        dd_major <= (others => '0');
                        dd_minor <= (others => '0');
                    elsif                                       (dd_major = 5) and (dd_minor = 9) then
                        ss_minor <= ss_minor + 1;
                        dd_major <= (others => '0');
                        dd_minor <= (others => '0');
                    elsif                                                          (dd_minor = 9) then
                        dd_major <= dd_major + 1;
                        dd_minor <= (others => '0');
                    else
                        dd_minor <= dd_minor + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
