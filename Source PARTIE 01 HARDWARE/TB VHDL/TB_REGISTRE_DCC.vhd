----------------------------------------------------------------------------------
-- Company: Srobonne Universite 
-- Engineer: Adnane ALLOU
-- 
-- Create Date: 29.03.2023 21:30:52
-- Design Name: 
-- Module Name: TB_REGISTRE_DCC - Behavioral
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

entity TB_REGISTRE_DCC is
end TB_REGISTRE_DCC;

architecture Behavioral of TB_REGISTRE_DCC is
    -- Component declaration for the unit under test (UUT)
    component REGISTRE_DCC
    Port ( CLK_100MHz : in STD_LOGIC;
           Reset : in STD_LOGIC;
           TRAME_DCC : in STD_LOGIC_VECTOR (50 downto 0);
           COM_REG : in std_logic_vector(1 downto 0);
           Bit_DCC : out STD_LOGIC);
    end component;

    -- Clock period constant declaration
    constant PERIOD : time := 10 ns;

    -- Inputs
    signal CLK_100MHz : STD_LOGIC := '0';
    signal Reset : STD_LOGIC := '0';
    signal TRAME_DCC : STD_LOGIC_VECTOR (50 downto 0) :="011111111111110101000110101001010100000010111101011";
    signal COM_REG : std_logic_vector(1 downto 0) := "00";

    -- Outputs
    signal Bit_DCC : STD_LOGIC;

begin
    -- Instantiate the unit under test (UUT)
    uut: REGISTRE_DCC port map (
        CLK_100MHz => CLK_100MHz,
        Reset => Reset,
        TRAME_DCC => TRAME_DCC,
        COM_REG => COM_REG,
        Bit_DCC => Bit_DCC
    );

    -- Clock process definitions
    CLK_100MHz_process :process
    begin
        CLK_100MHz <= '0';
        wait for PERIOD/2;
        CLK_100MHz <= '1';
        wait for PERIOD/2;
    end process;

 -- Simu
 
        -- Reset the module
        Reset <= '0' after 5 ns, '1' after 10 ns;
        
        -- Set the input values
        COM_REG <= "11" after 25 ns, "01" after 40 ns; 
    
        
 -- End the test

end Behavioral;

