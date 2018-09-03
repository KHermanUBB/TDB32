LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_AddressMachine IS
END tb_AddressMachine;
 
ARCHITECTURE behavior OF tb_AddressMachine IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AddressMachine
	generic ( M: integer:= 0);
    PORT(
         clk : IN  std_logic;
         nsamp : IN  std_logic_vector(10 downto 0);
         angle : IN  std_logic_vector(4 downto 0);
         addr : OUT  std_logic_vector(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal nsamp : std_logic_vector(10 downto 0) := (others => '0');
   signal angle : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal addr : std_logic_vector(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AddressMachine generic map (M => 1)
	PORT MAP (
          clk => clk,
          nsamp => nsamp,
          angle => angle,
          addr => addr
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
	  nsamp <= "00000000001";
      wait for clk_period*10;
	  nsamp <= "00000000101";
      wait for clk_period*10;
	  nsamp <= "00000010100";
      wait for clk_period*10;
	  nsamp <= "00000010101";
	  
	  wait for clk_period;
		  angle <= "00001";
	  wait for clk_period;
	  	  angle <= "00010";
	  wait for clk_period;
	  	  angle <= "00011";
	  wait for clk_period;
	  	  angle <= "00100";
	  wait for clk_period;
	  	  angle <= "00101";
	  wait for clk_period;
	  	  angle <= "00110";
	  wait for clk_period;
	  	  angle <= "00111";
	  wait for clk_period;
	  	  angle <= "01000";
	  wait for clk_period;
	  	  angle <= "01001";
	  wait for clk_period;
	  	  angle <= "01010";
	  wait for clk_period;
	  	  angle <= "01011";
	  wait for clk_period;
	  	  angle <= "01100";
	  wait for clk_period;
	  	  angle <= "01101";
	  wait for clk_period;
	  	  angle <= "01110";
	  wait for clk_period;
	  	  angle <= "01111";
	  wait for clk_period;
	  	  angle <= "10000";
	  wait for clk_period;
	  	  angle <= "10001";
	  wait for clk_period;
	  	  angle <= "10010";
	  wait for clk_period;
	  	  angle <= "10011";
	  wait for clk_period;
	  	  angle <= "10100";


      -- insert stimulus here 

      wait;
   end process;

END;
