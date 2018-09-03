----------------------------------------------------------------------------------
-- Company:  UBB
-- Engineer: Krzysztof Herman 
-- 
-- Create Date:    11:06:28 11/27/2017 
-- Design Name:    Address generationg machine for delay and sum beamforming. 
-- Module Name:    AddressMachine - Behavioral 
-- Project Name: 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity AddressMachine is
	-- microphone position 
	generic ( M: integer:= 1);
	-- 
	port ( clk: in std_logic;
	       ce   : in std_logic;	
		   nsamp: in  std_logic_vector(10 downto 0);
		   angle: in  std_logic_vector(5 downto 0);
		   addr:  out std_logic_vector(10 downto 0)
		   );
end AddressMachine;

architecture Behavioral of AddressMachine is

	signal addrrt: std_logic_vector(10 downto 0);
	type rom_array is array (NATURAL range <>) of integer range 0 to 43;
	constant rom: rom_array:=(  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,4,6,7,9,10,12,13,15,16,18,19,20,22,23,25,26,27,29,30,32,33,34,36,37,38,40,41,42,
								1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,3,4,6,7,9,10,11,13,14,16,17,18,20,21,22,24,25,27,28,29,31,32,33,34,36,37,38,40,41,
								3,3,3,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,3,4,6,7,8,10,11,12,14,15,16,18,19,20,22,23,24,26,27,28,30,31,32,33,35,36,37,38,39,
								4,4,4,4,4,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,0,0,0,0,1,3,4,5,7,8,9,11,12,13,15,16,17,18,20,21,22,24,25,26,27,29,30,31,32,33,35,36,37,38,
								5,5,5,5,5,5,4,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,0,0,0,1,3,4,5,6,8,9,10,11,13,14,15,17,18,19,20,21,23,24,25,26,28,29,30,31,32,33,34,36,37,
								7,7,6,6,6,6,6,5,5,5,5,4,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,0,0,1,2,4,5,6,7,9,10,11,12,13,15,16,17,18,19,21,22,23,24,25,26,28,29,30,31,32,33,34,35,
								8,8,8,7,7,7,7,6,6,6,6,5,5,5,4,4,4,4,3,3,3,3,2,2,2,1,1,1,1,0,0,1,2,4,5,6,7,8,9,11,12,13,14,15,16,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,34,
								10,9,9,9,8,8,8,7,7,7,7,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,1,1,1,0,0,1,2,3,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21,22,23,24,26,27,28,29,30,31,32,33,
								11,11,10,10,10,9,9,9,8,8,7,7,7,6,6,6,5,5,5,4,4,3,3,3,2,2,2,1,1,0,0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,
								12,12,11,11,11,10,10,10,9,9,8,8,8,7,7,6,6,6,5,5,4,4,3,3,3,2,2,1,1,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,
								14,13,13,12,12,11,11,11,10,10,9,9,8,8,7,7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,21,22,23,24,25,26,27,28,29,
								15,15,14,14,13,13,12,12,11,11,10,10,9,9,8,8,7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,19,19,20,21,22,23,24,25,26,26,27,
								16,16,15,15,14,14,13,13,12,12,11,11,10,10,9,8,8,7,7,6,6,5,5,4,3,3,2,2,1,1,0,1,2,3,4,5,5,6,7,8,9,10,11,12,13,13,14,15,16,17,18,19,19,20,21,22,23,23,24,25,26,
								18,17,17,16,16,15,14,14,13,13,12,12,11,10,10,9,9,8,7,7,6,6,5,4,4,3,2,2,1,1,0,1,2,3,3,4,5,6,7,8,9,9,10,11,12,13,13,14,15,16,17,18,18,19,20,21,21,22,23,24,24,
								19,18,18,17,17,16,15,15,14,14,13,12,12,11,10,10,9,9,8,7,7,6,5,5,4,3,3,2,1,1,0,1,2,2,3,4,5,6,6,7,8,9,10,10,11,12,13,14,14,15,16,17,17,18,19,20,20,21,22,22,23,
								20,20,19,19,18,17,17,16,15,15,14,13,13,12,11,11,10,9,8,8,7,6,6,5,4,4,3,2,1,1,0,1,2,2,3,4,5,5,6,7,8,8,9,10,11,11,12,13,13,14,15,16,16,17,18,18,19,20,20,21,22,
								22,21,20,20,19,18,18,17,16,16,15,14,13,13,12,11,11,10,9,8,8,7,6,5,5,4,3,2,2,1,0,1,1,2,3,4,4,5,6,6,7,8,8,9,10,11,11,12,13,13,14,15,15,16,17,17,18,19,19,20,20,
								23,22,22,21,20,20,19,18,17,17,16,15,14,14,13,12,11,10,10,9,8,7,6,6,5,4,3,2,2,1,0,1,1,2,3,3,4,5,5,6,7,7,8,9,9,10,10,11,12,12,13,14,14,15,15,16,17,17,18,18,19,
								24,24,23,22,21,21,20,19,18,18,17,16,15,14,13,13,12,11,10,9,9,8,7,6,5,4,3,3,2,1,0,1,1,2,2,3,4,4,5,6,6,7,7,8,9,9,10,10,11,12,12,13,13,14,14,15,16,16,17,17,18,
								26,25,24,23,23,22,21,20,19,19,18,17,16,15,14,13,13,12,11,10,9,8,7,6,5,5,4,3,2,1,0,1,1,2,2,3,3,4,5,5,6,6,7,7,8,8,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,
								27,26,26,25,24,23,22,21,20,19,19,18,17,16,15,14,13,12,11,10,9,9,8,7,6,5,4,3,2,1,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,
								29,28,27,26,25,24,23,22,21,20,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,7,8,8,9,9,10,10,11,11,11,12,12,13,13,14,
								30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,0,1,1,2,2,3,3,3,4,4,5,5,6,6,6,7,7,8,8,8,9,9,10,10,10,11,11,11,12,12,
								31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,5,4,3,2,1,0,0,1,1,2,2,2,3,3,3,4,4,5,5,5,6,6,6,7,7,7,8,8,9,9,9,10,10,10,11,11,
								33,32,31,30,29,28,27,26,24,23,22,21,20,19,18,17,16,15,14,12,11,10,9,8,7,6,5,3,2,1,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,7,8,8,8,9,9,9,10,
								34,33,32,31,30,29,28,27,25,24,23,22,21,20,19,18,16,15,14,13,12,11,9,8,7,6,5,4,2,1,0,0,1,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5,6,6,6,6,7,7,7,7,8,8,8,
								35,34,33,32,31,30,29,28,26,25,24,23,22,21,19,18,17,16,15,13,12,11,10,9,7,6,5,4,2,1,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,5,5,5,5,6,6,6,6,6,7,7,
								37,36,34,33,32,31,30,29,28,26,25,24,23,21,20,19,18,17,15,14,13,11,10,9,8,6,5,4,3,1,0,0,0,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,
								38,37,36,35,33,32,31,30,29,27,26,25,24,22,21,20,18,17,16,15,13,12,11,9,8,7,5,4,3,1,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,
								39,38,37,36,35,33,32,31,30,28,27,26,24,23,22,20,19,18,16,15,14,12,11,10,8,7,6,4,3,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,3,3,3,
								41,40,38,37,36,34,33,32,31,29,28,27,25,24,22,21,20,18,17,16,14,13,11,10,9,7,6,4,3,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
								42,41,40,38,37,36,34,33,32,30,29,27,26,25,23,22,20,19,18,16,15,13,12,10,9,7,6,4,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
							   );
begin
		
	process(clk)
		variable tmpaddr: integer;
		variable k: integer;
	begin 
		if rising_edge(clk) then
		--	if ce = '1' then 
				k := conv_integer(angle);
				if M = 1 then 
				  tmpaddr :=  rom(k);
---------------------Generated Code Begin  ---------------------------
				 elsif M = 2 then 
					     tmpaddr := rom(k+61);
				 elsif M = 3 then 
					     tmpaddr := rom(k+122);
				 elsif M = 4 then 
					     tmpaddr := rom(k+183);
				 elsif M = 5 then 
					     tmpaddr := rom(k+244);
				 elsif M = 6 then 
					     tmpaddr := rom(k+305);
				 elsif M = 7 then 
					     tmpaddr := rom(k+366);
				 elsif M = 8 then 
					     tmpaddr := rom(k+427);
				 elsif M = 9 then 
					     tmpaddr := rom(k+488);
				 elsif M = 10 then 
					     tmpaddr := rom(k+549);
				 elsif M = 11 then 
					     tmpaddr := rom(k+610);
				 elsif M = 12 then 
					     tmpaddr := rom(k+671);
				 elsif M = 13 then 
					     tmpaddr := rom(k+732);
				 elsif M = 14 then 
					     tmpaddr := rom(k+793);
				 elsif M = 15 then 
					     tmpaddr := rom(k+854);
				 elsif M = 16 then 
					     tmpaddr := rom(k+915);
				 elsif M = 17 then 
					     tmpaddr := rom(k+976);
				 elsif M = 18 then 
					     tmpaddr := rom(k+1037);
				 elsif M = 19 then 
					     tmpaddr := rom(k+1098);
				 elsif M = 20 then 
					     tmpaddr := rom(k+1159);
				 elsif M = 21 then 
					     tmpaddr := rom(k+1220);
				 elsif M = 22 then 
					     tmpaddr := rom(k+1281);
				 elsif M = 23 then 
					     tmpaddr := rom(k+1342);
				 elsif M = 24 then 
					     tmpaddr := rom(k+1403);
				 elsif M = 25 then 
					     tmpaddr := rom(k+1464);
				 elsif M = 26 then 
					     tmpaddr := rom(k+1525);
				 elsif M = 27 then 
					     tmpaddr := rom(k+1586);
				 elsif M = 28 then 
					     tmpaddr := rom(k+1647);
				 elsif M = 29 then 
					     tmpaddr := rom(k+1708);
				 elsif M = 30 then 
					     tmpaddr := rom(k+1769);
				 elsif M = 31 then 
					     tmpaddr := rom(k+1830);
				 elsif M = 32 then 
					     tmpaddr := rom(k+1891);
---------------------Generated Code End  ---------------------------				  
				else 
				  tmpaddr := 0;
				end if;

				if nsamp > "00000101010" then  -- 42
				  addrrt <= conv_std_logic_vector(tmpaddr, 11);
				else 
				  addrrt <= (others => '0');
				end if;  
	--		end if;
		end if;
		
	end process;

	addr <= nsamp -  addrrt;

end Behavioral;