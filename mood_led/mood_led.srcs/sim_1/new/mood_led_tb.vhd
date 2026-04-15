library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mood_led_top is
end tb_mood_led_top;

architecture Behavioral of tb_mood_led_top is

    -- Komponenta Top modulu
    component mood_led_top
        port (
            clk      : in  std_logic;
            btnc     : in  std_logic;
            btnu     : in  std_logic;
            btnd     : in  std_logic;
            btnr     : in  std_logic;
            btnl     : in  std_logic;
            led17_r  : out std_logic;
            led17_g  : out std_logic;
            led17_b  : out std_logic
        );
    end component;

    -- Signály pro simulaci fyzických tlačítek
    signal clk      : std_logic := '0';
    signal btnc     : std_logic := '0'; -- Reset
    signal btnu     : std_logic := '0'; -- Brightness UP
    signal btnd     : std_logic := '0'; -- Brightness DOWN
    signal btnr     : std_logic := '0'; -- Speed UP
    signal btnl     : std_logic := '0'; -- Speed DOWN
    
    -- Výstupy na LED
    signal led17_r  : std_logic;
    signal led17_g  : std_logic;
    signal led17_b  : std_logic;

    constant clk_period : time := 10 ns;

begin

    -- Instance tvého hlavního modulu (Unit Under Test)
    uut: mood_led_top
        port map (
            clk     => clk,
            btnc    => btnc,
            btnu    => btnu,
            btnd    => btnd,
            btnr    => btnr,
            btnl    => btnl,
            led17_r => led17_r,
            led17_g => led17_g,
            led17_b => led17_b
        );

    -- Generátor hodin 100 MHz
    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Hlavní testovací sekvence
    stim_proc: process
    begin
        -- 1. POČÁTEČNÍ RESET
        -- Všechny moduly se nastaví do výchozích stavů
        btnc <= '1';
        wait for 100 ns;
        btnc <= '0';
        wait for 1 us; -- Stabilizace po resetu

        -- 2. TEST Jasu (Krátký stisk BTNU)
        -- Čekáme dostatečně dlouho, aby to prošlo přes Debounce (při C_MAX=2 až 10)
        report "Pressing Brightness UP...";
        btnu <= '1';
        wait for 2 us; 
        btnu <= '0';
        wait for 10 us;

        -- 3. TEST Rychlosti (Krátký stisk BTNR)
        -- Přepne clk_en_dyn o jeden krok (rychlejší přeblikávání)
        report "Pressing Speed UP...";
        btnr <= '1';
        wait for 2 us;
        btnr <= '0';
        wait for 10 us;

        -- 4. TEST Dlouhého stisku (Držení BTND)
        -- Tady uvidíme, jestli funguje autorepeat v bright_control
        -- Držíme 50 us, což by při simulačních konstantách (např. 50) mělo stačit
        report "Holding Brightness DOWN (Long Press)...";
        btnd <= '1';
        wait for 50 us; 
        btnd <= '0';

        -- Necháme simulaci chvíli běžet, abychom viděli barvy v PWM
        wait for 100 us;
        
        report "Simulation finished successfully!";
        wait; -- Zastaví proces navždy
    end process;

end Behavioral;