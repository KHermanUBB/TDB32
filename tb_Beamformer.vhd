
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_Beamformer IS
END tb_Beamformer;
 
ARCHITECTURE behavior OF tb_Beamformer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Beamformer
    PORT(
         clk : IN  std_logic;
		   cen: out  std_logic;
         cclk : OUT  std_logic;
		   sync: out std_logic;
         n : OUT  std_logic_vector(10 downto 0);
		   ang: out std_logic_vector(5 downto 0);
         sum : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
    
   --Inputs
   signal clk : std_logic;
    signal ce : std_logic;

 	--Outputs
   signal cclk : std_logic;
   signal sync:  std_logic;
   signal n : std_logic_vector(10 downto 0);
   signal  ang:  std_logic_vector(5 downto 0);
   signal sum : std_logic_vector(15 downto 0);
   
   -- file declarations
   file fileOUT: text;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant MAX_SIM_TIME :time := 5244 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Beamformer PORT MAP (
          clk => clk,
		  cen => ce,
          cclk => cclk,
		  sync => sync,
          n => n,
		  ang => ang,
          sum => sum
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
      -- declare variables to read from txt file  "var1 space var2"
		variable currentOutLine: line;
		variable arg: std_logic_vector(15 downto 0);
		variable spac: character;
   begin		
   	file_open(fileOUT, "data/out/tbOutData.txt", write_mode);
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;	
      -- insert stimulus here 
  
      while NOW < MAX_SIM_TIME loop
	  
	  if sync = '1' then 
		  arg := sum;
		  write(currentOutLine, arg , right, 16);
		  writeline(fileOUT, currentOutLine);
	  end if; 	  
      
	  wait for clk_period;
      end loop;
	  
	  file_close(fileOUT);
      wait;
   end process;

END;



