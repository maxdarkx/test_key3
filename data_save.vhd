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
		rst:			in 	std_logic;
		data_in: 	in	 	std_logic_vector(4 downto 0);	--bits de entrada directos del teclado numerico
		button:   	in 	std_logic;						--los bits de entrada estan listos para ser leidos
		data_out1: 	out  	std_logic_vector(59 downto 0);				--el array de salida 
		data_out2: 	out  	std_logic_vector(59 downto 0);				--el array de salida 
		ready_out:	out	std_logic_vector(3 downto 0);
		op_out:		out	std_logic_vector(4 downto 0)
	);
end data_save;


architecture behavioral of data_save is
		signal num0,num1,num2,num3,num4,num5,num6,num7,num8,num9,num10,num11,num12,num13: std_logic_vector(4 downto 0):="00000";
		signal num14, num15,num16,num17,num18,num19,num20,num21,num22,num23,num24,num25,num26: std_logic_vector(4 downto 0):="00000";
		signal punto : std_logic:='0';
		signal punto2: std_logic:='0';
		signal count : integer :=0;  --Contador que aumenta para la parte entera el numero 1
		signal count1: integer:=0;	--Contador que aumenta para la parte decimal numero 1
		signal count2: integer :=0;	--Contador que aumenta para la parte entera numero 2
		signal count3: integer :=0;	--Contador que aumenta para la parte decimal numero 2
		signal signo : std_logic_vector(4 downto 0);
		signal clk2: std_logic:='0';
		
begin

--reloj: process(clk)
--variable contador:integer range 0 to 29999:=0;
--begin
--	if rising_edge(clk) then
--		if contador=29999 then
--			contador:=0;
--			clk2<=not(clk2);
--		else
--			contador:=contador+1;
--		end if;
--	end if;
--end process;





corrimiento1 : process(CLK,data_in, punto, count1, count2 ) 
	begin  
 	 
  if (CLK'event and CLK = '1') then		--Menos
  		if (button = '1' and data_in /= "11011" and punto ='0' and count1 = 0 and count = 0) then
			signo<="00000";
			count <= count +1;
		elsif (button = '1' and data_in = "11011" and punto ='0'  and count1 = 0 and count = 0) then
			signo<=data_in;
			count <= count +1;
		elsif (button = '1' and count1 = 0 and punto = '1' and data_in = "01111" and count2 = 0 and count = 0) then
			num1 <= "10001";
			count1 <= count1 + 1;
		elsif (button = '1' and (data_in = "11010" or data_in = "11011" or data_in = "11100" or data_in = "11101" )) then
			num0 <= data_in;
			count2 <= count2 + 1;
		elsif (button = '1' and data_in /= "11011" and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in/= "11101" and  punto = '0' and count1 = 0 and count2 = 0)then
			num1 <= data_in;
			num2 <= num1;
			num3 <= num2;
			num4 <= num3;
			num5 <= num4;
			num6 <= num5;
			num7 <= num6;
			num8 <= num7;
			count <= count+1; 
													                              --Punto  						
		elsif (button = '1' and count1 = 0 and punto = '1'  and data_in = "01111" and count2 = 0 and count /= 0)then
			count1 <= count1 + 1;	--aca va el punto en el display, agregarlo										      --SUMA                Resta                  --Por                 --Entre
		elsif (button = '1' and count1 = 1 and punto = '1' and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101" and count2 = 0) then
			num9 <= data_in;
			count1 <= count1 + 1;
		elsif (button = '1' and count1 = 2 and punto = '1'  and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101" and count2 = 0) then
			num10 <= data_in;
			count1 <= count1 + 1;
		elsif (button = '1' and count1 = 3 and punto = '1' and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101" and count2 = 0) then
			num11 <= data_in;
			count1 <= count1 + 1;
		elsif (button = '1' and count1 = 4 and punto = '1' and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101" and count2 = 0) then
			num12 <= data_in;
			count1 <= count1 + 1;
		elsif (button = '1' and data_in /= "11011" and data_in /= "01111" and punto2='0' and count3 = 0) then
			num13 <= data_in;
			num14 <= num13;
			num15 <= num14;
			num16 <= num15;
			num17 <= num16;
			num18 <= num17; 
			num19 <= num18;
			num20 <= num19;
			count2 <= count2 + 1;	  
		elsif (button = '1' and count3 = 0 and punto = '1' and count2 /=0 and data_in = "01111" ) then
			count3 <= count3 + 1; --aca va el punto en el display, agregarlo
		elsif (button = '1' and count3 = 1 and  data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101") then
			num21 <= data_in;
			count3 <= count3 + 1;
		elsif (button = '1' and count3 = 2 and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101" ) then
			num22 <= data_in;
			count3 <= count3 + 1;
		elsif (button = '1' and count3 = 3 and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101" ) then
			num23 <= data_in;
			count3 <= count3 + 1;
		elsif (button = '1' and count3 = 4 and data_in /= "11010" and data_in /= "11011" and data_in /= "11100" and data_in /= "11101" ) then
			num24 <= data_in;
			count3 <= count3 + 1;
		end if;
  end if;
  
  data_out1<= num1  & num2  & num3  & num4  & num5  & num6  & num7  & num8  & num9  & num10 & num11 & num12;
  data_out2<= num13 & num14 & num15 & num16 & num17 & num18 & num19 & num20 & num21 & num22 & num23 & num24;
end process;


process(CLK2) 
	begin  
  if (CLK2'event and CLK2 = '1') then
		if (data_in = "01111") then       
			punto <= '1';
		elsif (count1 /= 0) then
			punto <= '1';
		elsif(count3 /= 0)then
			punto2 <= '1';
		else 
			punto <= '0';
			punto2 <= '0';
	  end if;
  end if;
end process;		

	
--	signal num1,num2,num3,num4,num5,num6,num7,num8,num9,num10,num11,num12,num13: std_logic_vector(3 downto 0):="0000";
--	signal num21,num22,num23,num24,num25,num26,num27,num28,num29,num210,num211,num212,num213: std_logic_vector(3 downto 0):="0000";
--	signal con: integer range 0 to 8:=0;
--	signal con_pun: integer range 0 to 4:=0;
--	signal con2: integer range 0 to 8:=0;
--	signal con2_pun: integer range 0 to 4:=0;
--	signal punto: std_logic:='0';
--	signal punto2: std_logic:='0';
--	signal op: std_logic:='0';
--	signal op_save: std_logic_vector(4 downto 0):="00000";
--begin
--
--	clock: process(clk)
--	begin
--	if (rising_edge(clk)) then
--		if (rst = '1') then
--			p_state <= s0;
--		else
--			p_state <= f_state;
--		end if;
--	end if;
--	end process;
--
--	state_advance: process(p_state,con,con2,punto,punto2,con_pun,con2_pun,data_in,op)
--	begin
--		case p_state is
--			when s1=>
--				if punto='1' or con>7 then
--					f_state<=s2;
--				elsif op='1' then
--					f_state<=s3;
--				else
--					f_state<=s1;
--				end if;			
--			when s2=>
--				if data_in(4)='1' then
--					f_state<=s3;
--				else
--					f_state<=s2;
--				end if;
--			when s3=>
--				if punto2='1' or con2>7 then
--					f_state<=s4;
--				else
--					f_state<=s3;
--				end if;
--			when s4=>
--				if data_in(4)='1' then
--					f_state<=s0;
--				else
--					f_state<=s4;
--				end if;
--			when s0=>
--				f_state<=s1;
--			when others=>
--				f_state<=s0;
--			end case;
--	
--	end process;
--
--	datasave: process(p_state,data_in,ready_in)
--	begin
--		case p_state is
--			when s0=>
--				num1 <= "0000";
--				num2 <= "0000";
--				num3 <= "0000";
--				num4 <= "0000";
--				num5 <= "0000";
--				num6 <= "0000";
--				num7 <= "0000";
--				num8 <= "0000";
--				num9 <= "0000";
--				num10 <= "0000";
--				num11 <= "0000";
--				num12 <= "0000";
--				num13 <= "0000";
--				
--				num21 <= "0000";
--				num22 <= "0000";
--				num23 <= "0000";
--				num24 <= "0000";
--				num25 <= "0000";
--				num26 <= "0000";
--				num27 <= "0000";
--				num28 <= "0000";
--				num29 <= "0000";
--				num210 <= "0000";
--				num211 <= "0000";
--				num212 <= "0000";
--				num213 <= "0000";
--				op<='0';
--				punto<='0';
--				punto2<='0';
--				con<=0;
--				con2<=0;
--				con_pun<=0;
--				con2_pun<=0;
--				ready_out<="0001";
--			when s1=>
--				if(ready_in='1') then
--					if(data_in(4)='0') then
--						if (data_in="01111") then		--detector de puntos
--							num9<="1111";
--							punto<='1';
--						else
--						  num1 <= data_in(3 downto 0); --si no hay puntos guardo el dato como esta
--						  num2 <= num1;
--						  num3 <= num2;
--						  num4 <= num3;
--						  num5 <= num4;
--						  num6 <= num5;
--						  num7 <= num6;
--						  num8 <= num7;
--						  con <= con+1;
--						  con<=con+1;
--						end if;
--					else
--						op_save<=data_in;
--					end if;
--				end if;
--				ready_out<="0010";
--			when s2=>
--				if ready_in='1' then
--					if(data_in(4)='1') then
--						op_save<=data_in;
--					else
--						if(data_in /= "01111") then
--							case con_pun is
--							when 0=>
--								num10<= data_in(3 downto 0);
--							when 1=>
--								num11<= data_in(3 downto 0);
--							when 2=>
--								num12<= data_in(3 downto 0);
--							when others=>
--								num13<= data_in(3 downto 0);
--							end case;
--							con_pun<=con_pun+1;
--						end if;
--					end if;
--				end if;
--				ready_out<="0011";
--			when s3=>
--				if(ready_in='1') then	--detector de "presionar una tecla"
--					if data_in(4)='0' then 	--detector de numeros
--						if data_in="01111" then		--detector de puntos
--							num29<="1111";
--							punto2<='1';
--						else
--							num21 <= data_in(3 downto 0);
--							num22 <= num21;
--							num23 <= num22;
--							num24 <= num23;
--							num25 <= num24;
--							num26 <= num25;
--							num27 <= num26;
--							num28 <= num27;
--							con2 <= con2 + 1;
--						end if;
--					end if;
--				end if;
--				ready_out<="0100";
--			when s4=>
--				if ready_in='1' and data_in/= "01111"  and data_in(4)/='1' then
--					
--					case con2_pun is
--					when 0=>
--						num210<= data_in(3 downto 0);
--					when 1=>
--						num211<= data_in(3 downto 0);
--					when 2=>
--						num212<= data_in(3 downto 0);
--					when others=>
--						num213<= data_in(3 downto 0);
--					end case;
--					con2_pun<=con2_pun+1;
--				end if;
--				ready_out<="0101";
--			when others=>
--				null;
--		end case;
--	end process;
--
--data_out1<= num13  & num12  & num11  & num10  & num9   & num1  & num2  & num3  & num4  & num5  & num6  & num7  & num8;
--data_out2<= num213 & num212 & num211 & num210 & num29 & num21 & num22 & num23 & num24 & num25 & num26 & num27 & num28;
--op_out<= op_save;

end behavioral;














--	process(CLK,ready_in,data_in,op,op_save) 
--	begin  
--		if (clk'event and clk = '1') then
--			if rst='1' then
--				num1 <= "0000";
--				num2 <= "0000";
--				num3 <= "0000";
--				num4 <= "0000";
--				num5 <= "0000";
--				num6 <= "0000";
--				num7 <= "0000";
--				num8 <= "0000";
--				num9 <= "0000";
--				num10 <= "0000";
--				num11 <= "0000";
--				num12 <= "0000";
--				num13 <= "0000";
--				
--				num21 <= "0000";
--				num22 <= "0000";
--				num23 <= "0000";
--				num24 <= "0000";
--				num25 <= "0000";
--				num26 <= "0000";
--				num27 <= "0000";
--				num28 <= "0000";
--				num29 <= "0000";
--				num210 <= "0000";
--				num211 <= "0000";
--				num212 <= "0000";
--				op<='0';
--				punto<='0';
--				punto2<='0';
--				con<=0;
--				con2<=0;
--				con_pun<=0;
--				con2_pun<=0;
--			else
--				if ready_in='1' then
--					if data_in(4)='1' and op<='0' then
--						op<='1';
--						op_save<=data_in;
--					else
--						if data_in(4 downto 0) ="01111" and punto <='0' then
--							punto<='1';
--							num9<="1111";
--						elsif data_in(4 downto 0) ="01111" and punto2 <='0' and con2>0 then
--							punto2<='1';
--							num29<="1111";
--						else
--							if (con<= 8 and op='0' and punto='0')then
--								  num1 <= data_in(3 downto 0);
--								  num2 <= num1;
--								  num3 <= num2;
--								  num4 <= num3;
--								  num5 <= num4;
--								  num6 <= num5;
--								  num7 <= num6;
--								  num8 <= num7;
--								  con <= con+1;
--								  ready_out<="0001";
--							elsif (punto = '1' and con_pun<4)then	  
--								case con_pun is
--									when 0 =>
--										num10<= data_in(3 downto 0);
--										ready_out<="0010";
--									when 1 =>
--										num11<= data_in(3 downto 0);
--									when 2 =>
--										num12<= data_in(3 downto 0);
--									when others =>
--										num13<= data_in(3 downto 0);
--								end case;
--								con_pun<=con_pun+1;
--
--							elsif(op = '1' and con2<8) then
--								  num21 <= data_in(3 downto 0);
--								  num22 <= num21;
--								  num23 <= num22;
--								  num24 <= num23;
--								  num25 <= num24;
--								  num26 <= num25;
--								  num27 <= num26;
--								  num28 <= num27;
--								  con2 <= con2 + 1;
--								  ready_out<="0011";
--							elsif(punto2='1' and con2_pun<4) then
--								case con2_pun is
--									when 0 =>
--										num210<= data_in(3 downto 0);
--										ready_out<="0100";
--									when 1 =>
--										num211<= data_in(3 downto 0);
--									when 2 =>
--										num212<= data_in(3 downto 0);
--									when others =>
--										num213<= data_in(3 downto 0);
--								end case;
--								con2_pun<=con2_pun+1;
--							else
--								null;
--							end if;
--						end if;
--					end if;
--				end if;
--			end if;
--		end if;
--	end process;
