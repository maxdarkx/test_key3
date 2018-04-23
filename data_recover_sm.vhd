library ieee;
use ieee.std_logic_1164.all;
library work;
use work.array_machine.all;

entity data_recover_sm is --maquina de estados para el guardado de los datos en un array de tipo entero
port(
		rst:		in 	   std_logic;
		clk:		in 	   std_logic;						--reloj de entrada, agregar un divisor de reloj
		data_in: 	in 	std_logic_vector(4 downto 0);	--bits de entrada directos del teclado numerico
		ready_in: 	in 	std_logic;						--los bits de entrada estan listos para ser leidos
		data_out: 	out   logic_array;				--el array de salida 
		ready_out: 	out std_logic_vector(3 downto 0) 						--el array de salida esta listo para ser leido
	);
end data_recover_sm;

architecture machine of data_recover_sm is 
	type state_type is (s0,s1,s2,s3,s4);		--cantidad de estados
	signal p_state, f_state: state_type:=s0;			--estado presente, estado futuro
	signal clk_500hz: std_logic;
	signal counter: integer:=0;
--	signal temp: int_array (4 to 0);				--señal de salida que contiene el array entero correcto sin normalizar
begin

--clk debe ser de una velocidad deseable, ojala de periodo 0.5s
clk_div:process(clk,clk_500hz)
	begin
		if(clk'event and clk='1') then
			if counter=50000000 then
				clk_500hz<=not(clk_500hz);
				counter<=0;
			else
				counter<=counter+1;
			end if;
		end if;
	end process;






	current_state:process(clk,rst)	--maquina de estados, parte secuencial
	begin
		if (clk'event and clk='1') then
			if rst='1' then
				p_state<=s0;
			else
				p_state<=f_state;
			end if;
		end if;
	end process;

	comb_logic: process(p_state,ready_in)	--maquina de estados, logica del proximo estado
	begin											--el estado s_0 esta reservado para cuando se presione un boton punto,
		case p_state is								--boton de igualdad o boton de operacion (+,-,x,/)
		when s0 =>
			f_state<=s1;
		when s1 =>									--por ahora solo se recogen cuatro digitos, y falta ingresar los codigos por operacion
			if (ready_in='1') then
				f_state<=s2;
			end if;
		when s2 =>
			if (ready_in='1') then
				f_state<=s3;
			end if;
		when s3 =>
			if (ready_in='1') then
				f_state<=s4;
			end if;
		when s4 =>
			if (ready_in='1') then
			--	f_state<=s0;
			end if;
		end case;
	end process;

	save_data: process(p_state,data_in)	--maquina de estados, guardado de datos
	begin
		case p_state is
			when s0 =>
				for i in 0 to 3 loop
					for j in 0 to 4 loop
						data_out(i,j)<='0';	
					end loop;
				end loop;
				
				ready_out<="0001";
			when s1 =>
				data_out(0,0)<=data_in(0);
				data_out(0,1)<=data_in(1);
				data_out(0,2)<=data_in(2);
				data_out(0,3)<=data_in(3);
				data_out(0,4)<=data_in(4);
				
				ready_out<="0010";
			when s2 =>
				data_out(1,0)<=data_in(0);
				data_out(1,1)<=data_in(1);
				data_out(1,2)<=data_in(2);
				data_out(1,3)<=data_in(3);
				data_out(1,4)<=data_in(4);

				ready_out<="0011";
			when s3 =>
				data_out(2,0)<=data_in(0);
				data_out(2,1)<=data_in(1);
				data_out(2,2)<=data_in(2);
				data_out(2,3)<=data_in(3);
				data_out(2,4)<=data_in(4);
				
				ready_out<="0100";
			when s4 =>
				data_out(3,0)<=data_in(0);
				data_out(3,1)<=data_in(1);
				data_out(3,2)<=data_in(2);
				data_out(3,3)<=data_in(3);
				data_out(3,4)<=data_in(4);
				
				ready_out<="0101";
		end case;
	end process;


end architecture;