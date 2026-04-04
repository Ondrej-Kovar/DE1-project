library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clk_en_dyn is
    Port ( cnt_u : in  STD_LOGIC;
           cnt_d : in  STD_LOGIC;
           clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           ce    : out STD_LOGIC);
end clk_en_dyn;

architecture Behavioral of clk_en_dyn is
--simulation
--    constant C_STEP    : integer := 5;
--    constant C_MIN     : integer := 5;
--    constant C_MAX     : integer := 25;
--    constant C_DEFAULT : integer := 15;
   
--application
    constant C_STEP     : integer := 100_000;
    constant C_MIN      : integer := 10_000;
    constant C_MAX      : integer := 1_010_000;
    constant C_DEFAULT  : integer := 510_000;
    
-- Internal signals
    signal sig_limit : integer range 0 to C_MAX := C_DEFAULT;
    signal sig_cnt   : integer range 0 to C_MAX := 0;
begin

    limit_control: process(clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_limit <= C_DEFAULT;
                
            elsif cnt_d = '1' then --count down
                if sig_limit > (C_MIN + C_STEP) then --only if sig_limit can be decreased
                    sig_limit <= sig_limit - C_STEP;
                else
                    sig_limit <= C_MIN;
                end if;
                
             elsif cnt_u = '1' then --count up
                if sig_limit < (C_MAX - C_STEP) then --only if sig_limit can be increased
                    sig_limit <= sig_limit + C_STEP;
                else
                    sig_limit <= C_MAX;
                end if;
              end if;
           end if;       
    end process;
    
    
    
    counter: process (clk) is
    begin
        if rising_edge(clk) then  -- Synchronous process
            if rst = '1' then     -- High-active reset
                ce      <= '0';   -- Reset output
                sig_cnt <= 0;     -- Reset internal counter

            elsif sig_cnt >= sig_limit-1 then --limit -> ce = 1, reset
                ce      <='1';
                sig_cnt <= 0;

            else                --regular step
                ce      <= '0';
                sig_cnt <= sig_cnt + 1;

            end if;  -- End if for reset/check
        end if;      -- End if for rising_edge
    end process;


end Behavioral;