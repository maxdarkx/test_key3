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
  component test_top is
  port(
    clk:      in  std_logic;            --reloj interno fpga, mirar manual
    rst:      in  std_logic;            --boton reset
    filas:    out std_logic_vector(3 downto 0); --filas para el teclado
    columnas:   in  std_logic_vector(3 downto 0); --columnas para el teclado
    led:      out std_logic_vector(7 downto 0);
    hs:       out std_logic;            --senales para la pantalla
    vs:       out std_logic;
    rgb:      out std_logic_vector(7 downto 0)
  );
  end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal columnas : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal filas : std_logic_vector(3 downto 0);
   signal salida : std_logic_vector(4 downto 0);
	signal j: integer range 0 to 3;
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
  -- Instantiate the Unit Under Test (UUT)
  -- Clock process definitions
  clk_process: process
  begin

	 clk <= '0';
	 wait for clk_period/2;
	 clk <= '1';
	 wait for clk_period/2;
  end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
   
		wait for 45ms;

    for i in 0 to 120 loop
      if j=3 then
          j<=0;
        else
          j<=j+1;
        end if;
      if j=0 then  
        columnas <= "0010";
      else
        columnas <="0000";
      end if;
  		wait for 10ms;
    end loop; 
   end process;
  

  tst: test_top
  port map(
          clk       => clk,
          rst       => rst,
          filas     => filas,
          columnas  => columnas,
          led       => open,
          hs        => open,
          rgb       => open
  );



end behavior;
