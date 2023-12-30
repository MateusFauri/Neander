# [Neander](https://www.inf.ufrgs.br/arq/wiki/doku.php?id=neander)

<p>Arquitetura Utilizada para realização deste Trabalho</p>
<div align="center">
  
![Arquitetura Neander](https://github.com/MateusFauri/Neander/assets/62532715/3a907944-9174-470c-94d2-b6943b85392c)

</div>


##                    Instruções do neander
Código|Instrução|Operação
------|---------|----------:
0000 	|NOP 	    |Nenhuma operação
0001 	|STA end 	|Armazena acumulador no endereço “end” da memória
0010 	|LDA end 	|Carrega o acumulador com o conteúdo do endereço “end” da memória
0011 	|ADD end 	|Soma o conteúdo do endereço “end” da memória ao acumulador
0100 	|OR end 	|Efetua operação lógica “OU” do conteúdo do endereço “end” da memória ao acumulador
0101 	|AND end 	|Efetua operação lógica “E” do conteúdo do endereço “end” da memória ao acumulador
0110 	|NOT 	    |Inverte todos os bits do acumulador
1000 	|JMP end 	|Desvio incondicional para o endereço “end” da memória
1001 	|JN end 	|Desvio condicional, se “N=1”, para o endereço “end” da memória
1010 	|JZ end 	|Desvio condicional, se “Z=1”, para o endereço “end” da memória
1111 	|HLT 	    |Para o ciclo de busca-decodificação-execução 


##                    Componentes do neander

### Parte OPERACIONAL
* Registradores
  * Acumulador (AC) de 8 bits
  * Contador de programa (PC) de 8 bits
  * Registrador de instrução (RI) de 4 bits
  * Registrador de endereços de memoria (REM) de 8 bits
* Flip_flops
  * N 
    * Caso a ultima operação realizada na ula der Negativo
  * Z
    * Caso a ultima operação realizada na ula der Zero
* Unidade de Controle (UC)
* ULA
  * Responsavel por realizar operações básicas. Opera sobre os dados presentes no acumulador e memoria é usado 8 bits para os dados
* Block Memory (BRAM)
  * Usada para armazenar dados e instruções. Ela opera sobre os dados do acumulador ou conteudo da memoria.

### Parte de CONTROLE
* Decodificador de instruções
  * Usado para usar os 8 bits de endereço para uma das 11 instruçoes de neander
* Atualização do contador de programa
* Geração de sinais de controle com base na instrução decodificada
* Gestão de ciclos de clock
* Controle do fluxo de dados
* Gestão de condições de controle
##                    Componentes feitos

### OPERACIONAL  
* Contem a ula, acumulador, pc, RI, REM
### CONTROLE 
* Unidade de Controle

##                    Programas utilizados para teste

<p>Programa em Assembly do Neander que realiza a multiplicação de dois números inteiros positivos de 8 bits por soma sucessiva (sera colocado na BRAM).</p>

```assembly
org 0
    LDA     y
    JZ      FIMDOPROGRAMA
    LDA	    255              
INICIO:
    LDA	    resultado
    ADD     x
    STA     resultado
    LDA     um
    NOT
    ADD     um                  
    ADD     y                
    JZ      FIMDOPROGRAMA       
    STA     y                 
    JMP     INICIO
FIMDOPROGRAMA:
    HLT

org 128
    x: db 5
    y: db 3
    resultado: db 0
    um: db 1
```

## Informações Adicionais
* Autor:      [Mateus Fauri](https://github.com/MateusFauri)
* Cadeira:    Sistemas digitais
* Semestre:   2023/2
         
