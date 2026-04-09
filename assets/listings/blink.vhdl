library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blink is
    Port (
        clk : in  STD_LOGIC;
        led : out STD_LOGIC
    );
end blink;

architecture Behavioral of blink is
    signal counter : integer range 0 to 49999999 := 0;
    signal state   : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = 49999999 then
                counter <= 0;
                state   <= not state;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    led <= state;
end Behavioral;
