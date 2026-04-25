-- ============================================================================
-- Institution: Brno University of Technology (VUT Brno)
-- Author:      [Richard Kralovsky]
-- Date:        April 2026
-- 
-- Block Name:  mood_led_top
-- Description: Top-level structural wrapper for the Mood LED Controller. 
--              Integrates debouncing logic, dynamic speed control, color 
--              fading, and brightness-aware PWM generation for RGB LEDs.
-- ============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mood_led_top is
  port (
        clk:  in std_logic;  
        btnc: in std_logic; --reset
        
        btnu: in std_logic; --brigthness up
        btnd: in std_logic; --brightness down
        
        btnr: in std_logic; --speed up
        btnl: in std_logic; --speed down
        
        led17_r: out std_logic;
        led17_g: out std_logic;
        led17_b: out std_logic
        );
end mood_led_top;

architecture Behavioral of mood_led_top is

    component debounce is
        Port ( clk       : in  STD_LOGIC;
               rst       : in  STD_LOGIC;
               btn_in    : in  STD_LOGIC;
               btn_state : out STD_LOGIC;
               btn_press : out STD_LOGIC);
    end component debounce;
    
    component clk_en_dyn is
        Port ( cnt_u : in  STD_LOGIC;
               cnt_d : in  STD_LOGIC;
               clk   : in  STD_LOGIC;
               rst   : in  STD_LOGIC;
               ce    : out STD_LOGIC);
    end component clk_en_dyn;
    
    component fade is
        Port ( ce    : in  STD_LOGIC;
               clk   : in  STD_LOGIC;
               rst   : in  STD_LOGIC;
               r_val : out STD_LOGIC_VECTOR (7 downto 0);
               g_val : out STD_LOGIC_VECTOR (7 downto 0);
               b_val : out STD_LOGIC_VECTOR (7 downto 0));
    end component fade;
    
    component bright_control is
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            cnt_u    : in  STD_LOGIC; -- already debounced signal
            cnt_d    : in  STD_LOGIC;
            brt      : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component bright_control;

    component pwm is
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            brt      : in  STD_LOGIC_VECTOR(7 downto 0);
            val      : in  STD_LOGIC_VECTOR(7 downto 0);
            led_pwr  : out STD_LOGIC
        );
    end component pwm;
    
    
    signal s_brtup  : std_logic;
    signal s_brtdw  : std_logic;
    signal s_spup   : std_logic;
    signal s_spdw   : std_logic;
    
    signal s_brt    : std_logic_vector (7 downto 0);
    signal s_ce_dyn : std_logic;
    signal s_ce     : std_logic;

    signal s_r_val  : std_logic_vector (7 downto 0);
    signal s_g_val  : std_logic_vector (7 downto 0);
    signal s_b_val  : std_logic_vector (7 downto 0);
    
begin
    debounce_u: component debounce --brightness up
        port map(
            clk         => clk,
            rst         => btnc,
            btn_in      => btnu,
            btn_state   => s_brtup,
            btn_press   => open
        );

    debounce_d: component debounce -- brightness down
        port map(
            clk         => clk,
            rst         => btnc,
            btn_in      => btnd,
            btn_state   => s_brtdw,
            btn_press   => open
        );

    debounce_r: component debounce --speed up
        port map(
            clk         => clk,
            rst         => btnc,
            btn_in      => btnr,
            btn_state   => open,
            btn_press   => s_spup
        );

    debounce_l: component debounce --speed down
        port map(
            clk         => clk,
            rst         => btnc,
            btn_in      => btnl,
            btn_state   => open,
            btn_press   => s_spdw
        );
        
    bright_control0: component bright_control
        port map(
            clk     => clk,
            rst     => btnc,
            cnt_u   => s_brtup,
            cnt_d   => s_brtdw,
            brt     => s_brt
        );
    
    clk_en_dyn0: component clk_en_dyn
        port map(
            clk     => clk,
            rst     => btnc,
            cnt_u   => s_spdw,  --internal counter up -> slower speed
            cnt_d   => s_spup,  --internal counter down -> faster speed
            ce      => s_ce_dyn
        );
        
     fade0: component fade
        port map(
            ce      => s_ce_dyn,
            clk     => clk,
            rst     => btnc,
            r_val   => s_r_val,
            g_val   => s_g_val,
            b_val   => s_b_val
        );
        
     pwm_r: component pwm
        port map(
            clk     => clk,
            rst     => btnc,
            brt     => s_brt,
            val     => s_r_val,
            led_pwr => led17_r
        );
        
     pwm_g: component pwm
        port map(
            clk     => clk,
            rst     => btnc,
            brt     => s_brt,
            val     => s_g_val,
            led_pwr => led17_g
        );
        
     pwm_b: component pwm
        port map(
            clk     => clk,
            rst     => btnc,
            brt     => s_brt,
            val     => s_b_val,
            led_pwr => led17_b
        );  
end Behavioral;
