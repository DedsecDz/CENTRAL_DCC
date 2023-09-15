----------------------------------------------------------------------------------
-- Company: Sorbonne Universite
-- Engineer: ALLOU Adnane
-- 
-- Create Date: 27.03.2023 18:23:05
-- Design Name: CENTRAL DCC
-- Module Name: REGISTRE_DCC - Behavioral
-- Project Name: Mini Projet Commande de trains
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

-- Déclaration des signaux In / Out
entity REGISTRE_DCC is
    Port (  -- Entrées
            CLK_100MHz : in STD_LOGIC;
            Reset : in STD_LOGIC;
            TRAME_DCC : in STD_LOGIC_VECTOR (50 downto 0);
            COM_REG : in std_logic_vector(1 downto 0);

            -- Sorties
            Bit_DCC : out STD_LOGIC);
end REGISTRE_DCC;

architecture Behavioral of REGISTRE_DCC is

    constant TRAME_DCC_TAILLE : integer := 51;                          -- Taille de la trame = 51 Bits
    signal TRAME : std_logic_vector((TRAME_DCC_TAILLE-1) downto 0);     -- Signal TRAME de 51 Bits

begin

    process(CLK_100MHz, Reset)
    begin
        if Reset = '0' then 
            TRAME <= (others => '0');                               -- Trame <= "00..0" au reset

        elsif rising_edge(CLK_100MHz) then                          -- Sinon a chaque front CLK
            if COM_REG = "01" then 
                TRAME(50 downto 0) <= TRAME(49 downto 0) & '1';     -- Si COM_REG = "01" alors décalage de TRAME de 1 Bits vers la gauche 
        
             elsif COM_REG(1) = "1" then                            -- Si COM_RE = "1X" alors Chargement Parallèle de la TRAME 
                TRAME <= TRAME_DCC;
             else 
                TRAME <= TRAME;                                     -- Autre alors TRAME <= TRAME
            end if;
            

        end if;
        
    end process;

-- Sortie 
Bit_DCC <= TRAME(50);                                              -- On recpére le dernier Bit en sortie
end Behavioral;