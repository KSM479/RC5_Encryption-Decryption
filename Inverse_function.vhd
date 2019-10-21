
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RC5_inverse is
PORT  (
  clr: IN STD_LOGIC;  -- asynchronous reset
  clk: IN STD_LOGIC;  -- Clock signal
  dinFINAL: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
  di_vld	: IN	STD_LOGIC;  -- input is valid
  do_rdy	: OUT	STD_LOGIC;   -- output is ready
  dout: OUT STD_LOGIC_VECTOR(63 DOWNTO 0) --64-bit output
  );
end RC5_inverse;

architecture Behavioral of RC5_inverse is

  SIGNAL i_cnt: STD_LOGIC_VECTOR(3 DOWNTO 0); 
  SIGNAL a_post	: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a_subKey: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b_post	: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL b_subKey: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
  
TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 

CONSTANT skey: rom:=rom'(  x"9BBBD8C8", x"1A37F7FB", x"46F8E8C5", x"460C6085",
x"70F83B8A", x"284B8303", x"513E1454", x"F621ED22",
x"3125065D", x"11A83A5D", x"D427686B", x"713AD82D",
x"4B792F99", x"2799A4DD", x"A7901C49", x"DEDE871A",
x"36C03196", x"A7EFC249", x"61A78BB8", x"3B0A1D2B",
x"4DBFCA76", x"AE162167", x"30D76B0A", x"43192304",
x"F6CC1431", x"65046380"); 

TYPE  StateType IS (ST_IDLE,ST_POST_ROUND, ST_ROUND_OP,ST_READY);
SIGNAL  state:   StateType;

begin
b_post<=b_reg - skey(1); -- A = A + S[0]
b_subKey   <= b_reg-skey(CONV_INTEGER(i_cnt & '1'));--S[2×i+1]

WITH a_reg(4 DOWNTO 0) SELECT
   
b_rot<=b_subKey(0) & b_subKey(31 DOWNTO 1) WHEN "00001",
b_subKey(1 DOWNTO 0) & b_subKey(31 DOWNTO 2) WHEN "00010",
b_subKey(2 DOWNTO 0) & b_subKey(31 DOWNTO 3) WHEN "00011",
b_subKey(3 DOWNTO 0) & b_subKey(31 DOWNTO 4) WHEN "00100",
b_subKey(4 DOWNTO 0) & b_subKey(31 DOWNTO 5) WHEN "00101",
b_subKey(5 DOWNTO 0) & b_subKey(31 DOWNTO 6) WHEN "00110",
b_subKey(6 DOWNTO 0) & b_subKey(31 DOWNTO 7) WHEN "00111",
b_subKey(7 DOWNTO 0) & b_subKey(31 DOWNTO 8) WHEN "01000",
b_subKey(8 DOWNTO 0) & b_subKey(31 DOWNTO 9) WHEN "01001",
b_subKey(9 DOWNTO 0) & b_subKey(31 DOWNTO 10) WHEN "01010",
b_subKey(10 DOWNTO 0) & b_subKey(31 DOWNTO 11) WHEN "01011",
b_subKey(11 DOWNTO 0) & b_subKey(31 DOWNTO 12) WHEN "01100",
b_subKey(12 DOWNTO 0) & b_subKey(31 DOWNTO 13) WHEN "01101",
b_subKey(13 DOWNTO 0) & b_subKey(31 DOWNTO 14) WHEN "01110",
b_subKey(14 DOWNTO 0) & b_subKey(31 DOWNTO 15) WHEN "01111",
b_subKey(15 DOWNTO 0) & b_subKey(31 DOWNTO 16) WHEN "10000",
b_subKey(16 DOWNTO 0) & b_subKey(31 DOWNTO 17) WHEN "10001",
b_subKey(17 DOWNTO 0) & b_subKey(31 DOWNTO 18) WHEN "10010",
b_subKey(18 DOWNTO 0) & b_subKey(31 DOWNTO 19) WHEN "10011",
b_subKey(19 DOWNTO 0) & b_subKey(31 DOWNTO 20) WHEN "10100",
b_subKey(20 DOWNTO 0) & b_subKey(31 DOWNTO 21) WHEN "10101",
b_subKey(21 DOWNTO 0) & b_subKey(31 DOWNTO 22) WHEN "10110",
b_subKey(22 DOWNTO 0) & b_subKey(31 DOWNTO 23) WHEN "10111",
b_subKey(23 DOWNTO 0) & b_subKey(31 DOWNTO 24) WHEN "11000",
b_subKey(24 DOWNTO 0) & b_subKey(31 DOWNTO 25) WHEN "11001",
b_subKey(25 DOWNTO 0) & b_subKey(31 DOWNTO 26) WHEN "11010",
b_subKey(26 DOWNTO 0) & b_subKey(31 DOWNTO 27) WHEN "11011",
b_subKey(27 DOWNTO 0) & b_subKey(31 DOWNTO 28) WHEN "11100",
b_subKey(28 DOWNTO 0) & b_subKey(31 DOWNTO 29) WHEN "11101",
b_subKey(29 DOWNTO 0) & b_subKey(31 DOWNTO 30) WHEN "11110",
b_subKey(30 DOWNTO 0) & b_subKey(31) WHEN "11111",          
    b_subKey WHEN OTHERS;

b <= b_rot XOR a_reg;

a_post <= a_reg - skey(0);
a_subKey<=a_reg - skey(CONV_INTEGER(i_cnt & '0')); --S[2×i]
    
WITH b(4 DOWNTO 0) SELECT
 a_rot<=a_subKey(0) & a_subKey(31 DOWNTO 1) WHEN "00001",
     a_subKey(1 DOWNTO 0) & a_subKey(31 DOWNTO 2) WHEN "00010",
     a_subKey(2 DOWNTO 0) & a_subKey(31 DOWNTO 3) WHEN "00011",
     a_subKey(3 DOWNTO 0) & a_subKey(31 DOWNTO 4) WHEN "00100",
     a_subKey(4 DOWNTO 0) & a_subKey(31 DOWNTO 5) WHEN "00101",
     a_subKey(5 DOWNTO 0) & a_subKey(31 DOWNTO 6) WHEN "00110",
     a_subKey(6 DOWNTO 0) & a_subKey(31 DOWNTO 7) WHEN "00111",
     a_subKey(7 DOWNTO 0) & a_subKey(31 DOWNTO 8) WHEN "01000",
     a_subKey(8 DOWNTO 0) & a_subKey(31 DOWNTO 9) WHEN "01001",
     a_subKey(9 DOWNTO 0) & a_subKey(31 DOWNTO 10) WHEN "01010",
     a_subKey(10 DOWNTO 0) & a_subKey(31 DOWNTO 11) WHEN "01011",
     a_subKey(11 DOWNTO 0) & a_subKey(31 DOWNTO 12) WHEN "01100",
     a_subKey(12 DOWNTO 0) & a_subKey(31 DOWNTO 13) WHEN "01101",
     a_subKey(13 DOWNTO 0) & a_subKey(31 DOWNTO 14) WHEN "01110",
     a_subKey(14 DOWNTO 0) & a_subKey(31 DOWNTO 15) WHEN "01111",
     a_subKey(15 DOWNTO 0) & a_subKey(31 DOWNTO 16) WHEN "10000",
     a_subKey(16 DOWNTO 0) & a_subKey(31 DOWNTO 17) WHEN "10001",
     a_subKey(17 DOWNTO 0) & a_subKey(31 DOWNTO 18) WHEN "10010",
     a_subKey(18 DOWNTO 0) & a_subKey(31 DOWNTO 19) WHEN "10011",
     a_subKey(19 DOWNTO 0) & a_subKey(31 DOWNTO 20) WHEN "10100",
     a_subKey(20 DOWNTO 0) & a_subKey(31 DOWNTO 21) WHEN "10101",
     a_subKey(21 DOWNTO 0) & a_subKey(31 DOWNTO 22) WHEN "10110",
     a_subKey(22 DOWNTO 0) & a_subKey(31 DOWNTO 23) WHEN "10111",
     a_subKey(23 DOWNTO 0) & a_subKey(31 DOWNTO 24) WHEN "11000",
     a_subKey(24 DOWNTO 0) & a_subKey(31 DOWNTO 25) WHEN "11001",
     a_subKey(25 DOWNTO 0) & a_subKey(31 DOWNTO 26) WHEN "11010",
     a_subKey(26 DOWNTO 0) & a_subKey(31 DOWNTO 27) WHEN "11011",
     a_subKey(27 DOWNTO 0) & a_subKey(31 DOWNTO 28) WHEN "11100",
     a_subKey(28 DOWNTO 0) & a_subKey(31 DOWNTO 29) WHEN "11101",
     a_subKey(29 DOWNTO 0) & a_subKey(31 DOWNTO 30) WHEN "11110",
     a_subKey(30 DOWNTO 0) & a_subKey(31) WHEN "11111",             
   a_subKey WHEN OTHERS;
 
a <= a_rot XOR b;
--********************************************************* a_reg *********************************************************
PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           a_reg<=dinFINAL(63 DOWNTO 32);
        ELSIF(clk'EVENT AND clk='1') THEN
            IF(state=ST_POST_ROUND) THEN   a_reg<=a_post;
           ELSIF(state=ST_ROUND_OP) THEN   a_reg<=a;   END IF;
        END IF;
    END PROCESS;

--********************************************************* b_reg*********************************************************
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           b_reg<=dinFINAL(31 DOWNTO 0);
        ELSIF(clk'EVENT AND clk='1') THEN
           IF(state=ST_POST_ROUND) THEN   b_reg<=b_post;
          ELSIF(state=ST_ROUND_OP) THEN   b_reg<=b;   END IF;
        END IF;
    END PROCESS;   

-- *********************************************************4 bit upcounter*********************************************************
PROCESS(clr, clk)
   BEGIN
      IF(clr='0') THEN
         state<=ST_IDLE;
      ELSIF(clk'EVENT AND clk='1') THEN
         CASE state IS
            WHEN ST_IDLE=>  IF(di_vld='1') THEN state<=ST_ROUND_OP;  END IF;
            WHEN ST_ROUND_OP=>    IF(i_cnt="0001") THEN state<=ST_POST_ROUND; END IF;
            WHEN ST_POST_ROUND=>  IF(i_cnt="0001") THEN state<=ST_READY;  END IF;
            WHEN ST_READY=>   state<=ST_IDLE;
         END CASE;
      END IF;
   END PROCESS;

-- round counter
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           i_cnt<="1100";
        ELSIF(clk'EVENT AND clk='1') THEN
           IF(state=ST_POST_ROUND) THEN
              IF(i_cnt="0001") THEN   i_cnt<="1100"; END IF;
            ELSIF(state = ST_ROUND_OP AND i_cnt>1) THEN   i_cnt<=i_cnt-'1';   
           END IF;
        END IF;
    END PROCESS;   
dout<=a_reg & b_reg;

WITH state SELECT
    do_rdy<='1' WHEN ST_READY,
'0' WHEN OTHERS;


end Behavioral;