library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
library work;
use work.array_machine.all;

entity test_top is
	port(
		clk: 			in  std_logic;						--reloj interno fpga, mirar manual
		rst: 			in  std_logic;						--boton reset
	   row_out0:   out std_logic;
	   row_out1:   out std_logic;
		row_out2:   out std_logic;
	   row_out3:   out std_logic;	--filas para el teclado
		--columnas: 	in  std_logic_vector(3 downto 0);	--columnas para el teclado
		column_in0 : in  STD_LOGIC;
	  column_in1 : in  STD_LOGIC;
	  column_in2 : in  STD_LOGIC;
	  column_in3 : in  STD_LOGIC;
		led:			out std_logic_vector(7 downto 0);
		hs: 			out std_logic;						--senales para la pantalla
		vs: 			out std_logic;
		hcount1:		out std_logic_vector(10 downto 0);
		vcount1:		out std_logic_vector(10 downto 0);
		rgb:			out std_logic_vector(7 downto 0);
		frame_take: out std_logic
	);
	attribute loc: string;
	attribute loc of clk : signal is "B8"; -- Pin de reloj
	attribute loc of rst : signal is "B18"; -- Pulsador BTN0
	attribute loc of hs : signal is "T4"; -- Driver VGA
	attribute loc of vs	: signal is "U3"; -- Driver VGA
	attribute loc of row_out0: signal is "L15"; --PMOD JA para salida de datos arriba
	attribute loc of row_out1: signal is "K12"; --PMOD JA para salida de datos arriba
	attribute loc of row_out2: signal is "L17"; --PMOD JA para salida de datos arriba
	attribute loc of row_out3: signal is "M15"; --PMOD JA para salida de datos arriba
	attribute loc of column_in0: signal is "K13";
	attribute loc of column_in1: signal is "L16";
	attribute loc of column_in2: signal is "M14";
	attribute loc of column_in3: signal is "M16";
	attribute loc of rgb : signal is "R9,T8,R8,N8,P8,P6,U5,U4"; -- Driver VGA
	attribute loc of led : signal is "J14,J15,K15,K14,E17,P15,F4,R4";
end entity test_top;


architecture test_design of test_top is
	constant lw1:	integer:=5;
	constant dw1:	integer:=20;
	constant dl1:	integer:=20;

component display is
	Generic (   
		LW: 		integer:=lw1;
		DW: 		integer:=dw1;
		DL: 		integer:=dl1
    ); 
   Port(
    	HCOUNT : 	in  std_logic_vector(10 downto 0);
      VCOUNT : 	in  std_logic_vector (10 downto 0);
		PAINT :  	out std_logic;
		VALUE :  	in  std_logic_vector (4  downto 0);
		POSX:			in  integer range 0 to 480;
		POSY: 		in  integer range 0 to 640
		
    );
end component;

component deco is
	Port(  
		val:	 in   std_logic_vector (4 downto 0);
      seg: 	 out  std_logic_vector (7 downto 0)
    );
end component;

component vga_ctrl_640x480_60Hz is
	port(
	   rst: 		in  std_logic;
	   clk: 		in  std_logic; --debe ser de 25 mhz o fallara!
	   rgb_in: 	in  std_logic_vector(7 downto 0);
	   HS:      out std_logic;
	   VS:      out std_logic;
	   hcount:  out std_logic_vector(10 downto 0);
	   vcount:  out std_logic_vector(10 downto 0);
	   rgb_out: out std_logic_vector(7 downto 0);--R3R2R1R0GR3GR3GR3GR3B3B2B1B0
	   blank:   out std_logic
	);
end component;

component debouncer is
    Port (  I  : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
				O  : out  STD_LOGIC);
end component;


component new_driver is
	port(
			signal clk:	 in  std_logic;
			signal rst: 	 in  std_logic;
			signal col1: 	 in  std_logic;
			signal col2: 	 in  std_logic;
			signal col3: 	 in  std_logic;
			signal col4: 	 in  std_logic;
			signal row_out0: out std_logic;
			signal row_out1: out std_logic;
			signal row_out2: out std_logic;
			signal row_out3: out std_logic;
			signal salida:	 out std_logic_vector(4 downto 0);
			signal ready_in: out std_logic
		);
end component;

component data_save is --maquina de estados para el guardado de los datos en un array de tipo entero
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
end component;

component digits_show is
	generic (
		dl: integer:= dl1;
		dh: integer:= dw1;
		lw: integer:= lw1
	);
	port(
		number1: 	 	in  std_logic_vector(59 downto 0);
		number2: 	 	in  std_logic_vector(59 downto 0);
		number_sol: 	in  std_logic_vector(59 downto 0);
		op:				in std_logic_vector(4 downto 0);
		hcount:      	in  std_logic_vector(10 downto 0);
	   vcount:      	in  std_logic_vector(10 downto 0);
		posx: 		 	out integer range 0 to 480;
		posy:		 	 	out integer range 0 to 640;
		value:		 	out std_logic_vector(4 downto 0)
	);
end component;
-- divisor de frecuencia
component clk1khz
	port(
		I : IN std_logic;
	 rst : IN std_logic;          
		O : OUT std_logic
		);
end component;

  	signal rgb_aux: std_logic_vector(7 downto 0);
  	signal paint0: std_logic:='0';
  	signal val: std_logic_vector(4 downto 0);
	signal col :std_logic_vector(3 downto 0);
  	signal b: std_logic;

  	signal numero1, numero2, numero_sol: std_logic_vector(59 downto 0):= (others=>'0');
  	signal tposx: integer;
  	signal tposy: integer;
  	signal val1: std_logic_vector(4 downto 0);
  	signal status: std_logic_vector(3 downto 0);
	signal op: std_logic_vector(4 downto 0);
	signal hcount2: std_logic_vector(10 downto 0);
	signal vcount2: std_logic_vector(10 downto 0);

	signal temp: STD_LOGIC := '0';
	signal cont: integer range 0 to 3 := 0;
	signal fila : STD_LOGIC_VECTOR (3 downto 0);
	signal salida: STD_LOGIC_VECTOR (4 downto 0);
	signal salidateclado : STD_LOGIC_VECTOR (4 downto 0);
	signal dato : STD_LOGIC;
	signal clk2: STD_LOGIC; 
	
begin
	hcount1<=hcount2;
	vcount1<=vcount2;
	
	
Key0: debouncer PORT MAP(
	   I => column_in0 ,
	   rst => rst,
	   clk => clk,
	   O => col(0)
);
Key1: debouncer PORT MAP(
	   I => column_in1 ,
	   rst => rst,
	   clk => clk,
	   O => col(1)
);
Key2: debouncer PORT MAP(
	   I => column_in2,
	   rst => rst,
	   clk => clk,
	   O => col(2)
);
Key3: debouncer PORT MAP(
	   I => column_in3 ,
	   rst => rst,
	   clk => clk,
	   O => col(3)
);

keyboard: new_driver 
	port map(
			clk 		=> clk,
			rst 		=> rst,
			col1 		=> col(0),
			col2 		=> col(1),
			col3 		=> col(2),
			col4 		=> col(3),
			row_out0 	=> row_out0,
			row_out1 	=> row_out1,
			row_out2 	=> row_out2,
			row_out3 	=> row_out3,
			salida 		=> val,
			ready_in 	=> b
		);
frame_take<=b;
sending_data: data_save
	port map
	(
		clk				=>clk,		
		rst				=>rst,
		data_in			=>val,
		button			=>b,
		data_out1		=>numero1, 
		data_out2		=>numero2, 
		ready_out		=>status,
		op_out			=>op
	);

--numero1(4 downto 0)<=val;
--numero1(59 downto 5)<=(others=>'0');
--
--numero2(59 downto 0)<=(others=>'0');

display_data: digits_show
	port map
	(
		number1			=> numero1,
		number2			=> numero2,
		number_sol		=> numero_sol,
		op					=> op,
		hcount 			=> hcount2,
		vcount 			=> vcount2,
		posx 				=> tposx,
		posy 				=> tposy,
		value 			=> val1
	);

	
show: display
	Port map(
			HCOUNT 	=> hcount2,
         VCOUNT 	=> vcount2,
			PAINT 	=> paint0,
			VALUE 	=> val1,
			POSX	=> tposx,
			POSY	=> tposy
    );

videoOutput: vga_ctrl_640x480_60Hz
	port map(
	   rst 		=> rst,
	   clk 		=> clk,
	   rgb_in 	=> rgb_aux,
	   HS 		=> hs,
	   VS 		=> vs,
	   hcount 	=> hcount2,
	   vcount 	=> vcount2,
	   rgb_out 	=> rgb,
	   blank 	=> open 
	);


color: process(paint0)
	begin
	  if paint0='1' then
	    rgb_aux<="11111111";
	  else
	    rgb_aux<="00000000";
	  end if;
	end process; 
	
led(0)<=val(0);
led(1)<=val(1);
led(2)<=val(2);
led(3)<=val(3);
led(4)<=val(4);
led(5)<='0';
led(6)<='0';
led(7)<='0';

end architecture test_design;



------------------------proceso de rotacion del uno de fila
--secuencia: process(clk2, rst) begin
--	if (rst = '1') then
--      cont <= 0;
--   elsif (clk2'event and clk2='1') then
--		if (cont > 3) then
--         cont <= 0;
--      elsif (col = "0000") then
--         cont <= cont+1;
--      end if;
--   end if;
--	end process;
	
----flip flop que acciona una sola vez la bandera para guardar el dato
--	process (clk)
--	begin  
--   if rst = '1' then
--      dato <= '0';
--   elsif (clk'event and clk = '1') then
--      if ((col > "0000" or col < "0000") and temp = '1') then
--				dato <= '1';
--				temp <= '0';
--		elsif ((col > "0000" or col < "0000") and temp = '0') then
--			temp <= '0';
--			dato <= '0';
--		elsif (col = "0000" ) then
--			temp <= '1';
--			dato <= '0';     
--	  else
--         dato <= '0';
--		end if;
--   end if;
--   end process;
----valor de las filas
--   fila <=  "0001" when cont = 0 else
--				"0010" when cont = 1 else
--				"0100" when cont = 2 else
--				"1000" when cont = 3 else
--            x"0";
				
--	salida <= "11010" when cont = 0 and col = "0001" else
--				 "00011" when cont = 0 and col = "0010" else
--             "00010" when cont = 0 and col = "0100" else
--				 "00001" when cont = 0 and col = "1000" else
				 
--				 "11011" when cont = 1 and col = "0001" else
--				 "00110" when cont = 1 and col = "0010" else
--				 "00101" when cont = 1 and col = "0100" else
--				 "00100" when cont = 1 and col = "1000" else
				 
--				 "11100" when cont = 2 and col = "0001" else
--				 "01001" when cont = 2 and col = "0010" else
--				 "01000" when cont = 2 and col = "0100" else
--				 "00111" when cont = 2 and col = "1000" else
				 
--				 "11101" when cont = 3 and col = "0001" else
--				 "11110" when cont = 3 and col = "0010" else
--				 "00000" when cont = 3 and col = "0100" else
--				 "01111" when cont = 3 and col = "1000" else
--             "00000";
				 
				 
-- salidateclado <= salida;
-- row_out0 <= fila(0);
-- row_out1 <= fila(1);
-- row_out2 <= fila(2);
-- row_out3 <= fila(3);
 
	