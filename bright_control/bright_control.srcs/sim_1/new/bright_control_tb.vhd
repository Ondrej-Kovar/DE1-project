library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bright_control is
end tb_bright_control;

architecture Behavioral of tb_bright_control is

    -- simulated component declaration (UUT - Unit Under Test)
    component bright_control
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            cnt_u    : in  STD_LOGIC;
            cnt_d    : in  STD_LOGIC;
            brt      : out STD_LOGIC_VECTOR(7 downto 0) -- ZMĚNĚNO na SLV
        );
    end component;

    -- signals for component connection
    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '0';
    signal cnt_u    : STD_LOGIC := '0';
    signal cnt_d    : STD_LOGIC := '0';
    signal brt      : STD_LOGIC_VECTOR(7 downto 0); -- ZMĚNĚNO na SLV

    -- defining clock period
    constant clk_period : time := 10 ns;

begin

    -- mapping testbench ports to module ports
    uut: bright_control 
        port map (
            clk => clk,
            rst => rst,
            cnt_u => cnt_u,
            cnt_d => cnt_d,
            brt => brt
        );

    -- generating clock signal
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- main stimuli process
    stim_proc: process
    begin        
        -- reset to default state
        rst <= '1';
        wait for 50 ns;    
        rst <= '0';
        wait for clk_period * 10;
        
        -- short press UP (should add 5 -> results in 133)
        cnt_u <= '1';
        wait for clk_period * 5; 
        cnt_u <= '0';
        wait for 200 ns; -- wait a bit to see the result

        -- short press DOWN (should subtract 5 -> back to 128)
        cnt_d <= '1';
        wait for clk_period * 5;
        cnt_d <= '0';
        wait for 200 ns;

        -- long press UP (to test the auto-repeat logic)
        -- Make sure DELAY_500MS is set to small value (e.g. 50) in bright_control.vhd for this to work in sim
        cnt_u <= '1';
        wait for clk_period * 200; 
        cnt_u <= '0';
        wait for 500 ns;

        -- both buttons pressed (should do nothing based on your logic)
        cnt_u <= '1';
        cnt_d <= '1';
        wait for clk_period * 50;
        cnt_u <= '0';
        cnt_d <= '0';
        
        report "Simulation completed!";
        wait;
    end process;

end Behavioral;