--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:52:37 04/29/2018
-- Design Name:   
-- Module Name:   C:/Users/Juan Carlos/Documents/ise/test_key3/src/data_save_tb.vhd
-- Project Name:  test_key3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_save
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
 
ENTITY data_save_tb IS
END data_save_tb;
 
ARCHITECTURE behavior OF data_save_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_save
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         data_in : IN  std_logic_vector(4 downto 0);
         button : IN  std_logic;
         data_out1 : OUT  std_logic_vector(59 downto 0);
         data_out2 : OUT  std_logic_vector(59 downto 0);
         ready_out : OUT  std_logic_vector(3 downto 0);
         op_out : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal data_in : std_logic_vector(4 downto 0) := (others => '0');
   signal button : std_logic := '0';

 	--Outputs
   signal data_out1 : std_logic_vector(59 downto 0);
   signal data_out2 : std_logic_vector(59 downto 0);
   signal ready_out : std_logic_vector(3 downto 0);
   signal op_out : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_save PORT MAP (
          clk => clk,
          rst => rst,
          data_in => data_in,
          button => button,
          data_out1 => data_out1,
          data_out2 => data_out2,
          ready_out => ready_out,
          op_out => op_out
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
		data_in<="00001";
		wait for 10 ms;	
		data_in<="00010";
		wait for 10 ms;	
		data_in<="00011";
		wait for 10 ms;	
		data_in<="00100";
		wait for 10 ms;	
		

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
