LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- codigo para el uso de teclados de 16 botones
-- codigo original tomado de:
-- http://epsc.upc.edu/projectes/ed/grups_classe/07-08-q1/1BT4/EX/EX7/clock_control_unit_FSM_VHDL_precision.vhd

entity matrixkeyboard is  
	port(
	clk:		in  std_logic;	--ojala 100 hz clk		
	rst: 		in  std_logic;
	col: 		in  std_logic_vector (3 downto 0);
	fil:		out std_logic_vector (3 downto 0);
	data:		out std_logic_vector (3 downto 0)
  );
 end entity matrixKeyboard;

architecture design of matrixkeyboard is
	TYPE State_t is (filaA, filaB, filaC, filaD,
		filaA_columna,filaB_columna,filaC_columna,filaD_columna); 

	signal p_state, f_state : State_t ; 
	SIGNAL pre : std_logic;
	signal clk_1khz: std_logic;
	signal counter: integer:=0;
begin
   
pre <= '1' when Col = "1111" else '0'; --senal que indica que fila se ha presionado
										--col en 1111 indica que NO se ha pulsado tecla alguna	

estado: process (rst,clk_1khz)	--process para la logica secuencial
	begin
		if (rst = '1') then
			p_state <= filaA; 
		elsif (clk_1khz'event and clk_1khz = '1') then
			p_state <= f_state; 
		end if;
end process estado;



estado_futuro: process (p_state,pre) --logica combinacional para el estado futuro
	begin
		--primero verifico en que fila se ha pulsado
		--si no ha pulsado nada se hace un loop infinito
		case p_state is
       		when filaA =>
				if (pre = '0') THEN
					f_state  <= filaA_columna;
				else
					f_state  <= filaB;
				end if;

       		WHEN filaB =>
				if (pre = '0') then
					f_state  <= filaB_columna;
				else
					f_state  <= filaC;
				end if;
               
       		when filaC =>
				if (pre = '0') then
					f_state  <= filaC_columna;
				else
					f_state  <= filaD;
				end if;

       		when filaD=>
				if (pre = '0') then
					f_state  <= filaD_columna;
				else
					f_state  <= filaA;
				end if;

			--ahora verifico en que columna se ha presionado

       		when filaA_columna =>
				if (pre = '0') then
					f_state  <= filaA_columna;
				else
					f_state  <= filaB; --se ha soltado la tecla, entonces sigo a las filas de nuevo
				end if;	
											
       		when filaB_columna =>
				if (pre = '0') then
					f_state  <= filaB_columna;
				else
					f_state  <= filaC;
				end if;	

       		when filaC_columna =>
				if (pre = '0') then
					f_state  <= filaC_columna;
				else
					f_state  <= filaD;
				end if;	

       		when filaD_columna =>
				if (pre = '0') then
					f_state  <= filaD_columna;
				else
					f_state  <= filaA;
				end if;					
 		end case;
end process;

--ahora que se que fila y que columna se ha presionado, hago la logica para 
-- determinar la salida del programa
PROCESS (p_state,pre, Col)
	BEGIN
		CASE p_state IS


       		when filaA =>
				fil	<= "0111";
				data  <= "0000";
				
      		when filaA_columna =>
				fil  <= "0111";	
				data <= "0000";
				
				if (Col = "0111") then 
					data <= "0001";  -- tecla 1
				elsif (Col = "1011") then 
					data <= "0010";  -- tecla 2
				elsif (Col = "1101") then 
					data <= "0011";  -- tecla 3
				elsif (Col = "1110") then 
					data <= "1010";  -- tecla A
				end if;
		

      		when filaB =>
				fil	 <= "1011";
				data <= "0000";

      		when filaB_columna =>
				fil	 <= "1011";	
				data <= "0000";				
				
				if (col = "0111") then --tecla 4
					data <= "0100";  
				elsif (col = "1011") then --tecla 5
					data <= "0101";  
				elsif (col = "1101") then --tecla 6
					data <= "0110";  
				elsif (col = "1110") then --tecla B
					data <= "1011";  
				end if;				


       		when filaC =>
				fil	<= 	"1101";
				data <= "0000";
      		when filaC_columna =>
				fil	<= 	"1101";	
				data <= "0000";
				if (col = "0111") then --tecla 7
					data <= "0111";  
				elsif (col = "1011") then --tecla 8
					data <= "1000";  
				elsif (col = "1101") then --tecla 9
					data <= "1001"; 
				elsif (col = "1110") then --tecla C
					data <= "1100"; 
				end if;	

								
      		when filaD =>
				fil	<= 	"1110";	
				data <= "0000";		
      		when filaD_columna =>
				fil	<= 	"1110";	
				data <= "0000";
				if (col = "0111") then --tecla F
					data <= "1111";  
				elsif (col = "1011") then --tecla 0
					data <= "0000"; 
				elsif (col = "1101") then --tecla E
					data <= "1110"; 
				elsif (col = "1110") then --tecla D
					data <= "1101"; 
				end if;									
 		end case;
 	end process;
	
	process (clk,clk_1khz,counter)
	begin  
		if (clk'event and clk = '1') then
			if counter=50000 then
				clk_1khz <= NOT clk_1khz;
			else
				counter<=counter+1;
			end if;
		end if;
	end process;
end design;
