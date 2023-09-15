----------------------------------------------------------------------------------
-- Company: Sorbonne Universite
-- Engineer: ALLOU Adnane
-- 
-- Create Date: 29.03.2023 23:59:32
-- Design Name: 
-- Module Name: TOP_DCC - Behavioral
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

entity TOP_Centrale is
  port (
        -- Signaux In
        CLK_100MHz       : in std_logic;
        Reset            : in std_logic;
        TRAME_DCC        : in std_logic_vector(50 downto 0); -- en entrée de l'IP

        -- Signaux Out
        Sortie_DCC       : out std_logic                     -- en sortie de l'IP
  );
end TOP_Centrale;

architecture Behavioral of TOP_Centrale is
  -- D�claration des signaux internes du syst�me

        -- CLK_DIV
        Signal CLK_1MHz : std_logic;

        -- TEMPO
        Signal Start_TEMPO : std_logic;
        Signal FIN_TEMPO   : std_logic;

        -- DCC BIT 1/0
        Signal GO_0, FIN_DCC_0, DCC_0 : std_logic;
        Signal GO_1, FIN_DCC_1, DCC_1 : std_logic;
        

        -- Registre DCC
        Signal BIT_DCC : std_logic;
        Signal COM_REG : std_logic_vector(1 downto 0);
        



  -- Instanciation des deux modules
    component CLK_DIV 
        Port ( Reset 	: in STD_LOGIC;		-- Reset Asynchrone
           Clk_In 	: in STD_LOGIC;		-- Horloge 100 MHz de la carte Nexys
           Clk_Out 	: out STD_LOGIC);	-- Horloge 1 MHz de sortie
        end component;

    component COMPTEUR_TEMPO 
        Port ( Clk 			: in STD_LOGIC;		-- Horloge 100 MHz
           Reset 		: in STD_LOGIC;		-- Reset Asynchrone
           Clk1M 		: in STD_LOGIC;		-- Horloge 1 MHz
           Start_Tempo	: in STD_LOGIC;		-- Commande de D�marrage de la Temporisation
           Fin_Tempo	: out STD_LOGIC		-- Drapeau de Fin de la Temporisation
	    	);
        end component;

    component DCC_BIT_0 
        Port (  clk_1MHz    : in std_logic;
            clk_100MHz  : in std_logic;
            reset       : in std_logic;
            GO_0        : in std_logic;
            FIN_DCC_0       : out std_logic;
            DCC_0       : out std_logic);
        end component;
    
    component DCC_BIT_1 
        Port (  clk_1MHz    : in std_logic;
            clk_100MHz  : in std_logic;
            reset       : in std_logic;
            GO_1        : in std_logic;
            FIN_DCC_1       : out std_logic;
            DCC_1       : out std_logic);
        end component;
    
    component MAE 
        Port ( -- In
           CLK_100MHz : in STD_LOGIC;
           Reset   : in STD_LOGIC;
           BIT_DCC : in STD_LOGIC;
           FIN_DCC_0   : in STD_LOGIC;
           FIN_DCC_1 : in STD_LOGIC;
           FIN_TEMPO : in STD_LOGIC;
           -- Out
           COM_REG : out STD_LOGIC_vector(1 downto 0);
           GO_0 : out STD_LOGIC;
           GO_1 : out STD_LOGIC;
           Start_TEMPO : out STD_LOGIC);
        end component;

    component REGISTRE_DCC 
        Port ( CLK_100MHz : in STD_LOGIC;
           Reset : in STD_LOGIC;
           TRAME_DCC : in STD_LOGIC_VECTOR (50 downto 0);
           COM_REG : in STD_LOGIC_vector(1 downto 0);
           Bit_DCC : out STD_LOGIC);
        end component;



begin
  -- Instanciation des deux modules
  clk_div_inst      : CLK_DIV port map (reset => reset, Clk_In => CLK_100MHz, Clk_Out => CLK_1MHz);
  TEMPO_inst        : COMPTEUR_TEMPO port map (CLK => CLK_100MHz, Reset => Reset, Clk1M => CLK_1MHz, Start_TEMPO => Start_TEMPO, FIN_TEMPO => FIN_TEMPO);
  DCC_0_inst        : DCC_BIT_0 port map (CLK_100MHz => CLK_100MHz, CLK_1MHz => clk_1MHz, reset => reset, GO_0 => GO_0, FIN_DCC_0 => FIN_DCC_0, DCC_0 => DCC_0);
  DCC_1_inst        : DCC_BIT_1 port map (CLK_100MHz => CLK_100MHz, CLK_1MHz => clk_1MHz, reset => reset, GO_1 => GO_1, FIN_DCC_1 => FIN_DCC_1, DCC_1 => DCC_1);
  REGISTRE_DCC_inst : REGISTRE_DCC port map (CLK_100MHz => CLK_100MHz, Reset => Reset, TRAME_DCC => TRAME_DCC, COM_REG => COM_REG, BIT_DCC => BIT_DCC);
  MAE_inst          : MAE port map (CLK_100MHz => CLK_100MHz, Reset => Reset, BIT_DCC => BIT_DCC, FIN_DCC_0 => FIN_DCC_0, FIN_DCC_1 => FIN_DCC_1, FIN_TEMPO => Fin_Tempo, COM_REG => COM_REG, GO_0 => GO_0, GO_1 => GO_1, Start_TEMPO => Start_TEMPO);

  -- Connexion des signaux internes aux sorties du syst�me
  Sortie_DCC <= (DCC_0 or DCC_1);

end Behavioral;