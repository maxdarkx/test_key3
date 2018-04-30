--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:18:19 04/25/2018
-- Design Name:   
-- Module Name:   C:/Users/Juan Carlos/Documents/ise/test_key3/keyboard_test.vhd
-- Project Name:  test_key3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Driver
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
 
ENTITY keyboard_test IS
END keyboard_test;
 
ARCHITECTURE behavior OF keyboard_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Driver
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         col_line_in : IN  std_logic_vector(3 downto 0);
         row_line_out : OUT  std_logic_vector(3 downto 0);
         out_data : OUT  std_logic_vector(4 downto 0);
         out_on : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal col_line_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal row_line_out : std_logic_vector(3 downto 0);
   signal out_data : std_logic_vector(4 downto 0);
   signal out_on : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Driver PORT MAP (
          clk => clk,
          rst => rst,
          col_line_in => col_line_in,
          row_line_out => row_line_out,
          out_data => out_data,
          out_on => out_on
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
 wait for 100 ms;	
		col_line_in<="0100";
      wait for 50 ms;
		col_line_in<="0000";
		wait for 100 ms;	
		col_line_in<="0010";
      wait for 50 ms;
		col_line_in<="0000";
		wait for 100 ms;	
		col_line_in<="1000";
      wait for 50 ms;
		col_line_in<="0000";
		wait for 100 ms;	
		col_line_in<="0001";
      wait for 50 ms;
		col_line_in<="0000";
      

      -- insert stimulus here 

      wait;
   end process;

END;
