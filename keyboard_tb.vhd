--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:15:30 04/29/2018
-- Design Name:   
-- Module Name:   C:/Users/Juan Carlos/Desktop/ise/test_key3/keyboard_tb.vhd
-- Project Name:  test_key3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: new_driver
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
 
ENTITY keyboard_tb IS
END keyboard_tb;
 
ARCHITECTURE behavior OF keyboard_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT new_driver
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         col1 : IN  std_logic;
         col2 : IN  std_logic;
         col3 : IN  std_logic;
         col4 : IN  std_logic;
         row_out0 : OUT  std_logic;
         row_out1 : OUT  std_logic;
         row_out2 : OUT  std_logic;
         row_out3 : OUT  std_logic;
         salida : OUT  std_logic_vector(4 downto 0);
         ready_in : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal col1 : std_logic := '0';
   signal col2 : std_logic := '0';
   signal col3 : std_logic := '0';
   signal col4 : std_logic := '0';

 	--Outputs
   signal row_out0 : std_logic;
   signal row_out1 : std_logic;
   signal row_out2 : std_logic;
   signal row_out3 : std_logic;
   signal salida : std_logic_vector(4 downto 0);
   signal ready_in : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	signal col:	std_logic_vector(3 downto 0):= "0000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: new_driver PORT MAP (
          clk => clk,
          rst => rst,
          col1 => col1,
          col2 => col2,
          col3 => col3,
          col4 => col4,
          row_out0 => row_out0,
          row_out1 => row_out1,
          row_out2 => row_out2,
          row_out3 => row_out3,
          salida => salida,
          ready_in => ready_in
        );
	col1<=col(0);
	col2<=col(1);
	col3<=col(2);
	col4<=col(3);
	
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
		
      wait for 100 ms;	
		col<="0100";
      wait for 50 ms;	
		col<="0000";
      -- insert stimulus here 

      wait;
   end process;

END;
