library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clk_en_dyn_saturation is
end tb_clk_en_dyn_saturation;

architecture behavior of tb_clk_en_dyn_saturation is

    component clk_en_dyn
    Port ( 
        cnt_u : in  STD_LOGIC;
        cnt_d : in  STD_LOGIC;
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        ce    : out STD_LOGIC
    );
    end component;

    signal cnt_u : std_logic := '0';
    signal cnt_d : std_logic := '0';
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal ce    : std_logic;

    constant clk_period : time := 10 ns;

begin

    uut: clk_en_dyn PORT MAP (
        cnt_u => cnt_u,
        cnt_d => cnt_d,
        clk   => clk,
        rst   => rst,
        ce    => ce
    );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        for i in 1 to 7 loop
            wait until rising_edge(clk);
            cnt_u <= '1';
            wait until rising_edge(clk);
            cnt_u <= '0';

            wait for 100 ns; 
        end loop;

        wait for 200 ns;

        wait until rising_edge(clk);
        cnt_d <= '1';
        wait until rising_edge(clk);
        cnt_d <= '0';

        wait for 200 ns;

        report "Test complete" severity failure;
        wait;
    end process;

end behavior;