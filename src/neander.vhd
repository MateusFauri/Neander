library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity neander is
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
end neander;

architecture behav of neander is

    component dpbram IS
    PORT (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
	END component;

    component datapath is
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
            instrucao       :   out std_logic_vector(3 downto 0));
    end component;

    component placa is
    Port ( 
			clock, reset 	: in    STD_LOGIC;
			leitura_mem		: in 	std_logic_vector(7 downto 0) := (others => '0');
			switch			: in 	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			seg 			: out 	STD_LOGIC_VECTOR(6 downto 0);
			an 				: out 	STD_LOGIC_VECTOR(3 downto 0);
			dp 				: out 	STD_LOGIC);
    end component;

    type estados is (E0, E1,W1, E2, E3, E4,W4, E5, E6, W6, E7, W7, FF);
    signal estado  : estados;
    signal proximoEstado : estados;

    signal cargaPc : std_logic;
    signal incrementaPc :  std_logic;
    signal cargaRem :  std_logic;
    signal cargaRi :  std_logic;
    signal cargaAc :  std_logic;
    signal cargaNz :  std_logic;
    signal selMuxPc  : std_logic;
    signal n :  std_logic := '0';
    signal z :  std_logic := '0';
    signal dadoSaidaMemoria  : std_logic_vector(7 downto 0);
    signal selUla :std_logic_vector(2 downto 0);
    signal endereco :std_logic_vector(7 downto 0);
    signal instrucao :std_logic_vector(3 downto 0);
    signal instrucaoDecodificada : std_logic_vector(10 downto 0);
    signal acumulador : std_logic_vector(7 downto 0);

    signal writeA : std_logic_vector(0 downto 0) := "0";
    signal writeB : std_logic_vector(0 downto 0) := "0";
    signal dadoPlaca : std_logic_vector(7 downto 0);
    signal enderecoVazio : std_logic_vector(7 downto 0) := (others => '0');
begin

    ram :  dpbram 
    port map (
        clka=>  clock,
        wea=> writeA,
        addra=>  endereco,
        dina => acumulador,
        douta=>  dadoSaidaMemoria,
        clkb=>  clock,
        web=> writeB,
        addrb=> switches ,
        dinb=>  enderecoVazio,
        doutb=> dadoPlaca ); 

    basys : placa
    port map (
        clock => clock,
        reset =>  reset ,
        leitura_mem =>dadoPlaca,
        switch	=> switches,
        seg =>  seg_leds,
        an 	=> an,
        dp => dp);

    data :  datapath 
    port map(
        clock           =>   clock  ,
        reset           =>   reset  ,
        cargaPc         =>   cargaPc ,
        incrementaPc    =>   incrementaPc  ,
        cargaRem        =>   cargaRem ,
        dadoSaidaMemoria =>  dadoSaidaMemoria  ,
        cargaRi         =>   cargaRi  ,
        selUla          =>   selUla  ,
        cargaAc         =>   cargaAc  ,
        cargaNz         =>   cargaNz  ,
        selMuxPc        =>   selMuxPc  ,
        acumulador      =>  acumulador,
        n               =>   n  ,
        z               =>   z  ,
        endereco        =>   endereco  ,
        instrucao       =>   instrucao );

    process(instrucao)
    begin   
        case instrucao is
            when "0000" => instrucaoDecodificada <= "00000000001"; --NOP
            when "0001" => instrucaoDecodificada <= "00000000010"; --STA
            when "0010" => instrucaoDecodificada <= "00000000100"; --LDA
            when "0011" => instrucaoDecodificada <= "00000001000"; --ADD
            when "0100" => instrucaoDecodificada <= "00000010000"; --OR
            when "0101" => instrucaoDecodificada <= "00000100000"; --AND
            when "0110" => instrucaoDecodificada <= "00001000000"; --NOT
            when "1000" => instrucaoDecodificada <= "00010000000"; --JMP
            when "1001" => instrucaoDecodificada <= "00100000000"; --JN
            when "1010" => instrucaoDecodificada <= "01000000000"; --JZ
            when "1111" => instrucaoDecodificada <= "10000000000"; --HTL
            when others => instrucaoDecodificada <= "00000000001";
        end case;
    end process;
    
    process(clock, reset)
    begin 
        if reset = '1' then
            saida <= (others => '0');
            estado <= E0;
        elsif rising_edge(clock) then
            estado <= proximoEstado;
            saida <= acumulador;

            flip_n_s <= n;          
            flip_z_S <= z;          
            endereco_S <= endereco;
            dado_saida_mem_s <= dadoSaidaMemoria;
            dado_entrada_mem_s <= acumulador; 
            instrucao8bits_s <= instrucao; 
            instrucao_s <= instrucaoDecodificada;
        end if;
    end process;


    process(estado, instrucaoDecodificada)
    begin
        cargaPc <= '0';
        incrementaPc <=  '0';
        cargaRem <=  '0';
        cargaRi <=  '0';
        cargaAc <=  '0';
        cargaNz <=  '0';
        selMuxPc  <= '0';
        writeA <= "0";

        case estado is
            when E0 => 
                selMuxPc <= '0';
                cargaRem <= '1';
                proximoEstado <= E1;
                
            when E1 =>
                writeA <= "0";
                cargaPc <= '1';
                incrementaPc <= '1';
                proximoEstado <= W1;

            when W1 =>
                proximoEstado <= E2;

            when E2 =>
                cargaRi <= '1';
                proximoEstado <= E3;

            when E3 =>
                if instrucaoDecodificada(6) = '1' then  --NOT
                    selUla <= "011";
                    cargaAc <= '1';
                    cargaNz <= '1';
                    proximoEstado <= E0;
                elsif (instrucaoDecodificada(8) = '1' and n = '0') then -- JN
                    cargaPc <= '1';
                    incrementaPc <= '1';
                    proximoEstado <= E0;
                elsif (instrucaoDecodificada(9) = '1' and z = '0') then -- JZ
                    cargaPc <= '1';
                    incrementaPc <= '1';
                    proximoEstado <= E0;
                elsif instrucaoDecodificada(0) = '1' then -- NOP
                    proximoEstado <= E0;
                elsif instrucaoDecodificada(10) = '1' then -- HLT   
                    proximoEstado <= FF;
                else
                    selMuxPc <= '0';
                    cargaRem <= '1';
                    proximoEstado <= E4;
                end if;
                
            when E4 =>
                writeA <= "0";
                if (instrucaoDecodificada(1) = '1' or instrucaoDecodificada(2) = '1' or instrucaoDecodificada(3) = '1' or instrucaoDecodificada(4) = '1'or instrucaoDecodificada(5) = '1') then
                    cargaPc <= '1';
                    incrementaPc <= '1';
                end if;
                proximoEstado <= W4;

            when W4 =>
                proximoEstado <= E5;

            when E5 =>
                if (instrucaoDecodificada(1) = '1' or instrucaoDecodificada(2) = '1' or instrucaoDecodificada(3) = '1' or instrucaoDecodificada(4) = '1'or instrucaoDecodificada(5) = '1') then
                    selMuxPc <= '1';
                    cargaRem <= '1';
                    proximoEstado <= E6;
                else
                    cargaPc <= '1';
                    incrementaPc <= '0';
                    proximoEstado <= E0;
                end if;

            when E6 =>
                writeA <= "0";
                if (instrucaoDecodificada(2) = '1' or instrucaoDecodificada(3) = '1' or instrucaoDecodificada(4) = '1'or instrucaoDecodificada(5) = '1') then
                elsif instrucaoDecodificada(1) = '1' then
                end if;
                proximoEstado <= W6;

            when W6 =>
                proximoEstado <= E7;

            when E7 =>
                if instrucaoDecodificada(1) = '1' then
                    writeA <= "1";
                elsif instrucaoDecodificada(2) = '1' then
                    selUla <= "100";
                elsif instrucaoDecodificada(3) = '1' then
                    selUla <= "000";
                elsif instrucaoDecodificada(4) = '1' then
                    selUla <= "010";
                elsif instrucaoDecodificada(5) = '1' then
                    selUla <= "001";
                end if;

                if instrucaoDecodificada(1) = '1' then  
                    proximoEstado <= W7;
                else
                    cargaAc <= '1';
                    cargaNZ <= '1';
                    proximoEstado <= E0;
                end if;
            
            when W7 =>
                proximoEstado <= E0;

            when FF =>
                proximoEstado <= FF;
                
            when others => 
                proximoEstado <= E0;

        end case;
    end process;
end behav;