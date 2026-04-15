library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_tb is
end pwm_tb;

architecture Behavioral of pwm_tb is

    component pwm
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            brt      : in  STD_LOGIC_VECTOR(7 downto 0);
            val      : in  STD_LOGIC_VECTOR(7 downto 0);
            led_pwr  : out STD_LOGIC
        );
    end component;

    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '0';
    signal brt      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal val      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal led_pwr  : STD_LOGIC;

    constant clk_period : time := 1 ns;
    constant pwm_period : time := clk_period * 65536;

begin

    uut: pwm 
        port map (
            clk => clk,
            rst => rst,
            brt => brt,
            val => val,
            led_pwr => led_pwr
        );

    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin        
        -- Inicializace: val na 100%, brt na 0%
        val <= std_logic_vector(to_unsigned(255, 8)); 
        brt <= std_logic_vector(to_unsigned(0, 8)); 

        -- Reset systému
        rst <= '1';
        wait for 100 ns;    
        rst <= '0';
        
        -- --- VZESTUPNÁ FÁZE (měníme brt) ---
        
        -- 1. FÁZE: brt = 0 (0% jas) -> 1 cyklus
        report "Starting phase: brt 0%";
        wait for pwm_period;

        -- 2. FÁZE: brt = 128 (cca 50% jas) -> 2 cykly
        report "Starting phase: brt 50%";
        brt <= std_logic_vector(to_unsigned(128, 8));
        wait until falling_edge(led_pwr);
        wait until falling_edge(led_pwr);

        -- 3. FÁZE: brt = 255 (cca 100% jas) -> 2 cykly
        report "Starting phase: brt 100%, val 100%";
        brt <= std_logic_vector(to_unsigned(255, 8));
        wait until falling_edge(led_pwr);
        wait until falling_edge(led_pwr);
        
        -- --- SESTUPNÁ FÁZE (měníme val) ---
        
        -- 4. FÁZE: val = 128 (cca 50% jas) -> 2 cykly
        report "Starting phase: val down to 50%";
        val <= std_logic_vector(to_unsigned(128, 8));
        wait until falling_edge(led_pwr);
        wait until falling_edge(led_pwr);

        -- 5. FÁZE: val = 0 (0% jas) -> 1 cyklus
        report "Starting phase: val down to 0%";
        val <= std_logic_vector(to_unsigned(0, 8));
        wait for pwm_period;
        
        -- Konec simulace
        wait for 10 us;
        report "Simulation sequence finished successfully";
        wait;
    end process;

end Behavioral;