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
    
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
    --OTHER COMPONENTS (bright_control, PWM)
    
    
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


end Behavioral;
