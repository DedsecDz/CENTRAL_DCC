----------------------------------------------------------------------------------
-- Company: Srobonne Universite 
-- Engineer: Adnane ALLOU
-- 
-- Create Date: 21.03.2023 12:20:49
-- Design Name: 
-- Module Name: TestB_DCC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity TB_DCC_Bit_0 is

end TB_DCC_Bit_0;

architecture Simu of TB_DCC_Bit_0 is
--Inputs
signal Reset : std_logic := '0';
signal Go_0: std_logic := '0';
signal Clk_100MHz: std_logic := '0';
signal Clk_1MHz: std_logic := '0';
--Outputs
signal Fin_DCC_0: std_logic;
signal DCC_0: std_logic;
begin
-- Instantiate the Unit Under Test (UUT)
label1: entity work.dcc_bit_0 PORT MAP (
Reset => Reset,
Clk_100MHz => Clk_100MHz,
Clk_1MHz => Clk_1MHz,
Go_0 => Go_0,
FIN_DCC_0 => FIN_DCC_0,
DCC_0 => DCC_0);
-- Evolution des Entrees
Reset <= '0' after 5 ns, '1' after 10 ns;

Clk_100MHz <= not Clk_100MHz after 5 ns;
Clk_1MHz <= not Clk_1MHz after 500 ns;

GO_0 <= '1' after 20 us , '0' after 30 us,'1' after 120 us, '0' after 130 us;
end Simu;