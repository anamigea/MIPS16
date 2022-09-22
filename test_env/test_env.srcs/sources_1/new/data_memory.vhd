----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2022 02:20:38 PM
-- Design Name: 
-- Module Name: data_memory - Behavioral
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

entity data_memory is
    Port ( 
        clk : in std_logic;
        MemWrite : in std_logic; --MemWrite signal should be validated with an output of the MPG component
        ALUResAddr : in std_logic_vector(15 downto 0);
        RD2_WriteData : in std_logic_vector(15 downto 0);
        MemData : out std_logic_vector(15 downto 0); --used only for load word instructions
        ALUResData : out std_logic_vector(15 downto 0)
    );
end data_memory;

architecture Behavioral of data_memory is

    type ram_type is array (0 to 255) of std_logic_vector (15 downto 0);
    signal RAM: ram_type:=(X"0004", X"0004", X"000C", X"0024", X"00E4", X"0014", X"0002", X"0070" , others=>X"0000");
    
begin

    process (clk)
    begin
        if clk'event and clk = '1' then
            if MemWrite = '1' then
                RAM(conv_integer(ALUResAddr)) <= RD2_WriteData;
            end if;
        end if;
    end process;
    
    MemData <= RAM( conv_integer(ALUResAddr));
    ALUResData <= ALUResAddr;

end Behavioral;
