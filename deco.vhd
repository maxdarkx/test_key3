library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity deco is
	Port (  
			  val : in  STD_LOGIC_VECTOR (4 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0)
        );
	end deco;

architecture behavioral of deco is
begin

	with val select seg <=
					"1111110" when "00000", --0--activo alto
					"0110000" when "00001", --1
					"1101101" when "00010", --2
					"1111001" when "00011", --3
					"0110011" when "00100", --4
					"1011011" when "00101", --5
					"1011111" when "00110", --6
					"1110000" when "00111", --7
					"1111111" when "01000", --8
					"1110011" when "01001", --9
					"1110111" when "01010", --A
					"0011110" when "01011", --B
					"1001110" when "01100", --C
					"0111110" when "01101", --D
					"1001111" when "01110", --# 'E'
					"1000111" when "01111", --* 'F'
					"0000000" when "11111", -- display apagado
					"0000000" when others;
end behavioral;