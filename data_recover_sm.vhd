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
		data_out1: 	out std_logic_vector(51 downto 0);				--el array de salida 
		data_out2: 	out std_logic_vector(51 downto 0);				--el array de salida 
		ready_out: 	out std_logic_vector(3 downto 0) 						--el array de salida esta listo para ser leido
	);
end data_recover_sm;

architecture machine of data_recover_sm is 
	type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29,s210,s211,s212);		--cantidad de estados
	signal p_state, f_state: state_type:=s0;			--estado presente, estado futuro
	signal clk_500hz: std_logic;
	signal counter: integer:=0;
	signal point: std_logic:='0';	--indicador de punto
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
				if data_in(4)='0'then
					if data_in = "01010" and point1 = '0' then
						f_state<=s2;
					else 
						f_state<=s1;
					end if;
				else
					f_state<=s20;
				end if;
			end if;
			
		when s2 =>
			if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s3;
					else 
						f_state<=s2;
					end if;
				else
					f_state<=s20;
			end if;
		when s3 =>
			if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s4;
					else 
						f_state<=s3;
					end if;
				else
					f_state<=s20;
			end if;
		when s4 =>
			if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s5;
					else 
						f_state<=s4;
					end if;
				else
					f_state<=s20;
			end if;
		when s5 =>
			if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s6;
					else 
						f_state<=s7;
					end if;
				else
					f_state<=s20;
			end if;
		when s6 =>
				if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s7;
					else 
						f_state<=s6;
					end if;
				else
					f_state<=s20;
			end if;

		when s7 =>
				if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s8;
					else 
						f_state<=s7;
					end if;
				else
					f_state<=s20;
			end if;

		when s8 =>
				if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s9;
					else 
						f_state<=s8;
					end if;
				else
					f_state<=s20;
			end if;

		when s9 =>
				if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s10;
					else 
						f_state<=s9;
					end if;
				else
					f_state<=s20;
			end if;

		when s10 =>
				if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s11;
					else 
						f_state<=s10;
					end if;
				else
					f_state<=s20;
			end if;

		when s11 =>
			if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s12;
					else 
						f_state<=s11;
					end if;
				else
					f_state<=s20;
			end if;
		when s12 =>
			if (ready_in='1') then
					if data_in = "01010" and point1 = '0' then
						f_state<=s13;
					else 
						f_state<=s12;
					end if;
				else
					f_state<=s20;
			end if;
		when s13 =>
			if (ready_in='1') then
				if data_in(4)='1'then
					f_state<=s20;
				end if;
			end if;
		
		when s20 =>									--por ahora solo se recogen cuatro digitos, y falta ingresar los codigos por operacion
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s21;
				else
					f_state<=s20;
				end if;
			end if;
			
		when s21 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s22;
				else
					f_state<=s21;
				end if;
			end if;
		when s22 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s23;
				else
					f_state<=s22;
				end if;
			end if;
		when s23 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s24;
				else
					f_state<=s23;
				end if;
			end if;
		when s24 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s25;
				else
					f_state<=s24;
				end if;
			end if;

		when s25 =>
			if ready_in='1' and  data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s26;
				else
					f_state<=s25;
				end if;
			end if;
		when s26 =>
			if (ready_in='1' and  data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s27;
				else
					f_state<=s26;
				end if;
			end if;
		when s27 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s28;
				else
					f_state<=s27;
				end if;
			end if;
		when s28 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s29;
				else
					f_state<=s28;
				end if;
			end if;
		when s29 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s210;
				else
					f_state<=s29;
				end if;
			end if;
		when s210 =>
			if ready_in='1' and data_in(4)='0'then
				if point2='0' and data_in="01010" then
					f_state<=s211;
				else
					f_state<=s210;
				end if;
			end if;
		when s211 =>
			if ready_in='1' and data_in(4)='0'then
					if point2='0' and data_in="01010" then
					f_state<=s212;
				else
					f_state<=s211;
				end if;
			end if;
		when s212 =>
			if ready_in='1' and  data_in(4)='1'then
					f_state<=s300;
			end if;
		when s300 =>
			if ready_in='1' and  data_in(4)='1'then
					f_state<=s0;
			end if;
		end case;



	end process;

	save_data: process(p_state,data_in)	--maquina de estados, guardado de datos
	begin
		variable point: std_logic:='0';

		case p_state is
			when s0 =>
				for i in 0 to 51 loop
					data_out1(i)<='0';	
					data_out2(i)<='0'
				end loop;

				ready_out<="0001";

			when s1 =>
				if data_in = "01010" then
					if point1='0' then
						point1<='1';
						data_out1(3 downto 0)<=data_in;
					end if;
				else
					data_out1(3 downto 0)<=data_in;
				end if;
				ready_out<="0010";
			when s2 =>
				data_out1(7 downto 4)<=data_in;
				ready_out<="0011";
			when s3 =>
				data_out1(11 downto 8)<=data_in;
				ready_out<="0100";
			when s4 =>
				data_out1(15 downto 12)<=data_in;
				ready_out<="0101";
			when s5 =>
				data_out1(19 downto 16)<=data_in;
				ready_out<="0110";
			when s6 =>
				data_out1(23 downto 20)<=data_in;
				ready_out<="0111";
			when s7 =>
				data_out1(27 downto 24)<=data_in;
				ready_out<="1000";
			when s8 =>
				data_out1(31 downto 28)<=data_in;
				ready_out<="1001";
			when s9 =>
				data_out1(35 downto 32)<=data_in;
				ready_out<="1010";
			when s10 =>
				data_out1(39 downto 36)<=data_in;
				ready_out<="0110";
			when s11 =>
				data_out1(43 downto 40)<=data_in;
				ready_out<="0111";
			when s12 =>
				data_out1(47 downto 44)<=data_in;
				ready_out<="1000";

			when s20 =>
				data_out(3 downto 0)<=data_in;
				ready_out<="0010";
			when s21 =>
				data_out(7 downto 4)<=data_in;
				ready_out<="0011";
			when s3 =>
				data_out(11 downto 8)<=data_in;
				ready_out<="0100";
			when s4 =>
				data_out(15 downto 12)<=data_in;
				ready_out<="0101";
			when s5 =>
				data_out(19 downto 16)<=data_in;
				ready_out<="0110";
			when s6 =>
				data_out(23 downto 20)<=data_in;
				ready_out<="0111";
			when s7 =>
				data_out(27 downto 24)<=data_in;
				ready_out<="1000";
			when s8 =>
				data_out(31 downto 28)<=data_in;
				ready_out<="1001";
			when s9 =>
				data_out(35 downto 32)<=data_in;
				ready_out<="1010";
			when s10 =>
				data_out(39 downto 36)<=data_in;
				ready_out<="0110";
			when s11 =>
				data_out(43 downto 40)<=data_in;
				ready_out<="0111";
			when s12 =>
				data_out(47 downto 44)<=data_in;
				ready_out<="1000";
		end case;
	end process;


end architecture;