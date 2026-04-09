library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_tb is
-- Testbench nemá porty
end pwm_tb;

architecture Behavioral of pwm_tb is

    -- Komponenta, kterou testujeme (UUT - Unit Under Test)
    component PWM_Module
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            brt      : in  unsigned(7 downto 0);
            val      : in  unsigned(7 downto 0);
            led_pwr  : out STD_LOGIC
        );
    end component;

    -- Signály pro propojení s UUT
    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '0';
    signal brt      : unsigned(7 downto 0) := (others => '0');
    signal val      : unsigned(7 downto 0) := (others => '0');
    signal led_pwr  : STD_LOGIC;

    -- Definice periody hodin (např. 100 MHz -> 10 ns)
    constant clk_period : time := 10 ns;

begin

    -- Instance PWM modulu
    uut: PWM_Module 
        port map (
            clk => clk,
            rst => rst,
            brt => brt,
            val => val,
            led_pwr => led_pwr
        );

    -- Generátor hodin
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulační proces
    stim_proc: process
    begin		
        -- 1. Reset systému
        rst <= '1';
        wait for 50 ns;	
        rst <= '0';
        wait for clk_period * 10;

        -- 2. Nastavení nízké střídy (např. 10 * 20 = 200 z 65535)
        brt <= to_unsigned(10, 8);
        val <= to_unsigned(20, 8);
        
        -- Počkáme na začátek nového cyklu (65536 taktů)
        -- V simulaci to trvá dlouho, tak počkáme jen na první náběh
        wait until falling_edge(led_pwr);

        -- 3. Změna jasu na 50% (128 * 256 = 32768, což je cca polovina z 65535)
        brt <= to_unsigned(128, 8);
        val <= to_unsigned(255, 8);

        -- Necháme simulaci běžet dostatečně dlouho
        wait for clk_period * 100000;

        -- Zastavení simulace
        report "Simulace dokoncena";
        wait;
    end process;

end Behavioral;