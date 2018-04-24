----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:45:56 04/23/2018 
-- Design Name: 
-- Module Name:    data_save - Behavioral 
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

entity data_save is
	port(
		clk:			in    std_logic;						--reloj de entrada, agregar un divisor de reloj
		data_in: 	in	 	std_logic_vector(4 downto 0);	--bits de entrada directos del teclado numerico
		ready_in: 	in 	std_logic;						--los bits de entrada estan listos para ser leidos
		data_out1: 	out  	std_logic_vector(51 downto 0);				--el array de salida 
		data_out1: 	out  	std_logic_vector(51 downto 0);				--el array de salida 
		ready_out:	out	std_logic_vector(3 downto 0);
		op_out:		out	std_logic_vector(3 downto 0)
	);
end data_save;
signal num1,num2,num3,num4,num5,num6,num7,num8,num9,num10,num11,num12: std_logic_vector(3 downto 0);
signal num21,num22,num23,num24,num25,num26,num27,num28,num29,num210,num211,num212: std_logic_vector(3 downto 0);
signal con: integer range 0 to 8:=0;
signal con_pun: integer range 0 to 4:=0;
signal con2: integer range 0 to 8:=0;
signal con2_pun: integer range 0 to 4:=0;

signal punto: std_logic:='0';
signal punto2: std_logic:='0';
signal op: std_logic:='0';
architecture Behavioral of data_save is
begin


	process(CLK) 
	begin  
		if (clk'event and clk = '1') then
			if ready_in='1' then
				if data_in(4)=1 and op<='0' then
					op<='1';
					op_save<=data_in;
				else
					if data_in(4 downto 0) ="01111" and punto <='0' then
						punto<='1';
						num9<="01111";
					elsif data_in(4 downto 0) ="01111" and punto2 <='0' and con2>0 then
						punto2<='1';
						num29<="01111";
					else
						if (con<= 8 and op='0' and punto='0')then
							  num1 <= data_in;
							  num2 <= num1;
							  num3 <= num2;
							  num4 <= num3;
							  num5 <= num4;
							  num6 <= num5;
							  num7 <= num6;
							  num8 <= num7;
							  con <= con+1;
						elsif (punto = '1' and con_pun<4)then	  
							case con_pun is
								when 0 =>
									num10<= data_in;
								when 1 =>
									num11<= data_in;
								when 2 =>
									num12<= data_in;
								when 3 =>
									num13<= data_in;
							end case;
							con_pun<=con_pun+1;

						elsif(op = '1' and con2<8) then
							  num21 <= data_in;
							  num22 <= num21;
							  num23 <= num22;
							  num24 <= num23;
							  num25 <= num24;
							  num26 <= num25;
							  num27 <= num26;
							  num28 <= num27;
							  con2 <= con2 + 1;
						elsif(punto2='1' and con2_pun<4)
							case con2_pun is
								when 0 =>
									num210<= data_in;
								when 1 =>
									num211<= data_in;
								when 2 =>
									num212<= data_in;
								when 3 =>
									num213<= data_in;
							end case;
							con2_pun<=con2_pun+1;
						else
							null;
						end if;
					end if;
				end if;
  			end if;
  		end if;
	end process;

data_out1<= num8 & num7 & num6 & num5 &num4 & num3 &num2 & num1 &num9 & num10 &num11 & num12 & op_save;
data_out2<= num28 & num27 & num26 & num25 &num24 & num23 &num22 & num21 &num29 & num210 &num211 & num212;
op_out<= op_save;

end Behavioral;