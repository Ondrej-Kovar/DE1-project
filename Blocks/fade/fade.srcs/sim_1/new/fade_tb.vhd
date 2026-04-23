library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fade_analog_tb is
end fade_analog_tb;

architecture testbench of fade_analog_tb is

    constant C_CLK_PERIOD : time := 10 ns;

    signal s_clk   : std_logic := '0';
    signal s_rst   : std_logic := '0';
    signal s_ce    : std_logic := '0';
    
    signal s_r_val : std_logic_vector(7 downto 0);
    signal s_g_val : std_logic_vector(7 downto 0);
    signal s_b_val : std_logic_vector(7 downto 0);

begin

    uut_fade: entity work.fade
        port map (
            clk   => s_clk,
            rst   => s_rst,
            ce    => s_ce,
            r_val => s_r_val,
            g_val => s_g_val,
            b_val => s_b_val
        );

    p_clk_gen : process
    begin
        while now < 32 us loop  -- Čas prodloužen na 32 us pro celý cyklus + přesah
            s_clk <= '0';
            wait for C_CLK_PERIOD / 2;
            s_clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    p_ce_gen : process
    begin
        while now < 32 us loop  -- Čas prodloužen na 32 us
            s_ce <= '0';
            wait for 1 * C_CLK_PERIOD;
            s_ce <= '1';
            wait for 1 * C_CLK_PERIOD;
        end loop;
        wait;
    end process p_ce_gen;

    p_stimulus : process
    begin
        s_rst <= '1';
        wait for 35 ns;
        s_rst <= '0';
        
        wait;
    end process p_stimulus;

end testbench;