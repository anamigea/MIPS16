----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2022 11:01:21 PM
-- Design Name: 
-- Module Name: mono_pulse_gen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mono_pulse_gen is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end mono_pulse_gen;

architecture Behavioral of mono_pulse_gen is

    signal s_counter : std_logic_vector(15 downto 0) := B"0000_0000_0000_0000"; -- binary number representation
    signal s_q1      : std_logic                     := '0';
    signal s_q2      : std_logic                     := '0';
    signal s_q3      : std_logic                     := '0';


begin

    counter : process(clk)
    begin
        if rising_edge(clk) then
            s_counter <= s_counter + 1;
        end if;
    end process;                        -- counter

    first_reg : process(clk)
    begin
        if rising_edge(clk) then
            if s_counter = X"FFFF" then -- hexadecimal number representation
                s_q1 <= btn;
            end if;
        end if;
    end process;                        -- first_reg

    second_reg : process(clk)
    begin
        if rising_edge(clk) then
            if s_q1 = '1' then
                s_q2 <= '1';
            else
                s_q2 <= '0';
            end if;
        end if;
    end process;                        -- second_reg

    third_reg : process(clk)
    begin
        if rising_edge(clk) then
            if s_q2 = '1' then
                s_q3 <= '1';
            else
                s_q3 <= '0';
            end if;
        end if;
    end process;                        -- third_reg

    enable <= s_q2 and not s_q3;        -- AND gate at the end


end Behavioral;
