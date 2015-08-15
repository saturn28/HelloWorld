--------------------------------------------------------------------------------
-- adder.vhd
-- JDC
-- Date 8/9/15
--------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;                  
use IEEE.std_logic_signed.all;

entity adder is
    port (
        en          : in    std_logic;
        sum         : out   integer;
        a           : in    integer;
        b           : in    integer
    );
end adder;

architecture BEHAVIOR of adder is
begin
    addition : process (en,a,b) begin
        if (en = '1') then
            sum <=  a + b;
        end if;
    end process;
end BEHAVIOR;