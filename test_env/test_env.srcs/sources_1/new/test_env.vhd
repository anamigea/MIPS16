library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

    component ssd is
        Port ( clk : in STD_LOGIC;
            an : out STD_LOGIC_VECTOR (3 downto 0);
            cat : out STD_LOGIC_VECTOR (6 downto 0);
             digit : in STD_LOGIC_VECTOR (15 downto 0));
    end component;

    component instruction_fetch is
    Port ( clk : in STD_LOGIC;
           branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           jumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PCOut : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    component instruction_decode is
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
    end component;
    
    component control_unit is
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
    end component;
    
    component mono_pulse_gen
        Port(clk    : in  STD_LOGIC;
             btn    : in  STD_LOGIC;
             enable : out STD_LOGIC);
    end component;
    
    component instruction_execute is
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
    end component;
    
    component data_memory is
    Port ( 
        clk : in std_logic;
        MemWrite : in std_logic; --MemWrite signal should be validated with an output of the MPG component
        ALUResAddr : in std_logic_vector(15 downto 0);
        RD2_WriteData : in std_logic_vector(15 downto 0);
        MemData : out std_logic_vector(15 downto 0); --used only for load word instructions
        ALUResData : out std_logic_vector(15 downto 0)
    );
    end component;
    
    signal instruction : std_logic_vector(15 downto 0) :=(others=>'0');
    signal PCOut : std_logic_vector(15 downto 0) :=(others=>'0');
    signal s_enable : std_logic :='0';
    signal s_enable_reset : std_logic :='0';
    signal RegDst, RegWrite, RegWrite_enable, ExtOp, sa, Branch, Jump, MemWrite, MemWrite_enable, MemtoReg, ALUSrc : std_logic;
    signal RD1, RD2, Ext_Imm, ALURes, BranchAddress, chosen_output, MemData, jumpAddr, muxmem : std_logic_vector(15 downto 0) :=(others=>'0');
    signal funct, ALUOp : std_logic_vector(2 downto 0);
    signal Zero, BranchS : std_logic:='0';
begin
    
    instruction_fetch_ins: instruction_fetch
    port map(
            clk => clk,
            branchAddr => BranchAddress,
            jumpAddr => jumpAddr,
            PCSrc => BranchS,
            Jump => Jump,
            en => s_enable,
            rst => s_enable_reset,
            instruction => instruction,
            PCOut => PCOut
        ); 
        
     instruction_decode_ins: instruction_decode
     port map(
           clk => clk,
           instruction =>instruction,
           WriteData => muxmem,
           RegWrite => RegWrite_enable,
           RegDst => RegDst,
           ExtOp => ExtOp,
           RD1 => RD1,
           RD2 => RD2,
           Ext_Imm => Ext_Imm,
           sa => sa,
           funct => funct
           );   
           
     instruction_execute_ins: instruction_execute
     port map(
            RD1 => RD1,
            RD2 => RD2,
            Ext_Imm => Ext_Imm,
            PCOut => PCOut,
            funct => funct,
            sa => sa,
            ALUOp => ALUOp,
            ALUSrc => ALUSrc,
            ALURes => ALURes,
            BranchAddress => BranchAddress,
            Zero => Zero
            );
     control_unit_ins: control_unit
     port map(
        opcode => instruction(15 downto 13),
        RegDst => RegDst,
        ExtOp => ExtOp,
        ALUSrc => ALUSrc, --alu soauce
        Branch => Branch,
        Jump => Jump,
        ALUOp => ALUOp,
        MemWrite => MemWrite,
        MemtoReg => MemtoReg,
        RegWrite => RegWrite
    );
    
    data_memory_ins: data_memory
    port map(
        clk => clk,
        MemWrite => MemWrite_enable, --MemWrite signal should be validated with an output of the MPG component
        ALUResAddr => ALURes,
        RD2_WriteData => RD2,
        MemData => MemData, --used only for load word instructions
        ALUResData => ALURes
    );
        
    RegWrite_enable <= RegWrite and s_enable;
    MemWrite_enable <= MemWrite and s_enable;
    
    jumpAddr <= PCOut(15 downto 13) & instruction(12 downto 0);
    
    muxmem <= ALURes when MemtoReg = '0' else MemData ;
    
    BranchS <= Branch AND Zero;
    
    switch_process_data_path_signals: process(sw(7 downto 5),instruction,RD1,RD2,PCOut,Ext_Imm,ALURes)
    begin
        case(sw(7 downto 5)) is
            when "000" => chosen_output<=instruction; --instruction is from ROM
            when "001" => chosen_output<=PCOut;
            when "010" => chosen_output<=RD1;
            when "011" => chosen_output<=RD2;
            when "100" => chosen_output<=Ext_Imm;
            when "101" => chosen_output<=ALURes;
            when "110" => chosen_output<=MemData;
            when "111" => chosen_output<=muxmem;
            when others => chosen_output<=X"0000";
        end case;
    end process;
    
    switch_process_control_signals: process(sw(0),RegDst,ExtOp,ALUSrc, Branch, Jump,ALUOp,MemWrite, MemtoReg, RegWrite)
    begin
        if sw(0)='0' then
            led <= X"00" & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
        else
            led <= "0000000000000"  & ALUOp;
        end if;
            
    end process;
    
    ssdisplay: ssd
    port map(
        clk    => clk,
            an=>an,          
            cat=>cat,
            digit=>chosen_output 
        ); 
    
    mpg : mono_pulse_gen
        port map(
            clk    => clk,
            btn    => btn(0),         
            enable => s_enable
        );  
    mpg_reset_pc : mono_pulse_gen
        port map(
            clk    => clk,
            btn    => btn(1),         
            enable => s_enable_reset
        );

end Behavioral;