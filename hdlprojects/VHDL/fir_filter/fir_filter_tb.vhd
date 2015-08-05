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
        sclk    :   IN  std_logic;
        reset_n :   IN  std_logic;
        valid   :   IN  std_logic
        );
    END COMPONENT;
    SIGNAL d_out   :   std_logic_vector (15 downto 0);
    SIGNAL x       :   std_logic_vector (15 downto 0); 
    SIGNAL x_impulse    :   std_logic_vector (15 downto 0);
    SIGNAL clk     :   std_logic;
    SIGNAL sclk    :   std_logic;
    SIGNAL reset_n :   std_logic;
    SIGNAL valid   :   std_logic;
    SIGNAL mux_out :   std_logic; 
    SIGNAL ctr     :   std_logic_vector (4 downto 0);
    SIGNAL ctr_index    :   integer;
    
BEGIN
    UUT : fir_filter port map
    (
        d_out       =>  d_out  ,  
        x           =>  x      ,
        clk         =>  clk    ,
        sclk        =>  sclk    ,
        reset_n     =>  reset_n,
        valid       =>  valid
    );

    clk_gen_100M :   PROCESS BEGIN
        clk <=  '0';
        wait  for  5 ns;
        clk <=  '1';
        wait for 5 ns;        
    END PROCESS;
    
    impulse_gen :   PROCESS BEGIN
        x_impulse   <=  x"0000";   
        wait for 1 us;
        x_impulse   <=  x"0001";
        wait for 113 ns;
        x_impulse   <=  x"0000";
        wait;
    END PROCESS;
    
    sclk_gen    :   PROCESS BEGIN
        sclk <= '0';
        wait for 53 ns;  
        sclk <= '1';
        wait for 53 ns;
    END PROCESS;

    tb  :   PROCESS BEGIN
        reset_n <=  '0';
        valid   <=  '0';
        wait for 100 ns;
        reset_n <=  '1';
        valid   <=  '1';
        wait;
        
    END PROCESS;
    
    counter : PROCESS(sclk,reset_n) BEGIN
        if (reset_n = '0') then
            ctr <= "00000";
        elsif (clk'event and clk = '1') then
            ctr <= ctr + "00001";
        end if;
    END PROCESS;
    
    change_freq : PROCESS BEGIN
        ctr_index   <=  4;
        wait for 200 us;
        ctr_index   <=  3;
        wait for 200 us;
        ctr_index   <=  2;
        wait for 200 us;
        ctr_index   <=  1;
        wait for 200 us;
        ctr_index   <=  0;
        wait;
    END PROCESS;
    
    sclk_mux : PROCESS(ctr_index,ctr(4 downto 0)) BEGIN
        CASE (ctr_index) IS
            when    4   =>      mux_out <=  ctr(4);
            when    3   =>      mux_out <=  ctr(3);
            when    2   =>      mux_out <=  ctr(2);
            when    1   =>      mux_out <=  ctr(1);
            when    0   =>      mux_out <=  ctr(0);
            when OTHERS =>      mux_out <=  '0';
        END CASE;
    END PROCESS;
     x <= x"0001" when (mux_out = '1') 
        else x"ffff";

--       x   <=  x_impulse;
END BENCH;