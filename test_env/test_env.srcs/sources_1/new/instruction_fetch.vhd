
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_fetch is
    Port ( clk : in STD_LOGIC;
           branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           jumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PCOut : out STD_LOGIC_VECTOR (15 downto 0));
end instruction_fetch;

architecture Behavioral of instruction_fetch is

    signal mux1b : std_logic_vector(15 downto 0) :=(others=>'0');
    signal mux2j : std_logic_vector(15 downto 0) :=(others=>'0');
    signal PC : std_logic_vector(15 downto 0) :=(others=>'0');
    signal PC1 : std_logic_vector(15 downto 0) :=(others=>'0');
    
    component rom is
        Port ( addr : in STD_LOGIC_VECTOR (15 downto 0);
            data : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                PC<=X"0000";
            else 
                if en='1' then
                    PC<=mux2j;
                end if;
            end if;
        end if;
    end process;
    
    PC1<=PC+1;
    PCOut<=PC1;

    mux1b <= PC1 when PCSrc='0' else branchAddr;

    mux2j <= mux1b when Jump='0' else jumpAddr;
    
    rom_inst: rom
    port map(
            addr => PC,
            data=>instruction
        ); 

end Behavioral;
