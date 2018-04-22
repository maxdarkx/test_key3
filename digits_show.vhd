----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:34 04/18/2018 
-- Design Name: 
-- Module Name:    digits_show - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.array_machine.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity digits_show is
generic (
		dl: integer:=50 ;
		dh: integer:=100;
		lw: integer:=5
	);
port(	
		number: 	 	 in  logic_array;
		hcount:      in  std_logic_vector(10 downto 0);
	   vcount:      in  std_logic_vector(10 downto 0);
		posx: 		 out integer;
		posy:		 	 out integer;
		value:		 out std_logic_vector(4 downto 0)
	);




end digits_show;

architecture Behavioral of digits_show is
	--constant dl:  integer := 50; 	--largo del caracter
	--constant dh:  integer := 100; 	--altura del caracter
	--constant lw:  integer := 5; 	--ancho de las lineas
	constant esh: integer := 10; 	--espacio entre caracterers

	constant th: integer := 640;
	constant tv: integer := 480;

	constant CC1 : integer := 4; 	-- cantidad de letras para primera fila (4) 
	constant CC2 : integer := 4; 	-- cantidad de letras para primera fila (4) 
	
	
	constant RESET_DATA: std_logic_vector(7 downto 0):=(others=>'0');

begin

print: process(hcount,vcount)
	variable esl : integer := dl+lw; --espacio entre palabras

	variable EVU : integer; -- espacio vertical utilizado
	variable EHU1: integer; -- Espacio horizontal total utilizado fila 1 
	variable EHU2: integer; -- Espacio horizontal total utilizado fila 2
	variable px1,px10,px11,px12,px13,px14,px15,px16,px17,px18,px19,px101: integer:=0;
	variable px111,px112,px113,px114,px115,px116,px117,px118,px119:	integer:=0;
	
	variable px2,px20,px21,px22,px23,px24,px25,px26,px27,px28,px29,px201: integer:=0;
	variable px211,px212,px213,px214,px215,px216,px217,px218,px219: integer:=0;
	
	variable py1,py2,py3: integer;
	
begin
	--centrado vertical y horizontalmente
	EVU:= 2*(dh+esh);
	EHU1:= cc1*(dl+esh) ;
	EHU2:= cc1*(dl+esh) ;
	px1 := (th-ehu1)/2 ;
	px2 := (th-ehu2)/2;

	py1 := (tv - EVU)/2;
	py2:=py1+dh+esl;											   
	py3:=py1+2*dh+esl;
	

	--simbolos para primer dato
	px10:= px1;
	px11:= px1 + dl + esh;
	px12:= px1 + 2*(dl + esh);
	px13:= px1 + 3*(dl + esh);
	--px14:= px1 + 4*(dl + esh);
	--px15:= px1 + 5*(dl + esh);
	--px16:= px1 + 6*(dl + esh);
	--px17:= px1 + 7*(dl + esh);
	--px18:= px1 + 8*(dl + esh);
	--px19:= px1 + 9*(dl + esh);
	--px110:= px1 + 10*(dl + esh);
	--px112:= px1 + 11*(dl + esh);
	--px113:= px1 + 12*(dl + esh);
	--px114:= px1 + 13*(dl + esh);
	--px115:= px1 + 14*(dl + esh);
	--px116:= px1 + 15*(dl + esh);
	--px117:= px1 + 16*(dl + esh);
	--px118:= px1 + 17*(dl + esh);
	--px119:= px1 + 18*(dl + esh);
	px101:= px1 + 4*(dl + esh);

	--simbolos para segundo dato
	--px20:= px2;
	--px21:= px2 + dl + esh;
	--px22:= px2 + 2*(dl + esh);
	--px23:= px2 + 3*(dl + esh);
	--px24:= px2 + 4*(dl + esh);
	--px25:= px2 + 5*(dl + esh);
	--px26:= px2 + 6*(dl + esh);
	--px27:= px2 + 7*(dl + esh);
	--px28:= px2 + 8*(dl + esh);
	--px29:= px2 + 9*(dl + esh);
	--px210:= px2 + 10*(dl + esh);
	--px212:= px2 + 11*(dl + esh);
	--px213:= px2 + 12*(dl + esh);
	--px214:= px2 + 13*(dl + esh);
	--px215:= px2 + 14*(dl + esh);
	--px216:= px2 + 15*(dl + esh);
	--px217:= px2 + 16*(dl + esh);
	--px218:= px2 + 17*(dl + esh);
	--px219:= px2 + 18*(dl + esh);
	--px201:= px2 + 19*(dl + esh);


	if (vcount > py1) and (vcount <py2) then
		posy<=py1;

		if hcount>px10 and hcount<px11 then
			posx<=px10;
			value(0)<=number(0,0);
			value(1)<=number(0,1);
			value(2)<=number(0,2);
			value(3)<=number(0,3);
			value(4)<=number(0,4);
		elsif hcount>px11 and hcount<px12 then
			posx<=px11;
			value(0)<=number(1,0);
			value(1)<=number(1,1);
			value(2)<=number(1,2);
			value(3)<=number(1,3);
			value(4)<=number(1,4);
		elsif hcount>px12 and hcount<px13 then
			posx<=px12;
			value(0)<=number(2,0);
			value(1)<=number(2,1);
			value(2)<=number(2,2);
			value(3)<=number(2,3);
			value(4)<=number(2,4);
		elsif hcount>px13 and hcount<px101 then
			posx<=px13;
			value(0)<=number(3,0);
			value(1)<=number(3,1);
			value(2)<=number(3,2);
			value(3)<=number(3,3);
			value(4)<=number(3,4);
	--	elsif hcount>px14 and hcount<px15 then
	--		posx<=px14;
	--		value<=data15;
	--	elsif hcount>px15 and hcount<px16 then
	--		posx<=px15;
	--		value<=data16;
	--	elsif hcount>px16 and hcount<px17 then
	--		posx<=px16;
	--		value<=data17;
	--	elsif hcount>px17 and hcount<px18 then
	--		posx<=px17;
	--		value<=data18;
	--	elsif hcount>px18 and hcount<px19 then
	--		posx<=px18;
	--		value<=data19;
	--	elsif hcount>px19 and hcount<px110 then
	--		posx<=px19;
	--		value<=data110;
	--	elsif hcount>px110 and hcount<px111 then
	--		posx<=px110;
	--		value<=data111;
	--	elsif hcount>px111 and hcount<px112 then
	--		posx<=px111;
	--		value<=data112;
	--	elsif hcount>px112 and hcount<px113 then
	--		posx<=px112;
	--		value<=data113;
	--	elsif hcount>px113 and hcount<px114 then
	--		posx<=px113;
	--		value<=data114;
	--	elsif hcount>px114 and hcount<px115 then
	--		posx<=px114;
	--		value<=data115;
	--	elsif hcount>px115 and hcount<px116 then
	--		posx<=px115;
	--		value<=data116;
	--	elsif hcount>px116 and hcount<px117 then
	--		posx<=px116;
	--		value<=data117;
	--	elsif hcount>px117 and hcount<px118 then
	--		posx<=px117;
	--		value<=data118;
	--	elsif hcount>px118 and hcount<px119 then
	--		posx<=px118;
	--		value<=data119;
	--	elsif hcount>px119 and hcount<px101 then
	--		posx<=px119;
	--		value<=data120;
	--	end if;



	--elsif vcount > py2 and vcount <py3 then
	--	posy<=py2;
		
	--	if hcount>px20 and hcount<px21 then
	--		posx<=px20;
	--		value<=data21;
	--	elsif hcount>px21 and hcount<px22 then
	--		posx<=px21;
	--		value<=data22;
	--	elsif hcount>px22 and hcount<px23 then
	--		posx<=px22;
	--		value<=data23;
	--	elsif hcount>px23 and hcount<px24 then
	--		posx<=px23;
	--		value<=data24;
	--	elsif hcount>px24 and hcount<px25 then
	--		posx<=px24;
	--		value<=data25;
	--	elsif hcount>px25 and hcount<px26 then
	--		posx<=px25;
	--		value<=data26;
	--	elsif hcount>px26 and hcount<px27 then
	--		posx<=px26;
	--		value<=data27;
	--	elsif hcount>px27 and hcount<px28 then
	--		posx<=px27;
	--		value<=data28;
	--	elsif hcount>px28 and hcount<px29 then
	--		posx<=px28;
	--		value<=data29;
	--	elsif hcount>px29 and hcount<px210 then
	--		posx<=px29;
	--		value<=data210;
	--	elsif hcount>px210 and hcount<px211 then
	--		posx<=px210;
	--		value<=data211;
	--	elsif hcount>px211 and hcount<px212 then
	--		posx<=px211;
	--		value<=data212;
	--	elsif hcount>px212 and hcount<px213 then
	--		posx<=px212;
	--		value<=data213;
	--	elsif hcount>px213 and hcount<px214 then
	--		posx<=px213;
	--		value<=data214;
	--	elsif hcount>px214 and hcount<px215 then
	--		posx<=px214;
	--		value<=data215;
	--	elsif hcount>px215 and hcount<px216 then
	--		posx<=px215;
	--		value<=data216;
	--	elsif hcount>px216 and hcount<px217 then
	--		posx<=px216;
	--		value<=data217;
	--	elsif hcount>px217 and hcount<px218 then
	--		posx<=px217;
	--		value<=data218;
	--	elsif hcount>px218 and hcount<px219 then
	--		posx<=px218;
	--		value<=data219;
	--	elsif hcount>px219 and hcount<px201 then
	--		posx<=px219;
	--		value<=data220;
		
	 end if;
	end if;
end process;





end Behavioral;

