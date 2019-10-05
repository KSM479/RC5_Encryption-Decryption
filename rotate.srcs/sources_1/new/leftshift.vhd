library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity leftrotate is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           outx : out  STD_LOGIC_VECTOR (31 downto 0));
end leftrotate;

architecture Behavioral of leftrotate is

begin

with b(4 downto 0) select
outx <= a when "00000",
	a( 30 downto 0 ) & a(31) when "00001",
	a(29 downto 0) & a(31 downto 30) when "00010",
	a(28 downto 0) & a(31 downto 29) when "00011",
	a(27 downto 0) & a(31 downto 28) when "00100",
	a(26 downto 0) & a(31 downto 27) when "00101",
	a(25 downto 0) & a(31 downto 26) when "00110",
	a(24 downto 0) & a(31 downto 25) when "00111",
	a(23 downto 0) & a(31 downto 24) when "01000",
	a(22 downto 0) & a(31 downto 23) when "01001",
	a(21 downto 0) & a(31 downto 22) when "01010",
	a(20 downto 0) & a(31 downto 21) when "01011",
	a(19 downto 0) & a(31 downto 20) when "01100",
	a(18 downto 0) & a(31 downto 19) when "01101",
	a(17 downto 0) & a(31 downto 18) when "01110",
	a(16 downto 0) & a(31 downto 17) when "01111",
	a(15 downto 0) & a(31 downto 16) when "10000",
	a(14 downto 0) & a(31 downto 15) when "10001",
	a(13 downto 0) & a(31 downto 14) when "10010",
	a(12 downto 0) & a(31 downto 13) when "10011",
	a(11 downto 0) & a(31 downto 12) when "10100",
	a(10 downto 0) & a(31 downto 11) when "10101",
	a(9 downto 0) & a(31 downto 10) when "10110",
	a(8 downto 0) & a(31 downto 9) when "10111",
	a(7 downto 0) & a(31 downto 8) when "11000",
	a(6 downto 0) & a(31 downto 7) when "11001",
	a(5 downto 0) & a(31 downto 6) when "11010",
	a(4 downto 0) & a(31 downto 5) when "11011",
	a(3 downto 0) & a(31 downto 4) when "11100",
	a(2 downto 0) & a(31 downto 3) when "11101",
	a(1 downto 0) & a(31 downto 2) when "11110",
	a(0) & a(31 downto 1) when "11111",
	a when others;
	
end Behavioral;

