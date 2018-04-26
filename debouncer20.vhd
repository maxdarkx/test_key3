----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:08:49 04/25/2018 
-- Design Name: 
-- Module Name:    debouncer20 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity debouncer20 is
Port ( clk : in STD_LOGIC;
	    rst : in  STD_LOGIC;
	 btn_in : in STD_LOGIC;
	--btn_out : out STD_LOGIC;
  btn_out2 : out STD_LOGIC
	 );

end debouncer20;

architecture Behavioral of debouncer20 is
type state_type is (s0, s1, s2); 
signal state, next_state : state_type; 
--signal btn_outS : std_logic;
signal btn_outS2 : std_logic;

signal en: STD_LOGIC;
signal enS: STD_LOGIC;
signal cont: integer range 0 to 124999 := 0;

constant contV : integer range 0 to 124999:= 124999;

begin

--Contador
process (rst, clk) begin
  if (rst = '1') then
		cont <= 0;
  elsif rising_edge(clk) then
		if (en = '0') then
			 cont <= 0;
		else
			 cont <= cont + 1;
		end if;
  end if;
end process;

--Insert the following in the architecture after the begin keyword
SYNC_PROC: process (clk, rst)
begin
	if (clk'event and clk = '1') then
		if (rst = '1') then
			state <= s0;
			--btn_out <= '0';
			btn_out2 <= '0';
			en <= '0';
		else
			state <= next_state;
			--btn_out <= btn_outS;
			btn_out2 <= btn_outS2;
			en <= enS;
		-- assign other outputs to internal signals
		end if;        
	end if;
end process;

--MEALY State-Machine - Outputs based on state and inputs
OUTPUT_DECODE: process (state, btn_in, cont)
begin
	--insert statements to decode internal output signals
	--below is simple example
	if ((state = s0) and (btn_in = '0')) then
		enS <= '0';
		--btn_outS <= '0';
		btn_outS2 <= '0';
	elsif ((state = s0) and (btn_in = '1')) then
		enS <= '0';
		--btn_outS <= '1';
		btn_outS2 <= '1';
	elsif (state = s1) then
		enS <= '1';
		--btn_outS <= '0';
		btn_outS2 <= '1';
	elsif ((state = s2) and (cont < contV)) then
		enS <= '1';
		--btn_outS <= '0';
		btn_outS2 <= '1';
	elsif ((state = s2) and ((cont > contV) or (btn_in= '0'))) then
		enS <= '0';
		--btn_outS <= '0';
		btn_outS2 <= '1';
	else
		enS <= '0';
		--btn_outS <= '0';
		btn_outS2 <= '0';
	end if;
end process;

NEXT_STATE_DECODE: process (state, btn_in, cont)
begin
	--declare default state for next_state to avoid latches
	next_state <= state;  --default is to stay in current state
	--insert statements to decode next_state
	--below is a simple example
	case (state) is
		when s0 =>
			if btn_in = '0' then
				next_state <= s0;
			elsif btn_in = '1' then
				next_state <= s1;
			end if;
		when s1 =>
				next_state <= s2;
		when s2 =>
			if cont < contV then
				next_state <= s2;
			elsif ((cont > contV) or (btn_in = '0')) then
				next_state <= s0;
			end if;
		when others =>
			next_state <= s0;
	end case;      
end process;

end Behavioral;



