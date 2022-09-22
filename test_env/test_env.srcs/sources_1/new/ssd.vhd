----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2022 02:43:14 PM
-- Design Name: 
-- Module Name: ssd - Behavioral
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

entity ssd is
    Port ( clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           digit : in STD_LOGIC_VECTOR (15 downto 0));
end ssd;

architecture Behavioral of ssd is

signal counter: std_logic_vector(15 downto 0) := B"0000_0000_0000_0000"; -- binary number representation
signal mux_output1: std_logic_vector(3 downto 0);

begin

    num : process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;  
    
    twoMUX: process(digit,counter(15 downto 14))
    begin
        case(counter(15 downto 14)) is
            when "00" => mux_output1 <=digit(3 downto 0); an<="1110";
            when "01" => mux_output1 <=digit(7 downto 4); an<="1101";
            when "10" => mux_output1 <=digit(11 downto 8); an<="1011";
            when others => mux_output1 <=digit(15 downto 12); an<="0111";
        end case;
    end process;

    process(mux_output1)
    begin
    case (mux_output1) is
        when "0001" => cat <= "1111001"; -- 1
        when "0010" => cat <= "0100100"; -- 2
        when "0011" => cat <= "0110000"; -- 3
        when "0100" => cat <= "0011001"; -- 4
        when "0101" => cat <= "0010010"; -- 5
        when "0110" => cat <= "0000010"; -- 6
        when "0111" => cat <= "1111000"; -- 7
        when "1000" => cat <= "0000000"; -- 8
        when "1001" => cat <= "0010000"; -- 9
        when "1010" => cat <= "0001000"; -- A
        when "1011" => cat <= "0000011"; -- b
        when "1100" => cat <= "1000110"; -- C
        when "1101" => cat <= "0100001"; -- d
        when "1110" => cat <= "0000110"; -- E
        when "1111" => cat <= "0001110"; -- F
        when others => cat <= "1000000"; -- 0, and other invalid values
     end case; 
    end process;

end Behavioral;
