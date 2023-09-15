----------------------------------------------------------------------------------
-- Company: Sorbonne Universite
-- Engineer: Adnane ALLOU
-- 
-- Create Date: 21.03.2023 11:54:33
-- Design Name: CENTRAL DCC
-- Module Name: DCC_BIT_1 - Behavioral
-- Project Name: Mini Projet Commande de trains
-- Target Devices: basys3
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
entity DCC_BIT_1 is
    Port (      -- Entrées
                clk_1MHz    : in std_logic;
                clk_100MHz  : in std_logic;
                reset       : in std_logic;
                GO_1        : in std_logic;
                
                --Sorties
                FIN_DCC_1       : out std_logic;
                DCC_1           : out std_logic);
end DCC_BIT_1;

architecture Behavioral of DCC_BIT_1 is
type Etat is ( Init, Signal_LOW, R_edge, Signal_HIGH, F_edge);  -- Type Etat (Init : Initialisation, Signal_LOW : Etat bas du signal, R_edge : Front montant, ...)
signal EP, EF : etat;                                           -- EP et EF de type Etat (EP : Etat Présent, EF : Etat Future)
signal cpt : std_logic_vector(6 downto 0) :=(others => '0');    -- Compteur sur 7 Bits initialisé à 0
signal raz_cpt : std_logic;                                     -- Reset_Compteur 
signal inc_cpt : std_logic;                                     -- Incrémentation du compteur

begin

-- Porcess des registre 
process(clk_100MHz, reset)
begin
if reset = '0' then EP <= Init;                                -- Reset = '0' alors EP <= Init
elsif rising_edge(clk_100MHz) then EP <= EF;                   -- Sinon au front d'horloge EP <= EF
end if;
end process;

-- Combinatoire des etats
process(EP, GO_1, cpt)
begin
    case (EP) is
        when Init        => EF <= Init; if Go_1 = '1' then EF <= Signal_LOW; end if;    -- Lorsque EP = Init, EF <= Signal_LOW si Go_1 = '1' Sinon on reste en Init
        when Signal_LOW  => EF <= Signal_LOW; if cpt = 58 then EF <= R_edge; end if;    -- Lorsque EP = Signal_Low, EF <= R_edge si Cpt = 58 Sinon on reste en Signal_LOW   
        when R_edge      => EF <= Signal_HIGH;                                          -- Lorsque EP = R_edge, EF <= Signal_HIGH sans condition
        when Signal_HIGH => EF <= Signal_HIGH; if cpt = 58 then EF <= F_edge; end if;   -- Lorsque EP = Signal_HIGH, EF <= F_edge si Cpt = 58 Sinon on reste en Signal_HIGH
        when F_edge      => EF <= Init;                                                 -- Lorsque EP = F_edge, EF <= Init sans condition
    end case;
end process;

-- Combinatoire des sorties 
process (EP)
begin 
    case (EP) is 
        when Init        => raz_cpt <= '1'; DCC_1 <= '0'; inc_cpt <= '0'; FIN_DCC_1 <= '0';  -- Lorsque EP = Init, Compteur <= 0 (Reset)
        when Signal_LOW  => raz_cpt <= '0'; DCC_1 <= '0'; inc_cpt <= '1'; FIN_DCC_1 <= '0';  -- Lorsque EP = Signal_Low, Incrémentation du compteur Signal de sortie à l'état bas
        when R_edge      => raz_cpt <= '1'; DCC_1 <= '0'; inc_cpt <= '0'; FIN_DCC_1 <= '0';  -- Lorsque EP = R_edge, Init, Compteur <= 0 (Reset), Signal de sortie à l'état bas
        when Signal_HIGH => raz_cpt <= '0'; DCC_1 <= '1'; inc_cpt <= '1'; FIN_DCC_1 <= '0';  -- Lorsque EP = Signal_HIGH, Incrémentation du compteur Signal de sortie à l'état Haut
        when F_edge      => raz_cpt <= '0'; DCC_1 <= '1'; inc_cpt <= '0'; FIN_DCC_1 <= '1';  -- Lorsque EP = F_edge, Signal de sortie à l'état Haut, Génération du Signal FIN_DCC_1
    end case;
end process;

-- Compteur 58us
process(clk_1MHz, raz_cpt, inc_cpt, cpt)
begin
if raz_cpt = '1' then cpt <= (others => '0');   -- Reset graçe raz_cpt
elsif rising_edge(clk_1MHz) then 
    if (cpt > 60) 
        then cpt <= (others => '0');            -- Mise à zero de securité (Anti débordement)
    elsif (inc_cpt = '1') then
        cpt <= cpt +1;                          -- Incrémentation 
    end if;
end if;
end process;
end Behavioral;

