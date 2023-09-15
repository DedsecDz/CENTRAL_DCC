library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity DCC_FRAME_GENERATOR_TB is
end DCC_FRAME_GENERATOR_TB;

architecture Behavioral of DCC_FRAME_GENERATOR_TB is

    -- Signal de l'horloge
    signal clk : std_logic := '0';
    constant clk_period : time := 10 ns;

    -- Signaux des ports de l'entit� DCC_FRAME_GENERATOR
    signal Interrupteur : std_logic_vector(7 downto 0);
    signal Trame_DCC : std_logic_vector(50 downto 0);

    -- Instance de DCC_FRAME_GENERATOR
    component DCC_FRAME_GENERATOR is
        Port ( Interrupteur	: in STD_LOGIC_VECTOR(7 downto 0);
               Trame_DCC 	: out STD_LOGIC_VECTOR(50 downto 0));
    end component;
begin
    -- Horloge
process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
            wait;
        end loop;
    end process;



    -- Instanciation de DCC_FRAME_GENERATOR
    uut : DCC_FRAME_GENERATOR 
    port map (
        Interrupteur => Interrupteur,
        Trame_DCC => Trame_DCC
    );

    -- Processus de test
    process
    begin

        -- Configuration d'interrupteurs � tester
        for i in 0 to 7 loop

            -- Attente de 2 p�riodes d'horloge
            wait for 2 * clk_period;
            Interrupteur <= "00000001";
          

            -- V�rification de la trame g�n�r�e
            case i is
                when 7 =>
                    
                    assert Trame_DCC = "111111111111111111111110000100000000100110001111" report "Erreur pour Interrupteur(7)" severity error;
                when 6 =>
                    Interrupteur <= "01000000";
                    assert Trame_DCC = "111111111111111111111110000100000000100100001110" report "Erreur pour Interrupteur(6)" severity error;
                when 5 =>
                    Interrupteur <= "00100000";
                    assert Trame_DCC = "111111111111111111111110100100000100000001000010" report "Erreur pour Interrupteur(5)" severity error;
                when 4 =>
                    Interrupteur <= "00010000";
                    assert Trame_DCC = "111111111111111111111110100000000100000001000011" report "Erreur pour Interrupteur(4)" severity error;
                when 3 =>
                    Interrupteur <= "00001000";
                    assert Trame_DCC = "1111111111111111111111101010010000100000000100010" report "Erreur pour Interrupteur(3)" severity error;
                when 2 =>
                    Interrupteur <= "00000100";
                    assert Trame_DCC = "1111111111111111111111101010010000100000000100010"report "Erreur pour Interrupteur(2)" severity error;
                when 1 =>
                    Interrupteur <= "00000010";
                    assert Trame_DCC = "111111111111111111111111111000000001000110111011" report "Erreur pour Interrupteur(1)" severity error;
                when 0 =>
                    Interrupteur <= "00000001";
                    assert Trame_DCC = "111111111111111111111111111000000001000100111010" report "Erreur pour Interrupteur(0)" severity error;
            end case;
        end loop;
        end process;
end Behavioral; 
