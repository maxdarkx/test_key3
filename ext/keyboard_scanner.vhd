---------------------------------------------------
-- Demostration of a FSM for commanding a 16-key keypad scanner and decoder   
-- A Synchronous Moore FSM 
-- Original seed file: from ED Course 07-08-Q1
-- http://epsc.upc.edu/projectes/ed/grups_classe/07-08-q1/1BT4/EX/EX7/clock_control_unit_FSM_VHDL_precision.vhd
---------------------------------------------------

LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.NUMERIC_STD.ALL;

-- Only for ispLEVER and SYNPLIFY: if attributes must be placed (as in choosing coding styles for FSM)
--		LIBRARY Synplify;
--		USE Synplify.attributes.ALL;

	ENTITY Keyboard_16_keys_scanner IS  
		PORT(
		--> Inputs to the state register
			CLK, CD			:	IN  std_logic;			
		--> Inputs to the CS1 
			Columns 		: 	IN  std_logic_vector (3 downto 0);

		--> Outputs from the CS2
			Data			:	OUT std_logic_vector (3 downto 0);
			GS				:	OUT std_logic;
			Rows			:	OUT std_logic_vector (3 downto 0)
		
          );
   END Keyboard_16_keys_scanner;

	ARCHITECTURE FSM_structure_design OF Keyboard_16_keys_scanner IS  
   							 -- state signals declaration 
		TYPE State_type IS (RowA, RowB, RowC, RowD, 
							RowA_Colum_dec, RowB_Colum_dec, RowC_Colum_dec,RowD_Colum_dec); 

		SIGNAL present_state, future_state : State_type ; 
		SIGNAL REN : std_logic;

-- If you want to choose the coding style 
-- Only for ispLEVER and SYNPLIFY: For selecting the code: "sequential, gray, oneshot,
--  ATTRIBUTE syn_encoding OF present_state : signal is "sequential";

--Only for ispLEVER and PRECISION: For selecting the code: "binary, onehot, twohot, gray, auto, random
--		ATTRIBUTE FSM_STATE : STRING;
--		ATTRIBUTE FSM_STATE OF State_type : TYPE IS "BINARY";

	BEGIN  
   -----------------------------------------------------------
   -- State register, normally simple D-type flip-flops  
   -----------------------------------------------------------

-- Generating a very convenient signal Row_Enable (REN)
-- When activating any row, if no key is pressed, REN = '1' 

REN <= '1' WHEN Columns = "1111" ELSE '0';	
--	REN <= Columns(0) AND Columns(1) AND Columns(2) AND Columns(3);

state_register: PROCESS (CD,CLK)
	BEGIN
		IF (CD = '1') THEN 			-- reset counter
			present_state <= RowA; 
		ELSIF (CLK'EVENT and CLK = '1') THEN	-- Synchronous register (D-type flip-flop)
			present_state <= future_state; 
		END IF;
END PROCESS state_register;

   ------------------------------------------------------------   
   -- CS1: combinational logic for determining the future state 
   -- Using a process, state variables and the "case" sentence
   ------------------------------------------------------------   
CS1: PROCESS (present_state,REN)
	BEGIN
		CASE present_state IS
       		WHEN RowA =>
				IF (REN = '0') THEN
					future_state  <= RowA_Colum_dec;  -- a key has been pressed and must be decoded
				ELSE
					future_state  <= RowB; -- next row scan 
				END IF ;

       		WHEN RowB =>
				IF (REN = '0') THEN
					future_state  <= RowB_Colum_dec;  -- a key has been pressed and must be decoded
				ELSE
					future_state  <= RowC; -- next row scan 
				END IF ;
               
       		WHEN RowC =>
				IF (REN = '0') THEN
					future_state  <= RowC_Colum_dec;  -- a key has been pressed and must be decoded
				ELSE
					future_state  <= RowD; -- next row scan 
				END IF ;

       		WHEN RowD =>
				IF (REN = '0') THEN
					future_state  <= RowD_Colum_dec;  -- a key has been pressed and must be decoded
				ELSE
					future_state  <= RowA; -- next row scan, an infinite loop 
				END IF ;

					-- states for decoding columns
       		WHEN RowA_Colum_dec =>
				IF (REN = '0') THEN
					future_state  <= RowA_Colum_dec;  -- looped here while pressing the key
				ELSE
					future_state  <= RowB; -- next row scan because the key is released
				END IF ;	
											
       		WHEN RowB_Colum_dec =>
				IF (REN = '0') THEN
					future_state  <= RowB_Colum_dec;  -- looped here while pressing the key
				ELSE
					future_state  <= RowC; -- next row scan because the key is released
				END IF ;	

       		WHEN RowC_Colum_dec =>
				IF (REN = '0') THEN
					future_state  <= RowC_Colum_dec;  -- looped here while pressing the key
				ELSE
					future_state  <= RowD; -- next row scan because the key is released
				END IF ;	

       		WHEN RowD_Colum_dec =>
				IF (REN = '0') THEN
					future_state  <= RowD_Colum_dec;  -- looped here while pressing the key
				ELSE
					future_state  <= RowA; -- next row scan because the key is released
				END IF ;					
 		END CASE;
END PROCESS CS1;
   
   ---------------------------------------------------------------
   -- CS2: combinational logic to determine the outputs  
   ---------------------------------------------------------------

CS2: PROCESS (present_state,REN, Columns)
	BEGIN
		CASE present_state IS
       		WHEN RowA =>
				Rows	<= 	"0111";
				Data <= "0000";
				
      		WHEN RowA_Colum_dec =>
				Rows	<= 	"0111";	
				Data <= "0000";
				if 		(Columns = "0111") then 
							Data <= "0001";  -- key 1
				elsif 	(Columns = "1011") then 
							Data <= "0010";  -- key 2
				elsif 	(Columns = "1101") then 
							Data <= "0011";  -- key 3							
				elsif 	(Columns = "1110") then 
							Data <= "1010";  -- key A	
				end if;
									
      		WHEN RowB =>
				Rows	<= 	"1011";
				Data <= "0000";

      		WHEN RowB_Colum_dec =>
				Rows	<= 	"1011";	
				Data <= "0000";				
				if 		(Columns = "0111") then 
							Data <= "0100";  -- key 4
				elsif 	(Columns = "1011") then 
							Data <= "0101";  -- key 5
				elsif 	(Columns = "1101") then 
							Data <= "0110";  -- key 6							
				elsif 	(Columns = "1110") then 
							Data <= "1011";  -- key B	
				end if;				

       		WHEN RowC =>
				Rows	<= 	"1101";
				Data <= "0000";

      		WHEN RowC_Colum_dec =>
				Rows	<= 	"1101";	
				Data <= "0000";
				if 		(Columns = "0111") then 
							Data <= "0111";  -- key 7
				elsif 	(Columns = "1011") then 
							Data <= "1000";  -- key 8
				elsif 	(Columns = "1101") then 
							Data <= "1001";  -- key 9							
				elsif 	(Columns = "1110") then 
							Data <= "1100";  -- key C	
				end if;	
								
      		WHEN RowD =>
				Rows	<= 	"1110";	
				Data <= "0000";		
      		WHEN RowD_Colum_dec =>
				Rows	<= 	"1110";	
				Data <= "0000";
				if 		(Columns = "0111") then 
							Data <= "1111";  -- key F
				elsif 	(Columns = "1011") then 
							Data <= "0000";  -- key 0
				elsif 	(Columns = "1101") then 
							Data <= "1110";  -- key E							
				elsif 	(Columns = "1110") then 
							Data <= "1101";  -- key D	
				end if;									
 		END CASE;

 END PROCESS CS2;	
		
	GS <= REN;   -- active low DISPLAY1_DP; it has to be:  NOT (REN);
		


END FSM_structure_design ;