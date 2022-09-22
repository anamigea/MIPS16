
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_decode is
    Port ( clk : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           sa : out STD_LOGIC;
           funct : out STD_LOGIC_VECTOR (2 downto 0)); 
end instruction_decode;

architecture Behavioral of instruction_decode is

    component register_file is
    port (
        clk : in std_logic;
        ra1 : in std_logic_vector (2 downto 0);
        ra2 : in std_logic_vector (2 downto 0);
        wa : in std_logic_vector (2 downto 0);
        wd : in std_logic_vector (15 downto 0);
        RegWrite : in std_logic;
        rd1 : out std_logic_vector (15 downto 0);
        rd2 : out std_logic_vector (15 downto 0)
    );
    end component;
    
    signal muxWrite : std_logic_vector(2 downto 0) :=(others=>'0');
begin

    reg_file_inst: register_file
    port map(
        clk => clk,
        ra1 => instruction(12 downto 10),
        ra2 => instruction(9 downto 7),
        wa => muxWrite,
        wd => WriteData,
        RegWrite => RegWrite,
        rd1 => RD1,
        rd2 => RD2
        );
        
    muxWrite <= instruction(9 downto 7) when RegDst='0' else instruction(6 downto 4);
    Ext_Imm <= instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6) & instruction(6 downto 0) when ExtOp='1' else "000000000" & instruction(6 downto 0);
    sa <= instruction(3);
    funct <= instruction(2 downto 0);
end Behavioral;
