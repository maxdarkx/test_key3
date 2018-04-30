--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:38:36 04/25/2018
-- Design Name:   
-- Module Name:   C:/Users/Juan Carlos/Documents/ise/test_key3/test_top_tb.vhd
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
 
ENTITY test_top_tb IS
END test_top_tb;
 
ARCHITECTURE behavior OF test_top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT test_top
    PORT(
         clk : 		IN  std_logic;
         rst : 		IN  std_logic;
         filas : 		OUT std_logic_vector(3 downto 0);
         columnas : 	IN  std_logic_vector(3 downto 0);
         led : 		OUT std_logic_vector(7 downto 0);
         hs : 			OUT std_logic;
         vs : 			OUT std_logic;
			hcount1: 		out std_logic_vector(10 downto 0);
			vcount1: 		out std_logic_vector(10 downto 0);
         rgb : 		OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal columnas : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal filas : std_logic_vector(3 downto 0):="0000";
   signal led : std_logic_vector(7 downto 0):=(others=>'0');
   signal hs : std_logic;
   signal vs : std_logic;
   signal rgb : std_logic_vector(7 downto 0):=(others=>'0');
	signal hcount: std_logic_vector(10 downto 0):=(others=>'0');
	signal vcount: std_logic_vector(10 downto 0):=(others=>'0');
   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant frame_max: integer:=1000;
	signal frame_count: integer:=0;
	type states is (s0,s1,s2,s3);
	signal p_state,f_state :states:=s0;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: test_top PORT MAP (
          clk => clk,
          rst => rst,
          filas => filas,
          columnas => columnas,
          led => led,
          hs => open,
          vs => open,
			 hcount1=> open,
			 vcount1=> open,
          rgb => open
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ms;	
		columnas<="0100";
      wait for 70 ms;
		columnas<="0000";
		wait for 20 ms;	
		columnas<="0010";
      wait for 70 ms;
		columnas<="0000";
		wait for 20 ms;	
		columnas<="1000";
      wait for 70 ms;
		columnas<="0000";
		wait for 20 ms;	
		columnas<="0001";
      wait for 70 ms;
		columnas<="0000";
      -- insert stimulus here 

      wait;
   end process;

--next_state: process(clk)
--begin
--	if rising_edge(clk) then
--		p_state<=f_state;
--	end if;
--end process;
--
--future_state:process(hcount,vcount,frame_count,p_state)
--begin
--	case p_state is
--		when s0=>	--inicializacion
--			f_state<=s1;
--		when s1=>
--			if hcount=480 and vcount=640 then
--				f_state<=s2;
--			else
--				f_state<=s1;
--			end if;
--		when s2=>
--			if frame_count=frame_max then
--				f_state<=s3;
--			else
--				f_state<=s1;
--			end if;
--		when s3=>	--finalizacion
--			f_state<=s3;
--		end case;
--end process;
--
--
--
--capa1r: process(hcount,vcount,p_state)
--    file solucion,solucion1: text;
--	 variable texto1: line;
--	 variable temp1: std_logic_vector (3 downto 0):="0000";
--begin
--	file_close(solucion);
--	
--	case p_state is
--		when s0=>	--inicializacion
--			file_open(solucion,"resultado1.m", write_mode);
--			write(texto1,string'("r=zeros(640,480,"));
--			write(texto1,FRAME_MAX);
--			write(texto1,string'(");"));
--			write(texto1,string'("r(:,:,1)=["));
--			write(texto1,string'(""));			
--			file_close(solucion);
--			file_open(solucion,"resultado1.m", append_mode);
--		when s1=> --estoy entre v640 y h480
--			
--			if hcount<480 then
--				temp1:= rgb(2) & rgb(1) & rgb(0);
--				write (texto1, conv_integer(temp1));
--			elsif hcount=480 then
--				write (texto1, ";");
--			else
--				null;
--			end if;
--			writeline(solucion,texto1);
--			
--		when s2=> --por fuera de v640 y h480
--			frame_count<=frame_count+1;
--			write (texto1, "]");
--			writeline(solucion,texto1);
--		when s3=>--finalizacion
--			file_close(solucion);
--			
--			file_open(solucion1, "resultado.m",  append_mode);
--			write (texto1, string'("clear all;"));
--			write (texto1, string'("close all;"));
--			write (texto1, string'("clc;"));
--			writeline (solucion1, texto1);
--
--			--write (texto1, string'("run('resultados3.m');"));
--			--write (texto1, string'("run('resultados2.m');"));
--			write (texto1, string'("run('resultados1.m');"));
--			writeline (solucion1, texto1);
--
--			write (texto1, string'("for i=1:"));
--			write (texto1, FRAME_MAX);
--			writeline (solucion1, texto1);
--			write (texto1, string'("imagen(:,:,1,i)=uint8(r(:,:,i).*16);"));
--			--write (texto1, string'("imagen(:,:,2,i)=uint8(g(:,:,i).*16);"));
--			--write (texto1, string'("imagen(:,:,3,i)=uint8(b(:,:,i).*16);"));
--			write (texto1, string'("end"));
--			writeline (solucion, texto1);
--
--			write (texto1, string'("imshow(imagen(:,:,:,1));"));
--			write (texto1, string'("impixelinfo();"));
--			writeline (solucion, texto1);
--			file_close(solucion);
--			
--		end case;
--
--end process;
END;
