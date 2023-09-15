


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity TB_DCC_Bit_1 is

end TB_DCC_Bit_1;

architecture Simu of TB_DCC_Bit_1 is
--Inputs
signal Reset : std_logic := '0';
signal Go_1: std_logic := '0';
signal Clk_100MHz: std_logic := '0';
signal Clk_1MHz: std_logic := '0';
--Outputs
signal Fin_DCC_1: std_logic;
signal DCC_1: std_logic;
begin
-- Instantiate the Unit Under Test (UUT)
label1: entity work.dcc_bit_1 PORT MAP (
Reset => Reset,
Clk_100MHz => Clk_100MHz,
Clk_1MHz => Clk_1MHz,
Go_1 => Go_1,
FIN_DCC_1 => FIN_DCC_1,
DCC_1 => DCC_1);
-- Evolution des Entrees
Reset <= '0' after 5 ns, '1' after 10 ns;

Clk_100MHz <= not Clk_100MHz after 5 ns;
Clk_1MHz <= not Clk_1MHz after 500 ns;

GO_1 <= '1' after 100 us , '0' after 150 us,'1' after 400 us, '0' after 450 us;
end Simu;
