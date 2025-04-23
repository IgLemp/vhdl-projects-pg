type ERROR_T is (OK, SYNCH_FUCKED, FRAME_FUCKED);
signal error_state: ERROR_T := OK;



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

--signal synch_buffer : UNSIGNED (10 downto 0) := (others => '0');



-- Handles end of frame state shanges
-- That is it runs on per PACKET basis
-- NOTICE: Tail doesn't contain any important data to us
--         besides sync, so it can be safely ignored
if frame_position = TAIL and counter = 0 then
    -- Handle mouse clicks for locking
    if (last_button_left_state = '0') and (button_left = '1') then
        edit_lock <= not edit_lock;
    end if;

    -- This happens only after next iteration
    if edit_lock = '1' then
        -- Handle X motion
        if      x_position >   MOTION_SCALE  then X_MOV <= 0; ROTATE_RIGHT(selected_digit, 1);
        else if x_position < (-MOTION_SCALE) then X_MOV <= 0; ROTATE_LEFT (selected_digit, 1);
        end if;

        -- Handle scroll motion
        if      roll_position > MOTION_SCALE then
            roll_position <= 0;
            case selected_digit is
                when "0001" => digit_0 + 1;
                when "0010" => digit_1 + 1;
                when "0100" => digit_2 + 1;
                when "1000" => digit_3 + 1;
            end case
        else if roll_position < MOTION_SCALE then
            roll_position <= 0;
            case selected_digit is
                when "0001" => digit_0 - 1;
                when "0010" => digit_1 - 1;
                when "0100" => digit_2 - 1;
                when "1000" => digit_3 - 1;
            end case;
        end if;
    end if;
end if;



if (x_pos >   HALF_RANGE ) and (selected_digit /= "0001")
    --          Set pos bottom    Add movement that went over the top
    then x_pos <= (-HALF_RANGE) + (x_pos - HALF_RANGE); ROTATE_RIGHT(selected_digit, 1);
end if;

if (x_pos < (-HALF_RANGE)) and (selected_digit /= "1000")
    then x_pos <= TO_SIGNED( HALF_RANGE, 16); ROTATE_LEFT (selected_digit, 1);
    then x_pos <=   HALF_RANGE  + (x_pos + HALF_RANGE); ROTATE_LEFT (selected_digit, 1);
    --             Set pos top    Add movement that went under the bottom
end if;
