library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity placa is
    Port ( 
			clock, reset 	: in    STD_LOGIC;
			leitura_mem		: in 	std_logic_vector(7 downto 0) := (others => '0');
			switch			: in 	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			seg 			: out 	STD_LOGIC_VECTOR(6 downto 0);
			an 				: out 	STD_LOGIC_VECTOR(3 downto 0);
			dp 				: out 	STD_LOGIC);
end placa;

architecture Behavioral of placa is

type states is (s0, s1, s2,s3);
signal state : states;
signal contador : STD_LOGIC_VECTOR(10 downto 0);
signal led_leitura : STD_LOGIC_VECTOR(3 downto 0);

begin

process (clock)
begin
	if rising_edge(clock) then
		contador <= std_logic_vector(unsigned(contador) + 1);
	end if;
end process;

process (contador(10), reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif rising_edge(contador(10)) then
			CASE state IS
				WHEN s0 =>  
					state <= s1;
					an <=  "1110";
					dp <= '1';	
					led_leitura  <= switch(7 downto 4);
				WHEN s1 =>	
					state <= s2;
					an <= "1101";
					dp <= '1';
					led_leitura  <= switch(3 downto 0);
				WHEN s2 =>  
					state <= s3;
					an <= "1011";
					dp <= '1';
					led_leitura  <= leitura_mem(7 downto 4);
				WHEN s3 => 	
					state <= s0;
					an <= "0111";
					dp <= '1';
					led_leitura  <= leitura_mem(3 downto 0);
			end CASE;
		end if;
	end process;

	process(led_leitura)
	begin
		CASE led_leitura IS
			when "0000" => seg <="0000001"; -- '0'
			when "0001" => seg <="1001111"; -- '1'
			when "0010" => seg <="0010010"; -- '2'
			when "0011" => seg <="0000110"; -- '3'
			when "0100" => seg <="1001100"; -- '4'
			when "0101" => seg <="0100100" ; -- '5'
			when "0110" => seg <="0100000" ; -- '6'
			when "0111" => seg <="0001111" ; -- '7'
			when "1000" => seg <="0000000"; -- '8'
			when "1001" => seg <="0000100" ; -- '9'
			when "1010" => seg <="0001000" ; -- 'A'
			when "1011" => seg <="1100000" ; -- 'B'
			when "1100" => seg <="0110001" ; -- 'C'
			when "1101" => seg <="1000010" ; -- 'D'
			when "1110" => seg <="0110000" ; -- 'E'
			when "1111" => seg <="0111000" ; -- 'F'
			when others => seg <= "1111111" ;
			end CASE;
	end process;


end Behavioral;

