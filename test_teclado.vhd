--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:00:52 04/17/2018
-- Design Name:   
-- Module Name:   /home/juan/ALU avance2/test_teclado.vhd
-- Project Name:  test_key2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: driver_teclado_completo
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_teclado IS
END test_teclado;
 
ARCHITECTURE behavior OF test_teclado IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT driver_teclado_completo
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         filas : OUT  std_logic_vector(3 downto 0);
         columnas : IN  std_logic_vector(3 downto 0);
         salida : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal columnas : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal filas : std_logic_vector(3 downto 0);
   signal salida : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: driver_teclado_completo PORT MAP (
          clk => clk,
          rst => rst,
          filas => filas,
          columnas => columnas,
          salida => salida
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
   
	wait for 200ms;
	columnas <= "0010";
	wait for 40 ms;
	columnas <="0000";

      -- insert stimulus here 

      wait;
   end process;

END;
