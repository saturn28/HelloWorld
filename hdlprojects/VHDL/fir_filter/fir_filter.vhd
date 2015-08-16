--------------------------------------------------------------------------------
-- fir_filter.vhd
-- Converted a Verilog DSP example I obtained from the internet and converted
-- to VHDL.
-- Date 7/31/15                                                                    
--------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;                  
use IEEE.std_logic_signed.all;
                                                                
entity fir_filter is
    generic (
        NUMTAPS :   integer := 51   
    );
    port (
        d_out    : out std_logic_vector (15 downto 0);
        x        : in  std_logic_vector (15 downto 0);
        clk      : in  std_logic;       -- always there synchronous FPGA clock
        sclk     : in std_logic;        -- sampling clock
        reset_n  : in  std_logic;
        valid    : in  std_logic
        );
end fir_filter;

architecture behavior of fir_filter is 
    component shiftnmult is
        port (
            clk     : in    std_logic;
            reset_n : in    std_logic;
            valid   : in    std_logic;
            en_shift    : in    std_logic; -- connect to sclk rising
            coeff   : in    integer;
            temp    : out   integer;
            zin     : in    integer;
            zout    : out   integer
            
            );
    end component shiftnmult;
    
    component adder is
    port (
        en          : in    std_logic;
        sum         : out   integer;
        a           : in    integer;
        b           : in    integer
    );
    end component adder;


-- put internal signals here
    type    array_type_2 is array (0 to NUMTAPS-1) of integer;     --signed (31 downto 0);
    signal      b : array_type_2;
    signal      coeff_add : std_logic_vector(5 downto 0);

    signal      x_int : integer;
   
    signal      sclk_del    :   std_logic;
    signal      sclk_del2   :   std_logic;
    signal      sclk_rising :   std_logic;
    

    signal      temp    :   array_type_2;   
    signal      y : integer; --TODO how is unsigned vector
                    -- done?

    signal      z           :   array_type_2;
    signal      sum         :   array_type_2;
    signal      d_outx32768 : std_logic_vector(31 downto 0);



-- put component definitions here
begin
    GEN_SHNMULT :
    for I in 0 to NUMTAPS-1 generate
        GEN_SHNMULT0 :
        if (I = 0) generate 
            SHNMULT0 :   shiftnmult port map
            (
                clk         =>  clk, 
                reset_n     =>  reset_n,
                valid       =>  valid,
                en_shift    =>  sclk_rising,
                coeff       =>  b(I),
                temp        =>  temp(I),
                zin         =>  x_int,
                zout        =>  z(0)        
            );
        end generate GEN_SHNMULT0;
        GEN_SHNMULTN0 :
        if (I /= 0) generate
            SHNMULTN0 :   shiftnmult port map
            (
                clk         =>  clk, 
                reset_n     =>  reset_n,
                valid       =>  valid,
                en_shift    =>  sclk_rising,
                coeff       =>  b(I),
                temp        =>  temp(I),
                zin         =>  z(I-1),
                zout        =>  z(I)        
            );
        end generate GEN_SHNMULTN0;
    end generate GEN_SHNMULT;
    
    GEN_ADDITUP :
    for J in 0 to (NUMTAPS  - 1) generate
        GEN_ADDITUP0 :
        if (J = 0 ) generate
        adder0 : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  sum(0),    
                a       =>  temp(0),
                b       =>  temp(1)    
             );
        end generate GEN_ADDITUP0;
        GEN_ADDITUPN0:
        if (J > 0) and (J < NUMTAPS - 1) generate
        addern0 : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  sum(J),    
                a       =>  sum(J-1),
                b       =>  temp(J)    
             );
        end generate GEN_ADDITUPN0;
        GEN_ADDITUPNUMTAPS :
        if (J = NUMTAPS - 1) generate
        addernumtaps : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  y,    
                a       =>  sum(J-1),
                b       =>  temp(J)    
             );
        end generate GEN_ADDITUPNUMTAPS;        
    end generate GEN_ADDITUP;
    
    b(0)    <=  -24;
    b(1)    <=  -114;
    b(2)    <=  -84;
    b(3)    <=  -96;
    b(4)    <=  -62;
    b(5)    <=    2;
    b(6)    <=  95  ;
    b(7)    <=  198 ;
    b(8)    <=  281 ;
    b(9)    <=  315 ;
    b(10)   <=  271 ;
    b(11)   <=  135 ;
    b(12)   <=  -85 ;
    b(13)   <=  -358;
    b(14)   <=  -625;
    b(15)   <=  -812;
    b(16)   <=  -842;
    b(17)   <=  -650;
    b(18)   <=  -201;
    b(19)   <=  496 ;
    b(20)   <=  1391;
    b(21)   <=  2386;
    b(22)   <=  3358;
    b(23)   <=  4175;
    b(24)   <=  4719;
    b(25)   <=  4910;
    b(26)   <=  4719;
    b(27)   <=  4175;
    b(28)   <=  3358;
    b(29)   <=  2386;
    b(30)   <=  1391;
    b(31)   <=  496 ;
    b(32)   <=  -201;
    b(33)   <=  -650;
    b(34)   <=  -842;
    b(35)   <=  -812;
    b(36)   <=  -625;
    b(37)   <=  -358;
    b(38)   <=  -85 ;
    b(39)   <=  135 ;
    b(40)   <=  271 ;
    b(41)   <=  315 ;
    b(42)   <=  281 ;
    b(43)   <=  198 ;
    b(44)   <=  95  ;
    b(45)   <=  2   ;
    b(46)   <=  -62 ;
    b(47)   <=  -96 ;
    b(48)   <=  -84 ;
    b(49)   <=  -114;
    b(50)   <=  -24 ;

    POINTER : process (clk,reset_n) begin
        if (reset_n = '0') then
            coeff_add <= "000000";
        elsif (clk'event and clk = '1' and sclk_rising = '1') then
            if coeff_add = "111111" then
                coeff_add <= "000001";
            elsif (valid = '1') then
                coeff_add <= coeff_add + "000001";
            end if;
        end if;
    end process;
    
    SCLKEDGEDET : PROCESS (clk,reset_n) BEGIN
        if (reset_n = '0') then
            sclk_del    <=  '0';
            sclk_del2   <=  '0';
        elsif (clk'event and clk = '1') then
            sclk_del    <=  sclk;
            sclk_del2   <=  sclk_del;
        end if;
    END PROCESS;

    -- put behavior, process, and port maps here
    x_int <= to_integer(signed(x));
    d_outx32768 <= std_logic_vector(to_signed(y,32));
    d_out <= d_outx32768(16 downto 1);
    sclk_rising <=  sclk_del and not sclk_del2;
end behavior;


