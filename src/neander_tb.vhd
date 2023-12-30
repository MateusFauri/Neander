library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity neander_tb is
end;

architecture bench of neander_tb is

  component neander
      Port(
          clock           :   in  std_logic;
          reset           :   in  std_logic;
          switches	    :   in 	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
          endereco_s  :   out std_logic_vector(7 downto 0);
          flip_n_s           :  out   std_logic;
          flip_z_s           :  out   std_logic;
          dado_entrada_mem_s :  out   std_logic_vector(7 downto 0);
          dado_saida_mem_s   :  out   std_logic_vector(7 downto 0);
          instrucao8bits_s   :  out   std_logic_vector(3 downto 0);
          instrucao_s        :  out   std_logic_vector(10 downto 0);
          seg_leds 		:   out 	STD_LOGIC_VECTOR(6 downto 0);
          an 				:   out 	STD_LOGIC_VECTOR(3 downto 0);
          dp 				:   out 	STD_LOGIC;
          saida           :   out std_logic_vector(7 downto 0)
      );
  end component;

  signal clock: std_logic;
  signal reset: std_logic;
  signal switches: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal endereco_s: std_logic_vector(7 downto 0);
  signal flip_n_s: std_logic;
  signal flip_z_s: std_logic;
  signal dado_entrada_mem_s: std_logic_vector(7 downto 0);
  signal dado_saida_mem_s: std_logic_vector(7 downto 0);
  signal instrucao8bits_s: std_logic_vector(3 downto 0);
  signal instrucao_s: std_logic_vector(10 downto 0);
  signal seg_leds: STD_LOGIC_VECTOR(6 downto 0);
  signal an: STD_LOGIC_VECTOR(3 downto 0);
  signal dp: STD_LOGIC;
  signal saida: std_logic_vector(7 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: neander port map ( clock              => clock,
                          reset              => reset,
                          switches           => switches,
                          endereco_s         => endereco_s,
                          flip_n_s           => flip_n_s,
                          flip_z_s           => flip_z_s,
                          dado_entrada_mem_s => dado_entrada_mem_s,
                          dado_saida_mem_s   => dado_saida_mem_s,
                          instrucao8bits_s   => instrucao8bits_s,
                          instrucao_s        => instrucao_s,
                          seg_leds           => seg_leds,
                          an                 => an,
                          dp                 => dp,
                          saida              => saida );

  stimulus: process
  begin
  
    -- Put initialisation code here

    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;