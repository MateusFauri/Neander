library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    Port(
        clock           :   in  std_logic; 
        reset           :   in  std_logic;

        cargaPc         :   in  std_logic;
        incrementaPc    :   in  std_logic;
        cargaRem        :   in  std_logic;
        dadoSaidaMemoria :   in  std_logic_vector(7 downto 0);
        cargaRi         :   in  std_logic;
        selUla          :   in std_logic_vector(2 downto 0);
        cargaAc         :   in  std_logic;
        cargaNz         :   in  std_logic;
        selMuxPc        :   in  std_logic;

        acumulador      :   out std_logic_vector(7 downto 0);

        n               :   out  std_logic;
        z               :   out  std_logic;
        endereco        :   out std_logic_vector(7 downto 0);
        instrucao       :   out std_logic_vector(3 downto 0)
);
end datapath;

architecture behav of datapath is

    signal dadoSaidaPc      :   std_logic_vector(7 downto 0);
    signal regRem           :   std_logic_vector(7 downto 0);
    signal muxPc            :   std_logic_vector(7 downto 0);
    signal regAcumulador       :   std_logic_vector(7 downto 0);
    signal regRi            :   std_logic_vector(3 downto 0);
    signal dadoSaidaUla     :   std_logic_vector(7 downto 0);

begin

    process(clock, reset)
    begin
        if reset = '1' then
            dadoSaidaPc <= (others => '0');
        elsif rising_edge(clock) then
            if cargaPc = '1' then
                if incrementaPc = '1' then
                    dadoSaidaPc <= std_logic_vector(unsigned(dadoSaidaPc) + 1);
                else
                    dadoSaidaPc <= dadoSaidaMemoria;
                end if;
            else
                dadoSaidaPc <= dadoSaidaPc;
            end if;
        end if;
    end process;

    process(dadoSaidaPc, dadoSaidaMemoria, selMuxPc)
    begin
        case selMuxPc is
            when '0' => muxPc <= dadoSaidaPc;
            when '1' => muxPc <= dadoSaidaMemoria;
            when others => muxPc <= dadoSaidaPc;
        end case;
    end process;

    process(clock, reset)
    begin
        if reset = '1' then
            regRem <= (others => '0');
        elsif rising_edge(clock) then
            if cargaRem = '1' then
                regRem <= muxPc;
            else
                regRem <= regRem;
            end if;
        end if;
    end process;
    endereco <= regRem;

    process(clock, reset)
    begin
        if reset = '1' then
            regRi <= (others => '0');
        elsif rising_edge(clock) then
            if cargaRi = '1' then
                regRi <= dadoSaidaMemoria(7 downto 4);
            else
                regRi <= regRi;
            end if;
        end if;
    end process;
    instrucao <= regRi;

    process (selUla, dadoSaidaMemoria, regAcumulador )
    begin   
        case selUla is
            when  "000" => dadoSaidaUla <= std_logic_vector(unsigned(dadoSaidaMemoria) + unsigned(regAcumulador));
            when  "001" => dadoSaidaUla <= dadoSaidaMemoria AND regAcumulador;
            when  "010" => dadoSaidaUla <= dadoSaidaMemoria OR regAcumulador;      
            when  "011" => dadoSaidaUla <= NOT regAcumulador;           --NOT
            when  "100" => dadoSaidaUla <= dadoSaidaMemoria;               --LDA
            when others => dadoSaidaUla <= (others => '0');
        end case;
    end process;

    process(clock, reset)
    begin
        if reset = '1' then
            regAcumulador <= (others => '0');
        elsif rising_edge(clock) then
            if cargaAc = '1' then
                regAcumulador <= dadoSaidaUla;
            else
                regAcumulador <= regAcumulador;
            end if;
        end if;
    end process;
    acumulador <= regAcumulador;

    process (cargaNz, dadoSaidaUla)
    begin 
        if cargaNz = '1' then
            n <= dadoSaidaUla(7);
            if dadoSaidaUla = "00000000" then
                z <= '1';
            else
                z <= '0'; 
            end if;
        end if;
    end process;

end behav;

