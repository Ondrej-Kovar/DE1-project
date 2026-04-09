library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_tb is
end pwm_tb;

architecture Behavioral of pwm_tb is

    -- tested component (UUT - Unit Under Test)
    component PWM_Module
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            brt      : in  unsigned(7 downto 0);
            val      : in  unsigned(7 downto 0);
            led_pwr  : out STD_LOGIC
        );
    end component;

    -- signals for connecting UUT
    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '0';
    signal brt      : unsigned(7 downto 0) := (others => '0');
    signal val      : unsigned(7 downto 0) := (others => '0');
    signal led_pwr  : STD_LOGIC;

    constant clk_period : time := 10 ns;

begin

    -- Instancing PWM module
    uut: PWM_Module 
        port map (
            clk => clk,
            rst => rst,
            brt => brt,
            val => val,
            led_pwr => led_pwr
        );

    -- clk generator
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- stimuli process
    stim_proc: process
    begin		
        -- system reset
        rst <= '1';
        wait for 50 ns;	
        rst <= '0';
        wait for clk_period * 10;

        -- low duty_cycle (eg. 10 * 20 = 200 z 65535)
        brt <= to_unsigned(10, 8);
        val <= to_unsigned(20, 8);
        
        -- waiting for new cycle (65536 ticks)
        wait until falling_edge(led_pwr);

        -- 3. change to 50% (128 * 256 = 32768, roughly half of 65535)
        brt <= to_unsigned(128, 8);
        val <= to_unsigned(255, 8);

        -- keep simulation running
        wait for clk_period * 100000;

        -- stop simulation
        report "Simulation completed";
        wait;
    end process;

end Behavioral;
