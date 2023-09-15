----------------------------------------------------------------------------------
-- Company: Srobonne Universite 
-- Engineer: Adnane ALLOU
-- 
-- Create Date: 18.04.2023 09:09:00
-- Design Name: 
-- Module Name: TB_TOP_Centrale - Behavioral
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

entity TB_TOP_Centrale is
--  Port ( );
end TB_TOP_Centrale;

architecture sim of TB_TOP_Centrale is

  -- D�claration des signaux de test
  signal CLK_100MHz : std_logic := '0';
  signal Reset      : std_logic := '0';
  signal Interrupteur : std_logic_vector(7 downto 0) := (others => '0');
  signal Sortie_DCC : std_logic;

begin

  -- Instanciation de la DUT (Design Under Test)
  DUT : entity work.TOP_Centrale
    port map (
      CLK_100MHz => CLK_100MHz,
      Reset => Reset,
      Interrupteur => Interrupteur,
      Sortie_DCC => Sortie_DCC
    );

  -- G�n�ration de l'horloge
  process
  begin
    while now < 150 ms loop
      CLK_100MHz <= '0';
      wait for 5 ns;
      CLK_100MHz <= '1';
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- G�n�ration d'une impulsion de reset
  process
  begin
    Reset <= '0';
    wait for 15 ns;
    Reset <= '1';
    wait;
  end process;

  -- Simulation des interruptions des interrupteurs
  process
  begin
    Interrupteur <= "00000000";
    wait for 30 ms;
    Interrupteur <= "00000010";
    wait for 15 ms;
    Interrupteur <= "00000100";
    wait for 15 ms;
    Interrupteur <= "00001000";
    wait for 15 ms;
    Interrupteur <= "10000000";
    wait for 15 ms;
    Interrupteur <= "00000001";
    wait for 15 ms;
    Interrupteur <= "01000000";
    wait for 15 ms;
    Interrupteur <= "00100000";
    wait for 10 ms;
    wait;
  end process;

  -- V�rification de la sortie
  

end sim;

