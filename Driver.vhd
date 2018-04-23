----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Juan S. Guerrero
-- 
-- Create Date:    22:11:41 04/05/2018 
-- Design Name: 
-- Module Name:    Driver - Behavioral 
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
        use IEEE.std_logic_1164.all;
        use IEEE.std_logic_textio.all;
        use IEEE.std_logic_arith.all;
        use IEEE.numeric_bit.all;
        use IEEE.numeric_std.all;
        use IEEE.std_logic_unsigned.all;
        use IEEE.math_real.all;
        use IEEE.math_complex.all;

        library STD;
        use STD.textio;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Driver is
--entran clock y rst, la fila es una salida que siwchea y la columna es la llegada producto de presionar un boton en una fila dada
    Port (  clk:		 		in  STD_LOGIC;
            rst: 	 			in  STD_LOGIC;
            col_line_in: 		in std_logic_vector(3 downto 0);
			row_line_out: 		out std_logic_vector(3 downto 0);
			out_data : 			out std_logic_vector(4 downto 0);
			out_on:			out std_logic
		);
end Driver;
architecture Behavioral of Driver is
--4 estados, iniciamos en s4 y no lo usamos mas, para inicializar el contador a 1 para s0
signal B: std_logic := '0';
type state is (s0,s1,s2,s3,s4);
--estados
signal current_state : state:=s4;
signal next_state : state;
signal clk_500hz:std_logic:='0';
--signal out_alu : std_logic_vector(4 downto 0) --Posible error
--
signal count: std_logic_vector(3 downto 0);
signal valor : std_logic_vector(3 downto 0);
signal flag,r: std_logic:='0';
--
signal counter:integer:=0;
begin

	clk_div:process(clk,clk_500hz)
	begin
		if(clk'event and clk='1') then
			if counter=500000 then
				clk_500hz<=not(clk_500hz);
				counter<=0;
			else
				counter<=counter+1;
			end if;
		end if;
	end process;




	--logica del estado presente
		SYNC_PROC: process(clk)
		begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				current_state <= s4;
				count <= "0000";
			else
				current_state <= next_state;
			end if;
		end if;
		end process;

	--logica del estado futuro, s4 solo para inicializacion.
		NEXT_STATE_DECODE: process(current_state,col_line_in)
		begin
		
				case (current_state) is
					when s4 =>
						next_state <= s0;--ir a proximo estado y set salida
						B <= '0';
						out_data<="10000";--nothing
					when s0 =>
						
						if ( col_line_in = "0001") then
							out_data<="11101";	--D
							B<='1';
						elsif (col_line_in = "0010")then
							out_data<= "11110";--#
							B<='1';
						elsif (col_line_in ="0100") then
							out_data<= "00000";--0
							B<='1';
						elsif (col_line_in ="1000") then
							out_data<= "01111";--*
							B<='1';
						end if;
						
						if (B ='0') then		--En el caso donde no se encuentre un dato
							next_state <= s1;
						else
							if col_line_in="0000" then
								B<='0';
								next_state <=s1;
								out_data<="10000";--nothing
							else
								next_state <= s0;	--Si aqui no esta el dato se va a otro estado
							end if;
						end if;
											
				when s1 =>
					if ( col_line_in = "0001") then
						out_data<="11100";--C
						B<='1';
					elsif (col_line_in = "0010")then
						out_data<="01001";--9
						B<='1';
					elsif (col_line_in ="0100") then
						out_data<="01000";--8
						B<='1';
					elsif (col_line_in = "1000") then
						out_data<= "00111";--7
						B<='1';
					end if;
					
					if (B = '0') then	--En el caso donde no se encuentre un dato
						next_state <= s2;
					else
							if col_line_in="0000" then
								B<='0';
								next_state <=s2;
								out_data<="10000";--nothing
							else
								next_state <= s1;	--Si aqui no esta el dato se va a otro estado
							end if;
						end if;

				when s2 =>
					if ( col_line_in = "0001") then
						out_data<="11011";--B
						B<='1';
					elsif (col_line_in = "0010")then
						out_data<="00110";--6
						B<='1';
					elsif (col_line_in ="0100") then
						out_data<="00101";--5
						B<='1';
					elsif (col_line_in ="1000") then
						out_data<="00100";--4
						B<='1';
					end if;
					
					if (B='0') then	--En el caso donde no se encuentre un dato
						next_state <= s3;
					else
							if col_line_in="0000" then
								B<='0';
								next_state <= s3;
								out_data<="10000";--nothing
							else
								next_state <= s2;	--Si aqui no esta el dato se va a otro estado
							end if;
						end if;

				when s3 =>
					if ( col_line_in = "0001") then
						out_data<="11010";--A
						B<='1';
					elsif (col_line_in = "0010")then
						out_data<="00011";--3
						B<='1';
					elsif (col_line_in ="0100") then
						out_data<="00010";--2
						B<='1';
					elsif (col_line_in ="1000") then
						out_data<="00001";--1
						B<='1';
					end if;
					if (B='0') then	--En el caso donde no se encuentre un dato
						next_state <= s0;
					else
							if col_line_in="0000" then
								B<='0';
								next_state <=s0;
								out_data<="10000";--nothing
							else
								next_state <= s3;	--Si aqui no esta el dato se va a otro estado
							end if;
						end if;
			end case;
		end process NEXT_STATE_DECODE;



-- decodificacion de salidas, se rota el 1 para averiguar el dato
	OUTPUT_DECODE: process(current_state)
	begin
		case current_state is 
      	when s0  =>
      		row_line_out<="0010";

      	when s1 =>
      		row_line_out<="0100";
      	when s2 =>
      		row_line_out<="1000";
      	when s3 =>
      		row_line_out<="0001";
      	when s4 =>
      		row_line_out <= "0001";
			
		end case;
	end process OUTPUT_DECODE;


debounce_b: process(clk_500hz)
begin
	if(rising_edge(clk_500hz))then
		if(B='1' and flag='0')then
			r<='1';
			flag<='1';
		elsif(B='1' and flag='1') then
			r<='0';
		elsif(B='0') then
			flag<='0';
		end if;
	end if;
end process;

out_on<=r;

end Behavioral;

