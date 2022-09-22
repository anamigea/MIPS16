
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    port (
        opcode : in std_logic_vector (2 downto 0);
        RegDst : out std_logic;
        ExtOp : out std_logic;
        ALUSrc : out std_logic;
        Branch : out std_logic;
        Jump : out std_logic;
        ALUOp : out std_logic_vector(2 downto 0);
        MemWrite : out std_logic;
        MemtoReg : out std_logic;
        RegWrite : out std_logic
);
end control_unit;

architecture Behavioral of control_unit is

begin
    process(opcode)
    begin
        case(opcode) is
                   --r-type
            when "000" => RegDst <= '1';
                            ExtOp <= '0';
                            ALUSrc <= '0';
                            Branch <= '0';
                            Jump <= '0';
                            ALUOp <= "000"; --funct
                            MemWrite <= '0';
                            MemtoReg <= '0';
                            RegWrite <= '1';
                    --addi        
            when "001" => RegDst <= '0';
                            ExtOp <= '1';
                            ALUSrc <= '1';
                            Branch <= '0';
                            Jump <= '0';
                            ALUOp <= "001";
                            MemWrite <= '0';
                            MemtoReg <= '0';
                            RegWrite <= '1';
                   --lw
            when "010" =>RegDst <= '0';
                            ExtOp <= '1';
                            ALUSrc <= '1';
                            Branch <= '0';
                            Jump <= '0';
                            ALUOp <= "001";   --addition
                            MemWrite <= '0';
                            MemtoReg <= '1';
                            RegWrite <= '1';
                    --sw
            when "011" => RegDst <= '0';
                            ExtOp <= '1';
                            ALUSrc <= '1';
                            Branch <= '0';
                            Jump <= '0';
                            ALUOp <= "001";  --addition
                            MemWrite <= '1';
                            MemtoReg <= '0';
                            RegWrite <= '0';
                    --beq        
            when "100" => RegDst <= '0';
                            ExtOp <= '1';
                            ALUSrc <= '0';
                            Branch <= '1';
                            Jump <= '0';
                            ALUOp <= "010"; --subtraction
                            MemWrite <= '0';
                            MemtoReg <= '0';
                            RegWrite <= '0';
                   --ori
            when "101" => RegDst <= '0';
                            ExtOp <= '0';
                            ALUSrc <= '1';
                            Branch <= '0';
                            Jump <= '0';
                            ALUOp <= "011"; --or
                            MemWrite <= '0';
                            MemtoReg <= '0';
                            RegWrite <= '1';
                    -- xori       
            when "110" => RegDst <= '0';
                            ExtOp <= '0';
                            ALUSrc <= '1';
                            Branch <= '0';
                            Jump <= '0';
                            ALUOp <= "100";
                            MemWrite <= '0';
                            MemtoReg <= '0';
                            RegWrite <= '1';
                   --jump
            when others => RegDst <= '0';
                            ExtOp <= '0';
                            ALUSrc <= '0';
                            Branch <= '0';
                            Jump <= '1';
                            ALUOp <= "000"; --nu conteaza ALUOp aici
                            MemWrite <= '0';
                            MemtoReg <= '0';
                            RegWrite <= '0';
        end case;
    end process;

end Behavioral;
