library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAE_TB is
end MAE_TB;

architecture Behavioral of MAE_TB is

    -- D�claration des signaux de test
    signal CLK_100MHz : std_logic := '0';
    signal Reset : std_logic := '1';
    signal Bit_DCC: std_logic := '1';
    signal FIN_DCC_0 : std_logic := '0';
    signal FIN_DCC_1 : std_logic := '0';
    signal FIN_TEMPO : std_logic := '0';
    signal COM_REG : std_logic_vector(1 downto 0);
    signal GO_0 : std_logic;
    signal GO_1 : std_logic;
    signal Start_TEMPO : std_logic;
    
    
begin

    -- Instanciation de la MAE
    uut: entity work.MAE
        port map (
            CLK_100MHz => CLK_100MHz,
            Reset => Reset,
            Bit_DCC => Bit_DCC,
            FIN_DCC_0 => FIN_DCC_0,
            FIN_DCC_1 => FIN_DCC_1,
            FIN_TEMPO => FIN_TEMPO,
            COM_REG => COM_REG,
            GO_0 => GO_0,
            GO_1 => GO_1,
            Start_TEMPO => Start_TEMPO
        );

    -- G�n�ration de l'horloge
    process
    begin
        while (true) loop
            CLK_100MHz <= not CLK_100MHz;
            wait for 5 ns;
        end loop;
    end process;

    -- G�n�ration d'une impulsion de reset
    process
    begin
        Reset <= '0';
        wait for 10 ns;
        Reset <= '1';
        wait;
    end process;

    -- Envoi de bits dans la machine � �tat
    process
    begin
    while (true) loop
        wait for 10 ns;
        Bit_DCC <= '0';
        wait for 50 ns;
        Bit_DCC <= '1';
        wait;
    end loop;
    end process;

    -- Simulation des signaux FIN_0 et FIN_1
    process
    begin
    while (true) loop
        wait for 40 ns;
        FIN_DCC_0 <= '1';
        wait for 20 ns;
        FIN_DCC_0 <= '0';
        wait for 20 ns;
        FIN_DCC_1 <= '1';
        wait;
    end loop;
    end process;

    -- Simulation du signal FIN_TEMPO
    process
    begin
    while (true) loop    
        wait for 15 ns;
        FIN_TEMPO <= '1';
        wait for 10 ns;
        FIN_TEMPO <= '0';
        wait for 15 ns;
        FIN_TEMPO <= '1';
        wait for 10 ns;
        FIN_TEMPO <= '0';
        wait;
        
    end loop;
    end process;


end Behavioral;