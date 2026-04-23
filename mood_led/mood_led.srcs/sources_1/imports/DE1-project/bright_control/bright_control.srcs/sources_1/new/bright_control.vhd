library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bright_control is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        cnt_u    : in  STD_LOGIC; -- already debounced signal
        cnt_d    : in  STD_LOGIC;
        brt      : out STD_LOGIC_VECTOR(7 downto 0)
    );
end bright_control;

architecture Behavioral of bright_control is
    signal brt_reg      : unsigned(7 downto 0) := to_unsigned(128, 8); -- default brightness 50%
    signal cnt_u_last   : STD_LOGIC := '0';
    signal cnt_d_last   : STD_LOGIC := '0';
    signal delay        : unsigned(25 downto 0) := (others => '0');
    signal held         : STD_LOGIC := '0';
    
    -- for implementation
    constant DELAY_500MS : unsigned(25 downto 0) := to_unsigned(50_000_000, 26);
    constant DELAY_50MS : unsigned(25 downto 0) := to_unsigned(5_000_000, 26);
    -- for simulation
    --constant DELAY_500MS : unsigned(25 downto 0) := to_unsigned(50, 26);
    --constant DELAY_100MS : unsigned(25 downto 0) := to_unsigned(10, 26);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                brt_reg <= to_unsigned(128, 8);
                cnt_u_last <= '0';
                cnt_d_last <= '0';
                delay <= (others => '0');
                held <= '0';
                
            else
                -- rising edge detection (held button count after delay)
                if cnt_u = '0' and cnt_d = '0' then
                    held <= '0';
                    delay <= (others => '0');
                
                elsif (cnt_u = '1' and cnt_u_last = '0' and cnt_d = '0') then
                    if brt_reg <= 240 then
                        brt_reg <= brt_reg + 10;
                    end if;
                elsif cnt_u = '1' and cnt_u_last = '1' and cnt_d = '0' then
                    if (held = '0' and delay < DELAY_500MS) or (held = '1' and delay < DELAY_50MS) then
                        delay <= delay + 1;
                    else
                        held <= '1';
                        delay <= (others => '0');
                        if brt_reg <= 250 then
                            brt_reg <= brt_reg + 5;
                        end if;
                    end if;

                elsif (cnt_d = '1' and cnt_d_last = '0' and cnt_u = '0') then
                    if brt_reg >= 10 then
                        brt_reg <= brt_reg - 10;
                    end if;
                elsif cnt_d = '1' and cnt_d_last = '1' and cnt_u = '0' then
                    if (held = '0' and delay < DELAY_500MS) or (held = '1' and delay < DELAY_50MS) then
                        delay <= delay + 1;
                    else
                        held <= '1';
                        delay <= (others => '0');
                        if brt_reg >= 10 then
                            brt_reg <= brt_reg - 5;
                        end if;
                    end if;
                end if;
                
                -- saves state for next tick
                cnt_u_last <= cnt_u;
                cnt_d_last <= cnt_d;
            end if;
        end if;
    end process;

    brt <= std_logic_vector(brt_reg);

end Behavioral;