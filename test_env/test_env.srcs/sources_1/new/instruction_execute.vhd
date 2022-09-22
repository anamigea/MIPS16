
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity instruction_execute is
    Port (
        RD1 : in std_logic_vector (15 downto 0);
        RD2 : in std_logic_vector (15 downto 0);
        Ext_Imm : in std_logic_vector (15 downto 0);
        PCOut : in std_logic_vector (15 downto 0);
        funct : in std_logic_vector (2 downto 0);
        sa : in std_logic;
        ALUOp : in std_logic_VECTOR(2 downto 0);
        ALUSrc : in std_logic;
        ALURes : out std_logic_vector(15 downto 0);
        BranchAddress : out std_logic_vector(15 downto 0);
        Zero : out std_logic
    );
end instruction_execute;

architecture Behavioral of instruction_execute is
    
    signal ALURes2 : std_logic_vector(15 downto 0) :=(others=>'0');
    signal muxOut : std_logic_vector(15 downto 0) :=(others=>'0');
    signal ALUControl : std_logic_vector(2 downto 0) :=(others=>'0');
    
begin

    process(ALUOp, funct)
    begin
        case(ALUOp) is
            when "000" => 
                case(funct) is
                    when "000" => ALUControl <= "000"; --add
                    when "001" => ALUControl <= "001"; --sub
                    when "010" => ALUControl <= "100"; --sll
                    when "011" => ALUControl <= "101"; --srl
                    when "100" => ALUControl <= "110"; --and
                    when "101" => ALUControl <= "010"; --or
                    when "110" => ALUControl <= "011"; --xor
                    when others => ALUControl <= "111"; --??
                end case;
            when "001" => ALUControl <= "000"; 
            when "010" => ALUControl <= "001"; 
            when "011" => ALUControl <= "010"; 
            when "100" => ALUControl <= "011"; 
            when "101" => ALUControl <= "111"; --??
            when "110" => ALUControl <= "111"; --??
            when others => ALUControl <= "111"; --??
        end case;
    end process;
    
    muxOut <= Ext_Imm when ALUSrc='1' else RD2;
    
    process(ALUControl,RD1,RD2,muxOut)
    begin
        case(ALUControl) is
            when "000" => ALURes2 <= RD1 + muxOut; --add
            when "001" => ALURes2 <= RD1 - muxOut; --sub
            when "010" => ALURes2 <= RD1 OR muxOut; --or
            when "011" => ALURes2 <= RD1 XOR muxOut; --xor
            when "100" => if sa='1' then
                            ALURes2 <= muxOut(14 downto 0) & "0"; --sll
                          else
                            ALURes2 <= muxOut;
                        end if;
            when "101" => if sa='1' then
                            ALURes2 <= "0" & muxOut(15 downto 1); --srl
                          else
                            ALURes2 <= muxOut;
                        end if;
            when "110" => ALURes2 <= RD1 AND muxOut;
            when others => ALURes2 <= (others => '0'); --??
        end case;
    end process;
    
    Zero <= '1' when ALURes2=X"0000" else '0';
    BranchAddress <= PCOut + Ext_Imm;
    ALURes<=ALURes2;

end Behavioral;
