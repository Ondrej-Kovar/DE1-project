library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        brt      : in  STD_LOGIC_VECTOR(7 downto 0);
        val      : in  STD_LOGIC_VECTOR(7 downto 0);
        led_pwr  : out STD_LOGIC
    );
end pwm;

architecture Behavioral of pwm is
    -- signal for computing duty cycle (8bit * 8bit = 16bit)
    signal duty_cycle : unsigned(15 downto 0);
    -- signal for storing duty cycle for whole period of pwm
    signal duty_stored : unsigned(15 downto 0);
    -- 16bit counter
    signal counter    : unsigned(15 downto 0) := (others => '0');
begin

    -- duty_cycle compute
    duty_cycle <= unsigned(brt) * unsigned(val);

    -- main counter process
    process(clk, rst)
    begin
        if rising_edge (clk) then
            if rst = '1' then
                led_pwr <= '0';
                counter <= (others => '0');
                duty_stored <= duty_cycle;
            else
                if counter < duty_stored then
                    led_pwr <= '1';
                else
                    led_pwr <= '0';
                end if;
                counter <= counter+1;
                -- keeping same value for whole period of pwm
                if counter = 2**16-1 then
                    duty_stored <= duty_cycle;
                end if;
            end if;
        end if;
    end process;

end Behavioral;