--------------------------------------------------------------------------------
-- fir_filter.vhd
-- Converted a Verilog DSP example I obtained from the internet and converted
-- to VHDL.
-- Date 7/31/15                                                                    
--------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_textio.all;
--use IEEE.std_logic_arith.all;
--use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;                  
use IEEE.std_logic_signed.all;
-- use IEEE.std_logic_unsigned.all;
--use IEEE.math_real.all;
--use IEEE.math_complex.all;

                                                                
entity fir_filter is
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
-- put internal signals here
    type    array_type_2 is array (0 to 50) of integer;     --signed (31 downto 0);
    signal      b : array_type_2;
    signal      coeff_add : std_logic_vector(5 downto 0);

    signal      x_int : integer;
   
    signal      sclk_del    :   std_logic;
    signal      sclk_del2   :   std_logic;
    signal      sclk_rising :   std_logic;
    
    signal      temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,
                temp9,temp10,temp11,temp12,temp13,temp14,temp15,temp16,temp17,temp18,
                temp19,temp20,temp21,temp22,temp23,temp24,temp25,temp26,temp27,temp28,
                temp29,temp30,temp31,temp32,temp33,temp34,temp35,temp36,temp37,temp38,
                temp39,temp40,temp41,temp42,temp43,temp44,temp45,temp46,temp47,temp48,
                temp49,temp50 : integer;    --signed (31 downto 0);

    signal      y : integer; --TODO how is unsigned vector
                    -- done?

    signal      z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,
                z16,z17,z18,z19,z20,z21,z22,z23,z24,z25,z26,z27,z28,z29,z30,z31,z32,z33,z34,
                z35,z36,z37,z38,z39,z40,z41,z42,z43,z44,z45,z46,
                z47,z48,z49,z50 : integer; -- TODO signed
    
    signal      d_outx32768 : std_logic_vector(31 downto 0);



-- put component definitions here
begin
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

    SHIFTANDMULT : process(clk,reset_n) begin
        if(reset_n = '0') then
            temp0 <= 0;temp1 <= 0;temp2 <= 0;temp3 <= 0;temp4 <= 0;
            temp5 <= 0;temp6 <= 0;temp7 <= 0;temp8 <= 0;temp9 <= 0;
            temp10 <= 0;temp11 <= 0;temp12 <= 0;temp13 <= 0;temp14 <= 0;
            temp15 <= 0;temp16 <= 0;temp17 <= 0;temp18 <= 0;temp19 <= 0;
            temp20 <= 0;temp21 <= 0;temp22 <= 0;temp23 <= 0;temp24 <= 0;
            temp25 <= 0;temp26 <= 0;temp27 <= 0;temp28 <= 0;temp29 <= 0;
            temp30 <= 0;temp31 <= 0;temp32 <= 0;temp33 <= 0;temp34 <= 0;
            temp35 <= 0;
            temp36 <= 0;temp37 <= 0;temp38 <= 0;temp39 <= 0;temp40 <= 0;
            temp41 <= 0;temp42 <= 0;temp43 <= 0;temp44 <= 0;temp45 <= 0;
            temp46 <= 0;temp47 <= 0;
            temp48 <= 0;temp49 <= 0;temp50 <= 0;
            y <= 0;
            z0 <= 0;z1 <= 0;z2 <= 0;z3 <= 0;z4 <= 0;z5 <= 0;
            z6 <= 0;z7 <= 0;z8 <= 0;z9 <= 0;z10 <= 0;z11 <= 0;
            z12 <= 0;z13 <= 0;z14 <= 0;z15 <= 0;z16 <= 0;z17 <= 0;
            z18 <= 0;
            z19 <= 0;
            z20 <= 0;
            z21 <= 0;
            z22 <= 0;z23 <= 0;
            z24 <= 0;z25 <= 0;z26 <= 0;z27 <= 0;z28 <= 0;z29 <= 0;
            z30 <= 0;
            z31 <= 0;z32 <= 0;z33 <= 0;
            z34 <= 0;
            z35 <= 0;z36 <= 0;
            z37 <= 0;z38 <= 0;
            z39 <= 0;z40 <= 0;z41 <= 0;z42 <= 0;
            z43 <= 0;z44 <= 0;z45 <= 0;z46 <= 0;z47 <= 0;z48 <= 0;
            z49 <= 0;
            z50 <= 0;
       elsif (clk'event and clk = '1' and valid = '1' and sclk_rising = '1') then
            z0 <= x_int;z1 <= z0;z2 <= z1;z3 <= z2;z4 <= z3;z5 <= z4;z6 <= z5;
            z7 <= z6;z8 <= z7;z9 <= z8;z10 <= z9;z11 <= z10;z12 <= z11;
            z13 <= z12;z14 <= z13;z15 <= z14;
            z16 <= z15;z17 <= z16;z18 <= z17;
            z19 <= z18;z20 <= z19;z21 <= z20;
            z22 <= z21;z23 <= z22;
            z24 <= z23;z25 <= z24;z26 <= z25;z27 <= z26;
            z28 <= z27;z29 <= z28;
            z30 <= z29;z31 <= z30;z32 <= z31;
            z33 <= z32;z34 <= z33;z35 <= z34;
            z36 <= z35;z37 <= z36;z38 <= z37;
            z39 <= z38;z40 <= z39;z41 <= z40;z42 <= z41;
            z43 <= z42;z44 <= z43;z45 <= z44;
            z46 <= z45;z47 <= z46;z48 <= z47;z49 <= z48;z50 <= z49; temp0 <= z0 * b(0);
            temp1 <= z1 * b(1);
            temp2 <= z2 * b(2);
            temp3 <= z3 * b(3);
            temp4 <= z4 * b(4);
            temp5 <= z5 * b(5);
            temp6 <= z6 * b(6);
            temp7 <= z7 * b(7);
            temp8 <= z8 * b(8);                          
            temp9 <= z9 * b(9);
            temp10 <= z10 * b(10);
            temp11 <= z11 * b(11);
            temp12 <= z12 * b(12);
            temp13 <= z13 * b(13);
            temp14 <= z14 * b(14);
            temp15 <= z15 * b(15);
            temp16 <= z16 * b(16);
            temp17 <= z17 * b(17);
            temp18 <= z18 * b(18);
            temp19 <= z19 * b(19);
            temp20 <= z20 * b(20);
            temp21 <= z21 * b(21);
            temp22 <= z22 * b(22);
            temp23 <= z23 * b(23);
            temp24 <= z24 * b(24);
            temp25 <= z25 * b(25);
            temp26 <= z26 * b(26);
            temp27 <= z27 * b(27);
            temp28 <= z28 * b(28);
            temp29 <= z29 * b(29);
            temp30 <= z30 * b(30);
            temp31 <= z31 * b(31);
            temp32 <= z32 * b(32);
            temp33 <= z33 * b(33);                           
            temp34 <= z34 * b(34);
            temp35 <= z35 * b(35);
            temp36 <= z36 * b(36);                       
            temp37 <= z37 * b(37);
            temp38 <= z38 * b(38);
            temp39 <= z39 * b(39);
            temp40 <= z40 * b(40);
            temp41 <= z41 * b(41);
            temp42 <= z42 * b(42);
            temp43 <= z43 * b(43);
            temp44 <= z44 * b(44);
            temp45 <= z45 * b(45);
            temp46 <= z46 * b(46);
            temp47 <= z47 * b(47);
            temp48 <= z48 * b(48);
            temp49 <= z49 * b(49);
            temp50 <= z50 * b(50);
            y <= temp0  + temp1+ temp2 +temp3 + temp4 + temp5  + temp6 + temp7 +
            temp8 + temp9 + temp10  + temp11 + temp12 + temp13 + temp14 + temp15  + temp16 + temp17 + temp18 +
            temp19 + temp20  + temp21 + temp22 + temp23 + temp24 + temp25  + temp26 + temp27 + temp28 + temp29 + temp30  + temp31 + temp32 +
            temp33 + temp34 + temp35  + temp36 + temp37 + temp38 + temp39 + temp40  + temp41  + temp42 + temp43 + temp44 + temp45  + temp46 + 
            temp47 + temp48 + temp49 + temp50;
        end if;            

    end process;
    -- put behavior, process, and port maps here
    x_int <= to_integer(signed(x));
    d_outx32768 <= std_logic_vector(to_signed(y,32));
    d_out <= d_outx32768(16 downto 1);
    sclk_rising <=  sclk_del and not sclk_del2;
end behavior;


