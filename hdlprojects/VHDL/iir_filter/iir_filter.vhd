--------------------------------------------------------------------------------
-- iir_filter.vhd
-- JDC
-- 8/9/15
--------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;                  
use IEEE.std_logic_signed.all;

entity  iir_filter is
    generic (
        NUMTAPSA    : integer;
        NUMTAPSB    : integer
    );
    port (
        d_out    : out std_logic_vector (15 downto 0);
        x        : in  std_logic_vector (15 downto 0);
        clk      : in  std_logic;       -- always there synchronous FPGA clock
        sclk     : in std_logic;        -- sampling clock
        reset_n  : in  std_logic;
        valid    : in  std_logic
    );
end iir_filter; 

architecture behavior of iir_filter is
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

    type    array_type_b is array (0 to NUMTAPSB-1) of integer;     --signed (31 downto 0);
    signal      b : array_type_b;
    type    array_type_a is array (0 to NUMTAPSA-1) of integer;     --signed (31 downto 0);
    signal      a : array_type_a;
    
    signal      coeff_add : std_logic_vector(5 downto 0);

    signal      x_int : integer;
   
    signal      sclk_del    :   std_logic;
    signal      sclk_del2   :   std_logic;
    signal      sclk_rising :   std_logic;
    
    signal      tempb       :   array_type_b;
    signal      tempa       :   array_type_a;      
    signal      y : integer; --TODO how is unsigned vector
                    -- done?
    signal      youtb : integer;                
    signal      youta : integer;
    signal      za          : array_type_a; -- TODO signed
    signal      zb          : array_type_b; -- TODO signed
    signal      suma        : array_type_a; -- TODO signed
    signal      sumb        : array_type_b; -- TODO signed
    
    
    
    signal      d_outx32768 : std_logic_vector(31 downto 0);

begin
    -- Handle the B part or numerator
    GEN_SHNMULTB :
    for I in 0 to NUMTAPSB-1 generate
        GEN_SHNMULT0B :
        if (I = 0) generate 
            SHNMULT0B :   shiftnmult port map
            (
                clk         =>  clk, 
                reset_n     =>  reset_n,
                valid       =>  valid,
                en_shift    =>  sclk_rising,
                coeff       =>  b(I),
                temp        =>  tempb(I),
                zin         =>  x_int,
                zout        =>  zb(0)        
            );
        end generate GEN_SHNMULT0B;
        GEN_SHNMULTN0B :
        if (I /= 0) generate
            SHNMULTN0B :   shiftnmult port map
            (
                clk         =>  clk, 
                reset_n     =>  reset_n,
                valid       =>  valid,
                en_shift    =>  sclk_rising,
                coeff       =>  b(I),
                temp        =>  tempb(I),
                zin         =>  zb(I-1),
                zout        =>  zb(I)        
            );
        end generate GEN_SHNMULTN0B;
    end generate GEN_SHNMULTB;
    
    GEN_ADDITUPB :
    for J in 0 to (NUMTAPSB  - 1) generate
        GEN_ADDITUP0B :
        if (J = 0 ) generate
        adder0b : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  sumb(0),    
                a       =>  tempb(0),
                b       =>  tempb(1)    
             );
        end generate GEN_ADDITUP0B;
        GEN_ADDITUPN0B:
        if (J > 0) and (J < NUMTAPSB - 1) generate
        addern0b : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  sumb(J),    
                a       =>  sumb(J-1),
                b       =>  tempb(J)    
             );
        end generate GEN_ADDITUPN0B;
        GEN_ADDITUPNUMTAPSBB :
        if (J = NUMTAPSB - 1) generate
        addernumtapsb : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  youtb,    
                a       =>  sumb(J-1),
                b       =>  tempb(J)    
             );
        end generate GEN_ADDITUPNUMTAPSBB;        
    end generate GEN_ADDITUPB;

-- Handle the A part or denominator    
    GEN_SHNMULTA :
    for I in 0 to NUMTAPSA-1 generate
        GEN_SHNMULT0A :
        if (I = 0) generate 
            SHNMULT0A :   shiftnmult port map
            (
                clk         =>  clk, 
                reset_n     =>  reset_n,
                valid       =>  valid,
                en_shift    =>  sclk_rising,
                coeff       =>  a(I),
                temp        =>  tempa(I),
                zin         =>  y,
                zout        =>  za(0)        
            );
        end generate GEN_SHNMULT0A;
        GEN_SHNMULTN0A :
        if (I /= 0) generate
            SHNMULTN0A :   shiftnmult port map
            (
                clk         =>  clk, 
                reset_n     =>  reset_n,
                valid       =>  valid,
                en_shift    =>  sclk_rising,
                coeff       =>  a(I),
                temp        =>  tempa(I),
                zin         =>  za(I-1),
                zout        =>  za(I)        
            );
        end generate GEN_SHNMULTN0A;
    end generate GEN_SHNMULTA;
    
    GEN_ADDITUPA :
    for J in 0 to (NUMTAPSA  - 1) generate
        GEN_ADDITUP0A :
        if (J = 0 ) generate
        adder0a : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  suma(0),    
                a       =>  tempa(0),
                b       =>  tempa(1)    
             );
        end generate GEN_ADDITUP0A;
        GEN_ADDITUPN0A:
        if (J > 0) and (J < NUMTAPSA - 1) generate
        addern0a : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  suma(J),    
                a       =>  suma(J-1),
                b       =>  tempa(J)    
             );
        end generate GEN_ADDITUPN0A;
        GEN_ADDITUPNUMTAPSAA :
        if (J = NUMTAPSA - 1) generate
        addernumtapsa : adder port map
            (
                en      =>  sclk_rising,          
                sum     =>  youta,    
                a       =>  suma(J-1),
                b       =>  tempa(J)    
             );
        end generate GEN_ADDITUPNUMTAPSAA;        
    end generate GEN_ADDITUPA;
    
    b(0)    <=  3198;
    b(1)    <=  6400;
    b(2)    <=  3198;
--    b(3)    <=  288;

    a(0)    <=  32768;
    a(1)    <=  30894;
    a(2)    <=  -10922;
--    a(3)    <=  18720;



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

--    SHIFTANDMULTB : process(clk,reset_n) begin
--        if(reset_n = '0') then
--            temp0b <= 0;temp1b <= 0;temp2b <= 0; --temp3b <= 0;
--            youtb <= 0;
--            z0b <= 0;z1b <= 0;z2b <= 0; --z3b <= 0;
--       elsif (clk'event and clk = '1' and valid = '1' and sclk_rising = '1') then
--            z0b <= x_int;z1b <= z0b;z2b <= z1b; --z3b <= z2b; 
--            temp0b <= z0b * b(0);
--            temp1b <= z1b * b(1);
--            temp2b <= z2b * b(2);
--       --     temp3b <= z3b * b(3);
--            youtb <= temp0b  + temp1b + temp2b; -- + temp3b; 
--        end if;            
--    end process;
--        
--    SHIFTANDMULTA : process(clk,reset_n) begin
--        if(reset_n = '0') then
--            temp0a <= 0;temp1a <= 0;temp2a <= 0;
--            youta <= 0; 
--            z0a <= 0;z1a <= 0;z2a <= 0;
--       elsif (clk'event and clk = '1' and valid = '1' and sclk_rising = '1') then
--            z0a <= yinta;z1a <= z0a;z2a <= z1a; 
--            temp0a <= z0a * a(0);
--            temp1a <= z1a * a(1);
--            temp2a <= z2a * a(2);
--        --    temp3a <= z3a * a(3);
--            youta <= temp0a  + temp1a + temp2a; -- + temp3a; 
--        end if;            
--
--    end process;
    -- put behavior, process, and port maps here
    x_int <= to_integer(signed(x));
    d_outx32768 <= std_logic_vector(to_signed(y,32));
    d_out <= d_outx32768(16 downto 1);
    sclk_rising <=  sclk_del and not sclk_del2;
    y   <=  youta + youtb;
end behavior;

