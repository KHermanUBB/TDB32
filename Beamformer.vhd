----------------------------------------------------------------------------------
-- Company: UBB
-- Engineer: Krzysztof Herman
-- 
-- Create Date:    10:13:21 11/27/2017 
-- Design Name:    Beamformer top module
-- Module Name:    Beamformer - Behavioral 
-- Project Name:   Delay and sum beamformer
  
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; 


entity Beamformer is
	port(clk: in std_logic;
	     cen: out std_logic;
	     cclk: out std_logic;
		 sync: out std_logic;
		 n: out  std_logic_vector(10 downto 0);
		 ang: out std_logic_vector(4 downto 0);
         sum: out std_logic_vector(15 downto 0)
		);
end Beamformer;

architecture Behavioral of Beamformer is

------------------------------------------------------- Components Begin ------------------------------------------	
	component 	BRAM_Init   generic( fname : string  := "dataA.txt") ;
							port(    clk  : in std_logic;
                                     ce   : in std_logic;							
								     addr : in std_logic_vector(10 downto 0);    
								     dout : out std_logic_vector(15 downto 0)
								);
	end component;
	
	component AddressMachine generic ( M: integer:= 0);
							 port ( clk: in std_logic;
							       ce   : in std_logic;	
								   nsamp: in  std_logic_vector(10 downto 0);
								   angle: in  std_logic_vector(4 downto 0);
								   addr:  out std_logic_vector(10 downto 0)
								   );
	end component;
	
------------------------------------------------------- Components End --------------------------------------------	


------------------------------------------------------- Routing Begin ------------------------------------------	
	
	-- clock divider 
	signal cclk250k, ce, sync_s:											 std_logic;

    signal cntdiv: 															 std_logic_vector(7 downto 0);
	-- Block RAM address signals
    signal addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8:           std_logic_vector(10 downto 0); 
	signal angle, acount: 													 std_logic_vector(4 downto 0);                    
	-- output from block RAM
	signal xin1, xin2, xin3, xin4, xin5, xin6, xin7, xin8:                  std_logic_vector(15 downto 0);

   -- current sample 
    signal nsamp:        	                                                 std_logic_vector(10 downto 0); 
	
	signal mul1:        	                                                 std_logic_vector(31 downto 0); 
	constant w0:  std_logic_vector(15 downto 0) := "0000000000001010";

	
------------------------------------------------------- Routing End --------------------------------------------	
	
begin
	

--  clock division process
clkdiv:   process(clk)
		   begin
		   if rising_edge(clk) then 
			if  cntdiv < 255 then 
				cntdiv <= cntdiv +1;
			else 
				cntdiv  <= 	(others => '0');	
			end if;
			end if;
		   end process;
 
cclk250k <= cntdiv(7);
ce <= cclk250k;


-- nsamp generation ciclic buffer around 2048 
nsamp_proc: process(cclk250k)
		   begin 
		   if rising_edge(cclk250k) then 
				if nsamp <= 2047 then 
					nsamp <= nsamp +1;
				else 
					nsamp <= (others => '0');		
				end if;
		   end if;
		   end process;

-- angle scan 		   
ang_proc:  process(clk)
           begin
		   if rising_edge(clk) then 
			if ce = '1' then 
				if  angle <= 19 then 
					angle <= angle + 1;
				else 
					angle <= (others => '0');	
				end if;
			 else
					angle <= "10011";
			 end if;			
			end if;
		   end process;
		   
sync_proc: process(clk, cclk250k)
		    begin 
		    if rising_edge(cclk250k) then 
				acount <= (others => '0');
		    end if;
			if rising_edge(clk) then 
				if acount >= 0 and acount <= 25 then  
				   acount <= acount + 1;
				end if;
			end if;

		   end process;


------------------------------------- Channels Begin --------------------------------------------------	
------------------------------------------------------Channel 1 -----------------------------------		   
BRAM1:  BRAM_Init generic map (fname => "data/in/chan_13.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr1,
                                dout => xin1							
							);
AdMach1: AddressMachine 	generic map(M => 1)			
				  port map (	clk => clk,
				                ce  => ce,
								nsamp => nsamp,
								angle => angle,
                                addr => addr1							
							);
------------------------------------------------------Channel 2 -----------------------------------		   
BRAM2:  BRAM_Init generic map (fname => "data/in/chan_14.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr2,
                                dout => xin2							
							);
AdMach2: AddressMachine 	generic map(M => 2)			
				  port map (	clk => clk,
				                ce  => ce,
								nsamp => nsamp,
								angle => angle,
                                addr => addr2							
							);

------------------------------------------------------Channel 3 -----------------------------------		   
BRAM3:  BRAM_Init generic map (fname => "data/in/chan_15.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr3,
                                dout => xin3							
							);
AdMach3: AddressMachine 	generic map(M => 3)			
				  port map (	clk => clk,
				                ce  => ce,
								nsamp => nsamp,
								angle => angle,
                                addr => addr3							
							);

------------------------------------------------------Channel 4 -----------------------------------		   
BRAM4:  BRAM_Init generic map (fname => "data/in/chan_16.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr4,
                                dout => xin4							
							);
AdMach4: AddressMachine 	generic map(M => 4)			
				  port map (	clk => clk,
				                ce  => ce,
								nsamp => nsamp,
								angle => angle,
                                addr => addr4							
							);


------------------------------------------------------Channel 5 -----------------------------------		   
BRAM5:  BRAM_Init generic map (fname => "data/in/chan_17.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr5,
                                dout => xin5							
							);
AdMach5: AddressMachine 	generic map(M => 5)			
				  port map (	clk => clk,
								ce  => ce,
				                nsamp => nsamp,
								angle => angle,
                                addr => addr5							
							);
							
------------------------------------------------------Channel 6 -----------------------------------		   
BRAM6:  BRAM_Init generic map (fname => "data/in/chan_18.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr6,
                                dout => xin6							
							);
AdMach6: AddressMachine 	generic map(M => 6)			
				  port map (	clk => clk,
				                ce  => ce,
				                nsamp => nsamp,
								angle => angle,
                                addr => addr6							
							);

------------------------------------------------------Channel 7 -----------------------------------		   
BRAM7:  BRAM_Init generic map (fname => "data/in/chan_19.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr7,
                                dout => xin7							
							);
AdMach7: AddressMachine 	generic map(M => 7)			
				  port map (	clk => clk,
				                ce  => ce,
								nsamp => nsamp,
								angle => angle,
                                addr => addr7							
							);

------------------------------------------------------Channel 8 -----------------------------------		   
BRAM8:  BRAM_Init generic map (fname => "data/in/chan_20.txt")
		          port map (	clk => clk,
				                ce  => cclk250k,
				    			addr => addr8,
                                dout => xin8							
							);
AdMach8: AddressMachine 	generic map(M => 8)			
				  port map (	clk => clk,
				                ce  => ce,
								nsamp => nsamp,
								angle => angle,
                                addr => addr8							
							);

--------------------------------- Channels End ---------------------------------------------------							

-------------------------------- Control logic Begin ---------------------------------------------------


-------------------------------- Control logic End ---------------------------------------------------


-------------------------------- Output logic Begin ---------------------------------------------------

sync_s <= '1' when acount >= 4 and acount <= 24  else '0'; 
sync <= sync_s;
cclk <= cclk250k;
ang <= angle;
n <= nsamp;
cen <= ce;

-- multiplication example weighting
--mul1 <= w0*xin1;
--sum  <=  mul1(31 downto 16) + xin2 +xin3 + xin4 + xin5 + xin6 +xin7 + xin8;
sum  <= xin1 + xin2 +xin3 + xin4 + xin5 + xin6 +xin7 + xin8 when sync_s = '1'  else  (others => '0');
--sum  <= xin1 + xin2 +xin3 + xin4 + xin5 + xin6 +xin7 + xin8 when sync_s = '1' and nsamp >= 10 else  (others => '0');
-------------------------------- Output  logic Begin ---------------------------------------------------
end Behavioral;

