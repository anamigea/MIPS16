
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity rom is
    Port ( addr : in STD_LOGIC_VECTOR (15 downto 0);
           data : out STD_LOGIC_VECTOR (15 downto 0));
end rom;

architecture Behavioral of rom is

type ROM_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal ROM :  ROM_type :=(X"4380", X"0496", X"2481", X"0926", X"2901", X"0DB6", X"2D82", X"9D8A" , X"9C89", X"2D81",
X"0540", X"0496", X"0510", X"0926", X"0A20", X"9D82", X"2D81", X"E00A", X"6101", others=>X"0000");

begin

    data <= ROM(conv_integer(addr));

end Behavioral;
