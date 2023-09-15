library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DCC_FRAME_GENERATOR is
    Port ( CLK_100MHz : in std_logic;
           Commandes	: in STD_LOGIC_VECTOR(14 downto 0);	-- Interrupteurs de la Carte ( Switch)
           Button_validation : in std_logic;								    -- Bouton Centrale
           Trame_DCC 	: out STD_LOGIC_VECTOR(50 downto 0);					-- Trame DCC de Test
           LEDs         : out std_logic_vector(14 downto 0));				
end DCC_FRAME_GENERATOR;

architecture Behavioral of DCC_FRAME_GENERATOR is
constant Preambule14 : std_logic_vector(13 downto 0) := "11111111111111";
constant Preambule23 : std_logic_vector(22 downto 0) := "11111111111111111111111";
constant  champs_comandes16bits : std_logic_vector (7 downto 0) := "11011110";
constant start_bit : std_logic:= '0';

constant stop_bit : std_logic:= '1';

signal  Adresse_DCC : std_logic_vector(7 downto 0) := "00000010" ; -- depart train 02
signal Com : std_logic_vector (7 downto 0) := (others => '0');

signal Trame_DCC_p 	: STD_LOGIC_VECTOR(50 downto 0):= (others => '0');


begin

Com <= Commandes(13 downto 6);
Adresse_DCC <= "00" & Commandes(5 downto 0);

 Trame_DCC <=  Trame_DCC_p;



process(CLK_100MHz, Button_validation)

begin 
if rising_edge (CLK_100MHz) then
if Button_validation = '1' then 										   -- On valide la Trame avec le bouton centrale
LEDs <= commandes(14) & com & Adresse_DCC(5 downto 0);  

if commandes(14) = '0' then 												-- On choisi d'envoyer une TRAME 1 oct et 2 oct avec le switch 14
    Trame_DCC_p <=    Preambule23 				-- Pr�ambule 23 bits
					& start_bit				-- Start Bit
					& Adresse_DCC				-- Champ Adresse
					& start_bit				-- Start Bit
					& Com				-- Champ Commande
					& start_bit				-- Start Bit
					& (adresse_DCC XOR Com)				-- Champ Contr�le
					& stop_bit	;			-- Stop Bit

else
    Trame_DCC_p <= Preambule14				        -- Pr�ambule 14 bits
					& start_bit				        -- Start Bit
					& Adresse_DCC			        -- Champ Adresse
					& start_bit				        -- Start Bit
					& champs_comandes16bits			-- Champ Commande (Octet 1)
					& start_bit				        -- Start Bit
					& Com    				    -- Champ Commande (Octet 2)
					& start_bit				        -- Start Bit
					& (adresse_DCC XOR champs_comandes16bits XOR Com) 				-- Champ Controle
					& stop_bit	;			-- Stop Bit
    
 end if;
 end if;
 end if;
 end process;
 

-- G�n�ration d'une Trame selon l'Interrupteur Tir� vers le Haut
-- Si Plusieurs Interupteurs Sont Tir�s, Celui de Gauche Est Prioritaire

-- Compl�ter les Trames pour R�aliser les Tests Voulus

--process(Interrupteur)
--begin

	
--	-- Interrupteur 7 Activ�
--		--> Trame Marche Avant du Train d'Adresse i
--	if Interrupteur(7)='1' then
	
--		Trame_DCC <= Preambule23 				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC				-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "01"&'1'&"01111"				-- Champ Commande
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "01101111")				-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit

--	-- Interrupteur 6 Activ�
--		--> Trame Marche Arri�re du Train d'Adresse i
--	elsif Interrupteur(6)='1' then
	
--		Trame_DCC <= Preambule23				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC				-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "01"&'0'&"01111"					-- Champ Commande
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "01001111") 				-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit


--	-- Interrupteur 5 Activ�
--		--> Allumage des Phares du Train d'Adresse i
--	elsif Interrupteur(5)='1' then
	
--		Trame_DCC <= Preambule23				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC				-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "100"&"10000"				-- Champ Commande
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "10010000")				-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit

--	-- Interrupteur 4 Activ�
--		--> Extinction des Phares du Train d'Adresse i
--	elsif Interrupteur(4)='1' then
	
--		Trame_DCC <= Preambule23				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC			-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "100"&"00000"					-- Champ Commande
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "10000000")	 -- Champ Contr�le
--					& stop_bit	;			-- Stop Bit

--	-- Interrupteur 3 Activ�
--		--> Activation du Klaxon (Fonction F11) du Train d'Adresse i
--	elsif Interrupteur(3)='1' then
	
--		Trame_DCC <= Preambule23				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC				-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "1010"&"0100"				-- Champ Commande
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "10100100")					-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit

--	-- Interrupteur 2 Activ�
--		--> R�amor�age du Klaxon (Fonction F11) du Train d'Adresse i
--	elsif Interrupteur(2)='1' then
	
--		Trame_DCC <= Preambule23				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC			-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "1010"&"0000"			-- Champ Commande
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "10100000")				-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit

--	-- Interrupteur 1 Activ�
--		--> Annonce SNCF (Fonction F13) du Train d'Adresse i
--	elsif Interrupteur(1)='1' then
	
--		Trame_DCC <= Preambule14				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC			-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "110"&"11110"				-- Champ Commande (Octet 1)
--					& start_bit				-- Start Bit
--					& "00000001"				-- Champ Commande (Octet 2)
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "11011110" XOR "00000001") 				-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit

--	-- Interrupteur 0 Activ�
--		--> Annonce SNCF (Fonction F13) du Train d'Adresse i
--	elsif Interrupteur(0)='1' then
	
--		Trame_DCC <= Preambule14				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC			-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "110"&"11110"				-- Champ Commande (Octet 1)
--					& start_bit				-- Start Bit
--					& "00000000"				-- Champ Commande (Octet 2)
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "11011110" XOR "00000000")				-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit

--	-- Aucun Interrupteur Activ�
--		--> Arr�t du Train d'Adresse i
--	else 
	
--		Trame_DCC <= Preambule23				-- Pr�ambule
--					& start_bit				-- Start Bit
--					& Adresse_DCC			-- Champ Adresse
--					& start_bit				-- Start Bit
--					& "00000000"				-- Champ Commande
--					& start_bit				-- Start Bit
--					& (adresse_DCC XOR "00000000")	-- Champ Contr�le
--					& stop_bit	;			-- Stop Bit
--	end if;
	
--end process;

end Behavioral;

