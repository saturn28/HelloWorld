--------------------------------------------------------------------------------
-- shiftnmult.vhd
-- 
-- Date 8/9/15                                                                    
--------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;                  
use IEEE.std_logic_signed.all;

entity shiftnmult is
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
end shiftnmult;

architecture BEHAVIOR of shiftnmult is
begin
    SHMULT :  process(clk, reset_n) begin
        if (reset_n = '0') then
            temp <= 0;
            zout <= 0;
        elsif (clk'event and clk = '1' and valid = '1' and en_shift = '1') then
            zout <= zin;
            temp <= zin * coeff;
        end if;
    end process;
end BEHAVIOR;


