--------------------------------------------------------------------------------
-- iir_filter_tb.vhd
-- Author JDC
-- Date 8/10/15
--------------------------------------------------------------------------------
LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_signed.all;

ENTITY iir_filter_tb is
END iir_filter_tb;

ARCHITECTURE BENCH OF iir_filter_tb IS
    COMPONENT iir_filter
    GENERIC (
        NUMTAPSA    : integer;
        NUMTAPSB    : integer
    );
    PORT(
        d_out   :   OUT std_logic_vector (15 downto 0);
        x       :   IN  std_logic_vector (15 downto 0);
        clk     :   IN  std_logic;
        sclk    :   IN  std_logic;
        reset_n :   IN  std_logic;
        valid   :   IN  std_logic
        );
    END COMPONENT;
    TYPE    array_type_wav is array (0 to 20) of integer; 
    SIGNAL d_out   :   std_logic_vector (15 downto 0);
    SIGNAL x       :   std_logic_vector (15 downto 0);
    SIGNAL x_impulse    :   std_logic_vector (15 downto 0);
    SIGNAL clk     :   std_logic;
    SIGNAL sclk    :   std_logic;
    SIGNAL sclkx2    :   std_logic;
    SIGNAL reset_n :   std_logic;
    SIGNAL valid   :   std_logic;
    SIGNAL mux_out :   std_logic;
    SIGNAL ctr     :   std_logic_vector (5 downto 0);
    SIGNAL ctr_index    :   integer;
    SIGNAL wav_ctr  :   integer range 0 to 20;
    SIGNAL wav      : array_type_wav;

BEGIN
    UUT : iir_filter 
    generic map
    (
        NUMTAPSA =>  3,
        NUMTAPSB =>  3
    )
    port map
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
        wait  for  500 ns;
        clk <=  '1';
        wait for 500 ns;
    END PROCESS;

    sclk_gen    :   PROCESS BEGIN
        sclk <= '0';
        wait for 25 us;
        sclk <= '1';
        wait for 25 us;
    END PROCESS;
    
    sclk_genx2    :   PROCESS BEGIN
        sclkx2 <= '0';
        wait for 12500 ns;
        sclkx2 <= '1';
        wait for 12500 ns;
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
            ctr <= "000000";
        elsif (sclk'event and sclk = '1') then
            ctr <= ctr + "000001";
        end if;
    END PROCESS;
    
--    sinegen_1k : PROCESS(sclkx2,reset_n) BEGIN
--        if (reset_n = '0') then
--            wav_ctr <=  0;
--        elsif (sclkx2'event and sclkx2 = '1') then
--            if (wav_ctr < 19 and wav_ctr >= 0) then
--                wav_ctr <= wav_ctr + 1;
--            else
--                wav_ctr <= 0;
--            end if;
--        end if;
--    END PROCESS;

    change_freq : PROCESS BEGIN
        ctr_index   <=  5;
        wait for 20000 us;    
        ctr_index   <=  4;
        wait for 20000 us;
        ctr_index   <=  3;
        wait for 20000 us;
        ctr_index   <=  2;
        wait for 20000 us;
        ctr_index   <=  1;
        wait for 20000 us;
        ctr_index   <=  0;
        wait;
    END PROCESS;

    sclk_mux : PROCESS(ctr_index,ctr(5 downto 0)) BEGIN
        CASE (ctr_index) IS
            when    5   =>      mux_out <=  ctr(5);
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
--    x <= std_logic_vector(to_signed(wav(wav_ctr),16));
--    wav(0)  <=  0;
--    wav(1)  <=  31;
--    wav(2)  <=  59;
--    wav(3)  <=  81;
--    
--    wav(4)  <=  95;
--    wav(5)  <=  100;
--    wav(6)  <=  95;
--    wav(7)  <=  81;
--    
--    wav(8)  <=  59;
--    wav(9)  <=  31;
--    wav(10)  <=  0;
--    wav(11)  <=  -31;
--    
--    wav(12)  <=  -59;
--    wav(13)  <=  -81;
--    wav(14)  <=  -95;
--    wav(15)  <=  -100;
--    
--    wav(16)  <=  -95;
--    wav(17)  <=  -81;
--    wav(18)  <=  -59;
--    wav(19)  <=  -31;
--    wav(20)  <=     0;

END BENCH;