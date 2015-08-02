--------------------------------------------------------------------------------
-- fir_filter_tb.vhd
-- Author JDC
-- Date 7/31/15                                                                    
--------------------------------------------------------------------------------
LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;                  
USE IEEE.std_logic_signed.all;

ENTITY fir_filter_tb is
END fir_filter_tb;

ARCHITECTURE BENCH OF fir_filter_tb IS
    COMPONENT fir_filter
    PORT(
        d_out   :   OUT std_logic_vector (15 downto 0);
        x       :   IN  std_logic_vector (15 downto 0);
        clk     :   IN  std_logic;
        reset_n :   IN  std_logic;
        valid   :   IN  std_logic
        );
    END COMPONENT;
    SIGNAL d_out   :   std_logic_vector (15 downto 0);
    SIGNAL x       :   std_logic_vector (15 downto 0);
    SIGNAL clk     :   std_logic;
    SIGNAL reset_n :   std_logic;
    SIGNAL valid   :   std_logic;
    SIGNAL ctr     :   std_logic_vector (4 downto 0);
BEGIN
    UUT : fir_filter port map
    (
        d_out       =>  d_out  ,  
        x           =>  x      ,
        clk         =>  clk    ,
        reset_n     =>  reset_n,
        valid       =>  valid
    );

    clk_gen :   PROCESS BEGIN
        clk <=  '0';
        wait  for  5 ns;
        clk <=  '1';
        wait for 5 ns;        
    END PROCESS;

    tb  :   PROCESS BEGIN
        reset_n <=  '0';
        valid   <=  '0';
        wait for 100 ns;
        reset_n <=  '1';
        valid   <=  '1';
        wait;
        
    END PROCESS;
    
    counter : PROCESS(clk,reset_n) BEGIN
        if (reset_n = '0') then
            ctr <= "00000";
        elsif (clk'event and clk = '1') then
            ctr <= ctr + "00001";
        end if;
    END PROCESS;  
     x  <=   x"0001" when (ctr(4) = '1')
      else x"ffff";
END BENCH;