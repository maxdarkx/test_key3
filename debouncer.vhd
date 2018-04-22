--codigo para el debouncing de teclados fisicos
-- la salida y pasa a BAJO(=0) cuando se obtienen 3 ceros consecutivos a la entrada x
---------------------------------------------------  

LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.NUMERIC_STD.ALL;


entity debouncer is  
	port(
		clk:	in  std_logic;	--entrada del reloj
		rst:	in  std_logic;
		x: 		in  std_logic;
		y:		out std_logic	
	  );
end debouncer;

architecture design of debouncer is  
	type State_type is (s0, s1, s2, s3); 
	signal p_state, f_state : State_type ; 

begin

--logica secuencial para la maquina de estados
state_register: process (rst,clk)
	begin
		if (rst = '1') then
			p_state <= s0; 
		elsif (clk'event and clk = '1') then
			p_state <= f_state; 
		end if;
	end process;

--logica combinacional para el proximo estado
process (p_state, x)
begin
	case p_state is
			when s0 =>
			if (x = '0') then
				f_state  <= s1;  --primer cero
			else
				f_state  <= s0;
			end if;

			when s1 =>
			if (x = '0') then
				f_state  <= s2;  --segundo cero
			else
				f_state  <= s0;
			end if;
			
			when s2=>
			if (x = '0') then
				f_state  <= s3;  --tercer cero
			else
				f_state  <= s0;
			END if ;
			
			when s3 =>
			if (x = '0') then
				f_state  <= s3;  --ultimo cero, pero se sigue leyendo hasta soltar la tecla
			else
				f_state  <= s0; -- ir al inicio de la maquina
			END if ;
		end case;
end process;

y<= '0' when p_state = s3 else '1'; 		
end design;