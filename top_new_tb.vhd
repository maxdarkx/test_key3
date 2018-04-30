--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:35:12 04/29/2018
-- Design Name:   
-- Module Name:   C:/Users/Juan Carlos/Desktop/ise/test_key3/top_new_tb.vhd
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_new_tb IS
END top_new_tb;
 
ARCHITECTURE behavior OF top_new_tb IS 
 
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
         rgb : OUT  std_logic_vector(7 downto 0)
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
   signal rgb : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
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
          hcount1 => hcount1,
          vcount1 => vcount1,
          rgb => rgb
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
