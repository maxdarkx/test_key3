----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:15:15 04/12/2018 
-- Design Name: 
-- Module Name:    frequency_divisor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments:




-- TOMADO DE https://www.codeproject.com/Tips/444385/Frequency-Divider-with-VHDL
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk1khz is
    Port ( I : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           O : out  STD_LOGIC
			);
end clk1khz;

architecture Behavioral of clk1khz is

signal contador: integer range 0 to 24999 := 0;
signal clknew: STD_LOGIC;

begin
	divisor_frequency: process(I, rst) begin
	if (rst = '1') then
		clknew <= '0';
      contador <= 0;
   elsif rising_edge(I) then
		if (contador = 24999) then
			clknew <= NOT clknew;
         contador <= 0;
      else
         contador <= contador+1;
      end if;
   end if;
	end process;
	
	O <= clknew;
	
end Behavioral;

