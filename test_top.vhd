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
		filas: 		out std_logic_vector(3 downto 0);	--filas para el teclado
		columnas: 	in  std_logic_vector(3 downto 0);	--columnas para el teclado
		led:			out std_logic_vector(7 downto 0);
		hs: 			out std_logic;						--senales para la pantalla
		vs: 			out std_logic;
		hcount:		out std_logic_vector(10 downto 0);
		vcount:		out std_logic_vector(10 downto 0);
		rgb:			out std_logic_vector(7 downto 0)
	);
	attribute loc: string;
	attribute loc of clk : signal is "B8"; -- Pin de reloj
	
	attribute loc of rst : signal is "B18"; -- Pulsador BTN0
	attribute loc of hs : signal is "T4"; -- Driver VGA
	attribute loc of vs	: signal is "U3"; -- Driver VGA
	attribute loc of filas: signal is "L15,K12,L17,M15"; --PMOD JA para salida de datos arriba
	attribute loc of columnas: signal is "K13,L16,M14,M16"; --PMOD JA para entrada de datos abajo resistencias
	attribute loc of rgb : signal is "R9,T8,R8,N8,P8,P6,U5,U4"; -- Driver VGA
	attribute loc of led : signal is "J14,J15,K15,K14,E17,P15,F4,R4";
end entity test_top;

	

architecture test_design of test_top is
	constant lw1:	integer:=2;
	constant dw1:	integer:=15;
	constant dl1:	integer:=15;

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
	   rgb_in: 		in  std_logic_vector(7 downto 0);
	   HS:          out std_logic;
	   VS:          out std_logic;
	   hcount:      out std_logic_vector(10 downto 0);
	   vcount:      out std_logic_vector(10 downto 0);
	   rgb_out:     out std_logic_vector(7 downto 0);--R3R2R1R0GR3GR3GR3GR3B3B2B1B0
	   blank:       out std_logic
	);
	end component;

	component debouncer is
	Port (
		 clk : 		in  STD_LOGIC;
	    rst : 		in  STD_LOGIC;
		 x : 			in  STD_LOGIC;
		 y : 			out STD_LOGIC
	 );
	end component;



--	component debouncer is  
--	port(
--		clk:		in  std_logic;	--entrada del reloj, puede ser a gusto
--		rst:		in  std_logic;
--		x: 			in  std_logic;
--		y:			out std_logic	
--	);
--	end component;

	component Driver is
    Port (
			clk:	 			in  STD_LOGIC;
         rst: 				in  STD_LOGIC;
         col_line_in: 	in  std_logic_vector(3 downto 0);
		  	row_line_out: 	out std_logic_vector(3 downto 0);
			out_data : 		out std_logic_vector(4 downto 0);
			out_on:			out std_logic
		);
  	end component;

  	component data_save is --maquina de estados para el guardado de los datos en un array de tipo entero
	port(
		clk:			in    std_logic;						--reloj de entrada, agregar un divisor de reloj
		rst:			in 	std_logic;						--reset
		data_in: 	in	 	std_logic_vector(4 downto 0);	--bits de entrada directos del teclado numerico
		ready_in: 	in 	std_logic;						--los bits de entrada estan listos para ser leidos
		data_out1: 	out  	std_logic_vector(51 downto 0);				--el array de salida 
		data_out2: 	out  	std_logic_vector(51 downto 0);				--el array de salida 
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
		number1: 	 	in  std_logic_vector(51 downto 0);
		number2: 	 	in  std_logic_vector(51 downto 0);
		number_sol: 	in  std_logic_vector(51 downto 0);
		op:				in std_logic_vector(4 downto 0);
		hcount:      	in  std_logic_vector(10 downto 0);
	   vcount:      	in  std_logic_vector(10 downto 0);
		posx: 		 	out integer range 0 to 480;
		posy:		 	 	out integer range 0 to 640;
		value:		 	out std_logic_vector(4 downto 0)
	);
	end component;

  	signal hcount1: std_logic_vector(10 downto 0);
  	signal vcount1: std_logic_vector(10 downto 0);
  	signal rgb_aux: std_logic_vector(7 downto 0);
  	signal paint0: std_logic:='0';
  	signal val: std_logic_vector(4 downto 0);
  	signal col: std_logic_vector(3 downto 0);
  	signal b: std_logic;

  	signal numero1, numero2, numero_sol: std_logic_vector(51 downto 0);
  	signal tposx: integer;
  	signal tposy: integer;
  	signal val1: std_logic_vector(4 downto 0);
  	signal status: std_logic_vector(3 downto 0);
	signal op: std_logic_vector(4 downto 0);
	
begin
	hcount<=hcount1;
	vcount<=vcount1;
	
	key0: debouncer
	port map(
		clk 		=> clk,
		rst 		=> rst,
		x			=> columnas(0),
		y			=> col(0)
	);

	key1: debouncer
	port map(
		clk 		=> clk,
		rst 		=> rst,
		x			=> columnas(1),
		y			=> col(1)
	);

	key2: debouncer
	port map(
		clk 		=> clk,
		rst 		=> rst,
		x			=> columnas(2),
		y			=> col(2)
	);

	key3: debouncer
	port map(
		clk 		=> clk,
		rst 		=> rst,
		x			=> columnas(3),
		y			=> col(3)
	);


	keyboard: driver   
	port map(
		clk 				=> clk,
		rst 				=> rst,
		col_line_in		=> col,
		row_line_out	=> filas,
		out_data			=> val,
		out_on			=> b
	);

	sending_data: data_save
	port map
	(
		clk				=>clk,		
		rst				=>rst,
		data_in			=>val,
		ready_in			=>b,
		data_out1		=>numero1, 
		data_out2		=>numero2, 
		ready_out		=>status,
		op_out			=>op
	);

	display_data: digits_show
	port map
	(
		number1			=> numero1,
		number2			=> numero2,
		number_sol		=> numero_sol,
		op					=> op,
		hcount 			=> hcount1,
		vcount 			=> vcount1,
		posx 			=> tposx,
		posy 			=> tposy,
		value 			=> val1
	);

	
	show: display
	Port map(
			HCOUNT 	=> hcount1,
         	VCOUNT 	=> vcount1,
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
	   hcount 	=> hcount1,
	   vcount 	=> vcount1,
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
	
led(0)<=status(0);
led(1)<=status(1);
led(2)<=status(2);
led(3)<=status(3);
led(7)<=val(0);
led(6)<=val(1);
led(5)<=val(2);
led(4)<=val(3);

end architecture test_design;