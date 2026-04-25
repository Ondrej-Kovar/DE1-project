-- ============================================================================
-- Institution: Brno University of Technology (VUT Brno)
-- Author:      [Richard Kralovsky]
-- Date:        April 2026
-- 
-- Block Name:  fade
-- Description: Implements an RGB color wheel algorithm. Transitions through 
--              6 phases (Red -> Yellow -> Green -> Cyan -> Blue -> Magenta 
--              -> Red) to provide smooth color fading based on clk_en_dyn.
-- ============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fade is
    Port ( ce    : in  STD_LOGIC;
           clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           r_val : out STD_LOGIC_VECTOR (7 downto 0);   -- 8 bit outputs -> 0 to 255
           g_val : out STD_LOGIC_VECTOR (7 downto 0);
           b_val : out STD_LOGIC_VECTOR (7 downto 0));
end fade;

architecture Behavioral of fade is
    constant C_phase : integer := 255;                  -- how many steps are required for 1 phase
    constant C_max   : integer := 6*C_phase;            -- maximum of internal counter
    
    signal col_cnt   : integer range 0 to C_max := 0;
    signal sig_r     : integer range 0 to C_phase := 0; -- internal signals
    signal sig_g     : integer range 0 to C_phase := 0;
    signal sig_b     : integer range 0 to C_phase := 0;
begin
    color: process(clk)
    begin
        if rising_edge(clk) then
            if rst ='1' then                            -- reset
                col_cnt <= 0;                           -- integers to 0
                sig_r   <= 0;
                sig_g   <= 0;
                sig_b   <= 0;
                
                r_val   <= (others => '0');             -- all bits to 0
                g_val   <= (others => '0');
                b_val   <= (others => '0');
                
             elsif ce = '1' then 
                if col_cnt >= C_max - 1 then            -- once full cycle is completed col_cnt goes from 0 again
                    col_cnt <= 0;
                else                                    -- increment of col_cnt
                    col_cnt <= col_cnt + 1;
                end if;
                
                if col_cnt <= C_phase then              -- red -> yellow
                    sig_r <= C_phase;
                    sig_g <= col_cnt;                   -- g++
                    sig_b <= 0;
                    
                elsif col_cnt <= 2*C_phase then         -- yellow -> green
                    sig_r <= 2*C_phase - col_cnt;       -- r--
                    sig_g <= C_phase;
                    sig_b <= 0; 
                    
                elsif col_cnt <= 3*C_phase then         -- green -> cyan
                    sig_r <= 0;
                    sig_g <= C_phase;
                    sig_b <= col_cnt - 2*C_phase;       -- b++
                    
                elsif col_cnt <= 4*C_phase then         -- cyan -> blue
                    sig_r <= 0;
                    sig_g <= 4*C_phase - col_cnt;       -- g--
                    sig_b <= C_phase;            
                  
                elsif col_cnt <= 5*C_phase then         -- blue -> magenta
                    sig_r <= col_cnt - 4*C_phase;       -- r++
                    sig_g <= 0;
                    sig_b <= C_phase;
                    
                else                                    -- magenta -> red
                    sig_r <= C_phase;
                    sig_g <= 0;
                    sig_b <= C_max - col_cnt;           -- b--
                end if;
             
                -- final conversion to 8 bit vector with each ce signal
                r_val <= std_logic_vector(to_unsigned(sig_r, 8)); 
                g_val <= std_logic_vector(to_unsigned(sig_g, 8));
                b_val <= std_logic_vector(to_unsigned(sig_b, 8));
             end if;
         end if;
         
    end process;

end Behavioral;