--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:33:52 04/29/2018
-- Design Name:   
-- Module Name:   C:/Users/Juan Carlos/Desktop/ise/test_key3/full_test.vhd
-- Project Name:  test_key3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY full_test IS
END full_test;
 
ARCHITECTURE behavior OF full_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT test_top
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         row_out0 : OUT  std_logic;
         row_out1 : OUT  std_logic;
         row_out2 : OUT  std_logic;
         row_out3 : OUT  std_logic;
         column_in0 : IN  std_logic;
         column_in1 : IN  std_logic;
         column_in2 : IN  std_logic;
         column_in3 : IN  std_logic;
         led : OUT  std_logic_vector(7 downto 0);
         hs : OUT  std_logic;
         vs : OUT  std_logic;
         hcount1 : OUT  std_logic_vector(10 downto 0);
         vcount1 : OUT  std_logic_vector(10 downto 0);
         rgb : OUT  std_logic_vector(7 downto 0);
			frame_take: out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal column_in0 : std_logic := '0';
   signal column_in1 : std_logic := '0';
   signal column_in2 : std_logic := '0';
   signal column_in3 : std_logic := '0';

 	--Outputs
   signal row_out0 : std_logic;
   signal row_out1 : std_logic;
   signal row_out2 : std_logic;
   signal row_out3 : std_logic;
   signal led : std_logic_vector(7 downto 0);
   signal hs : std_logic;
   signal vs : std_logic;
   signal hcount1 : std_logic_vector(10 downto 0);
   signal vcount1 : std_logic_vector(10 downto 0);
	signal hcount : std_logic_vector(10 downto 0);
   signal vcount : std_logic_vector(10 downto 0);
   signal rgb : std_logic_vector(7 downto 0);
	signal col: std_logic_vector(3 downto 0):="0000";
	signal row: std_logic_vector(3 downto 0):="0001";
   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant frame_max: integer:=1000;
	signal frame_count: integer:=0;
	signal frame_look: integer:=0;
	type states is (s0,s1,s2);
	signal p_state,f_state :states:=s0;
	signal frame_signal: std_logic:= '0';
 
BEGIN
	frame_look<=2;
	-- Instantiate the Unit Under Test (UUT)
   uut: test_top PORT MAP (
          clk => clk,
          rst => rst,
          row_out0 => row_out0,
          row_out1 => row_out1,
          row_out2 => row_out2,
          row_out3 => row_out3,
          column_in0 => column_in0,
          column_in1 => column_in1,
          column_in2 => column_in2,
          column_in3 => column_in3,
          led => led,
          hs => hs,
          vs => vs,
          hcount1 => hcount,
          vcount1 => vcount,
          rgb => rgb,
			 frame_take=> frame_signal
        );

	column_in0<=col(0);
	column_in1<=col(1);
	column_in2<=col(2);
	column_in3<=col(3);
	
	row(0)<=row_out0;
	row(1)<=row_out1;
	row(2)<=row_out2;
	row(3)<=row_out3;


   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ms;	
		col<="0100";
      wait for 70 ms;
		col<="0000";
		wait for 20 ms;	
		col<="1000";
      wait for 70 ms;
		col<="0000";
		wait for 20 ms;	
		col<="1000";
      wait for 70 ms;
		col<="0000";
		wait for 20 ms;	
		col<="0001";
      wait for 70 ms;
		col<="0000";
      -- insert stimulus here 

      --wait;
   end process;

next_state: process(clk)
begin
	if rising_edge(clk) then
		p_state<=f_state;
	end if;
end process;

future_state:process(hcount,vcount,frame_count,p_state)
begin
	case p_state is
		when s0=>	--inicializacion
		 if frame_count=frame_look then
			f_state<=s1;
		 end if;
		when s1=>
			if frame_count>frame_look then
				f_state<=s2;
			else
				f_state<=s1;
			end if;
		when s2=>
			f_state<=s0;
		end case;
end process;

frame_process: process(hcount,vcount,frame_signal)
begin
	if hcount=640 and vcount=480 then
		frame_count<=frame_count+1;
	end if;
	
--	if frame_signal='1' then
--		frame_look<=frame_count;
--	end if;
	
end process;

capa1r: process(p_state,hcount)
    file solucion: text;
	 --file my_input : TEXT open READ_MODE is "file_io.in";
	 file solucion1: text;
	 variable texto1: line;
	 variable texto2: line;
	 variable temp1: std_logic_vector (3 downto 0):="0000";
	 variable c: std_logic:='0';
begin
	
	
	case p_state is
					
		when s0=>	--inicializacion

			if frame_count=0 and c='0'then
				texto1:=null;
				texto2:=null;
				file_open(solucion,"resultado1.m", write_mode);
				file_open( solucion1, "resultado.m", write_mode);
				write(texto1,string'("r=zeros(640,480);"));
				write(texto1,string'("r=["));
				writeline(solucion,texto1);
				
				write (texto2, string'("clear all;"));
				write (texto2, string'("close all;"));
				write (texto2, string'("clc;"));
				

				--write (texto1, string'("run('resultados3.m');"));
				--write (texto1, string'("run('resultados2.m');"));
				write (texto2, string'("run('resultado1.m');"));
				write (texto2, string'("imagen=uint8(r.*16);"));
				write (texto2, string'("imshow(imagen);"));
				write (texto2, string'("impixelinfo();"));
				writeline (solucion1, texto2);
				
				
				c:='1';
			end if;
		when s1=> --encuentro el frame a mostrar y estoy entre v640 y h480
			if frame_count=frame_look then
				if vcount<480 then
					if hcount<640 then
						temp1:= rgb(2) & rgb(1) & rgb(0);
						write (texto1, conv_integer(temp1));
						write (texto1, string'(" "));			
					elsif hcount=640 and vcount<479 then
						write (texto1, ";");
					else
						null;
					end if;
					--writeline(solucion,texto1);
				elsif vcount=480 and hcount=640 then
					write (texto1, "];");
					writeline(solucion,texto1);
				end if;
				c:='0';
				
			end if;
			
			
		when s2=> --por fuera de v640 y h480
			if vcount=0 and hcount=0 and c='0'then
				--write (texto1, "]");
				--file_open(solucion, "resultado1.m", write_mode);
				file_close(solucion1);
				file_close(solucion);
			end if;
		end case;

end process;
END;
