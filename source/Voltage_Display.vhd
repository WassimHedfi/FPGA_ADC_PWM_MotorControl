LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY Voltage_Display IS
    PORT(
        adc_value : IN std_logic_vector(11 downto 0);  -- 12-bit ADC input
        hex0, hex1, hex2 : OUT std_logic_vector(7 downto 0)  -- 7-segment display outputs
    );
END Voltage_Display;

ARCHITECTURE arch OF Voltage_Display IS
    SIGNAL voltage_value  : integer := 0;
    SIGNAL display_value  : integer := 0;
    SIGNAL hundreds       : integer := 0;
    SIGNAL tens           : integer := 0;
    SIGNAL unit          : integer := 0;

    -- Function to decode a single decimal digit to 7-segment display
    FUNCTION seven_segment_decode_DP(digit : integer) RETURN std_logic_vector IS
    BEGIN
        CASE digit IS
            WHEN 0 => RETURN "01000000";  -- 0
            WHEN 1 => RETURN "01111001";  -- 1
            WHEN 2 => RETURN "00100100";  -- 2
            WHEN 3 => RETURN "00110000";  -- 3
            WHEN 4 => RETURN "00011001";  -- 4
            WHEN 5 => RETURN "00010010";  -- 5
            WHEN 6 => RETURN "00000010";  -- 6
            WHEN 7 => RETURN "01111000";  -- 7
            WHEN 8 => RETURN "00000000";  -- 8
            WHEN 9 => RETURN "00010000";  -- 9
            WHEN OTHERS => RETURN "11111111";  -- Blank
        END CASE;
    END FUNCTION;
	 
	 
	     FUNCTION seven_segment_decode(digit : integer) RETURN std_logic_vector IS
    BEGIN
        CASE digit IS
            WHEN 0 => RETURN "11000000";  -- 0
            WHEN 1 => RETURN "11111001";  -- 1
            WHEN 2 => RETURN "10100100";  -- 2
            WHEN 3 => RETURN "10110000";  -- 3
            WHEN 4 => RETURN "10011001";  -- 4
            WHEN 5 => RETURN "10010010";  -- 5
            WHEN 6 => RETURN "10000010";  -- 6
            WHEN 7 => RETURN "11111000";  -- 7
            WHEN 8 => RETURN "10000000";  -- 8
            WHEN 9 => RETURN "10010000";  -- 9
            WHEN OTHERS => RETURN "11111111";  -- Blank
        END CASE;
    END FUNCTION;
    
BEGIN
    -- Convert ADC value to a voltage in the range 0-330 (corresponding to 0.00 - 3.30V)
    PROCESS(adc_value)
    BEGIN
        voltage_value <= (to_integer(unsigned(adc_value)) * 330) / 4095;  -- Scale to 0-330
    END PROCESS;

    -- Separate the voltage value into hundreds, tens, and units for display
    PROCESS(voltage_value)
    BEGIN
        display_value <= voltage_value;  -- e.g., 1.23V represented as 123
        hundreds <= display_value / 100;            -- Digit before the decimal
        tens     <= (display_value / 10) mod 10;    -- First digit after the decimal
        unit    <= display_value mod 10;           -- Second digit after the decimal
    END PROCESS;

    -- Map the separated digits to the 7-segment displays
    hex0 <= seven_segment_decode(unit);  -- Least significant digit (after decimal point)
    hex1 <= seven_segment_decode(tens);  -- Middle digit (after decimal point) with decimal point enabled
    hex2 <= seven_segment_decode_DP(hundreds);  -- Most significant digit (before decimal point)

END arch;
