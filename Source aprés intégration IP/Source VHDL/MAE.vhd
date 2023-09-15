----------------------------------------------------------------------------------
-- Company: Sorbonne Univeriste 
-- Engineer: ALLOU Adnane 
-- 
-- Create Date: 28.03.2023 16:53:47
-- Design Name: CENTRAL DCC
-- Module Name: MAE - Behavioral
-- Project Name: Mini Projet Commande de trains 
-- Target Devices: Basys3
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


entity MAE is
    Port ( -- In
           CLK_100MHz : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Bit_DCC : in STD_LOGIC;
           FIN_DCC_0 : in STD_LOGIC;
           FIN_DCC_1 : in STD_LOGIC;
           FIN_TEMPO : in STD_LOGIC;
           -- Out
           COM_REG : out STD_LOGIC_VECTOR(1 downto 0);
           GO_0 : out STD_LOGIC;
           GO_1 : out STD_LOGIC;
           Start_TEMPO : out STD_LOGIC);
end MAE;

architecture Behavioral of MAE is

constant TRAME_DCC_TAILLE : integer := 51;
signal cpt_bit : INTEGER range 0 TO TRAME_DCC_TAILLE;   -- Compteur pour compter le nombre de bits reçu

type ETAT is (Start, LOAD, shift, Sending_BIT_0, Sending_BIT_1, END_Sending_BIT,Tempo); -- Type ETAT
signal EP, EF : ETAT;                                                                   -- Etat Présent & Etat Future


begin


-- Process ds registre 
process(CLK_100MHz, Reset)
begin
if reset = '0' then EP <= Start;                -- Reset = '0' alors EP <= Start
elsif rising_edge(CLK_100MHz) then EP <= EF;    -- Sinon au front d'horloge EP <= EF

end if;
end process;

-- Combinatoire des etats
process(EP, FIN_TEMPO, FIN_DCC_0, FIN_DCC_1, Bit_DCC, cpt_bit)
begin
    case (EP) is
    -- Condition de passage d'un etat à un autre 
        when Start              => EF <= LOAD;
        when LOAD               => EF <= SHIFT; 
        when SHIFT              => EF <= SHIFT; if Bit_DCC = '0' then EF <= Sending_BIT_0; elsif Bit_DCC = '1' then EF <= Sending_BIT_1; end if;
        when Sending_BIT_0      => EF <= Sending_BIT_0; if FIN_DCC_0 = '1' then EF <= END_Sending_BIT; end if;
        when Sending_BIT_1      => EF <= Sending_BIT_1; if FIN_DCC_1 = '1' then EF <= END_Sending_BIT; end if;
        when END_Sending_BIT    => EF <= END_Sending_BIT; if cpt_bit >= TRAME_DCC_TAILLE then EF <= TEMPO; else EF <= SHIFT; end if;
        when TEMPO              => EF <= TEMPO; if FIN_TEMPO = '1' then EF <= LOAD; end if; 
    end case;
end process;

-- Combinatoire des sorties 
process (EP)
begin 

    case (EP) is
        when Start              => Start_TEMPO <= '0'; COM_REG <= "00"; GO_0 <= '0'; GO_1 <= '0'; -- Initialisaton 
        when LOAD               => Start_TEMPO <= '0'; COM_REG <= "11"; GO_0 <= '0'; GO_1 <= '0'; -- Chargement Parallèle de la TRAME dans le registre à décalage 
        when SHIFT              => Start_TEMPO <= '0'; COM_REG <= "01"; GO_0 <= '0'; GO_1 <= '0'; -- Décalage du bit du poid fort 
        when Sending_BIT_0      => Start_TEMPO <= '0'; COM_REG <= "00"; GO_0 <= '1'; GO_1 <= '0'; -- Si le bit du poid fort reçu est un '0' alors on transmission d'un 0 en DCC T = 200 us
        when Sending_BIT_1      => Start_TEMPO <= '0'; COM_REG <= "00"; GO_0 <= '0'; GO_1 <= '1'; -- Si le bit du poid fort reçu est un '1' alors on transmission d'un 1 en DCC T = 116 us
        when END_Sending_BIT    => Start_TEMPO <= '0'; COM_REG <= "00"; GO_0 <= '0'; GO_1 <= '0'; -- Fin transmission
        when TEMPO              => Start_TEMPO <= '1'; COM_REG <= "00"; GO_0 <= '0'; GO_1 <= '0'; -- Temporisation de 6 us 
    end case;
end process;

-- Compteur bits
process (CLK_100MHz,reset)
begin 
    if reset = '0' then cpt_bit <= 0;
    elsif rising_edge (clk_100MHz) then 
        if EP = SHIFT then cpt_bit <= cpt_bit + 1;         -- A chaque déclage on reçois un bit alors on incrémente 
        elsif EP = TEMPO then cpt_bit <= 0;                -- A Témpo cela veux dire que la trame est fini donc remise a zero du compteur
        else cpt_bit <= cpt_bit;
        end if;
    end if;
end process;

end Behavioral;
