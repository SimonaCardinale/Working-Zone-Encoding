library IEEE;
library UNISIM;
use UNISIM.Vcomponents.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;


--Livello strutturale

entity Concatenator is
  port(
   input : in std_logic_vector (3 downto 0);
   output : out std_logic_vector (15 downto 0)
  );
end Concatenator;

architecture Concat of Concatenator is
begin 
    output <= "000000000000" & input;
end Concat ;

--Xor Gate

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Xnor2in is
  port (
    x, y : in std_logic_vector(7 downto 0);
    z : out std_logic
  );
end Xnor2in;

architecture XnorArch of Xnor2in is
begin
 z <= '1' when(( x xor y)="00000000") else '0';
end XnorArch ; -- XnorArch

--Xor Gate per add

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Xor2in_add is
  port (
    x, y : in std_logic_vector(7 downto 0);
    z : out std_logic
  );
end Xor2in_add;

architecture XorArch2 of Xor2in_add is
begin
 z <= '1' when(( x xor y)="00000000") else '0';
end XorArch2 ; -- XorArch2

--Xor Gate

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Xor16 is
  port(x: in std_logic_vector(15 downto 0);
   
  z : out std_logic
);
end Xor16;

architecture XorArch16 of Xor16 is
signal y :  std_logic_vector(15 downto 0):= "0000000000001001";  
begin

z <= '1' when(( x xor y)="0000000000000000") else '0';
end XorArch16 ; -- XorArch16
    
-- Or Gate

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Or4in is
  port(
    a, b, c, d: in std_logic;
    f : out std_logic
  );
end Or4in;

  architecture OrArch of Or4in is
  begin 
  f <= a or b or c or d;
end OrArch ; -- OrArch

-- Multiplexer per il controllo risorsa

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity MultiplexerSource is
  port(
    in_0, in_1: in std_logic_vector(7 downto 0);
    s : in bit;
    out_m: out std_logic_vector(7 downto 0)
  );
  end MultiplexerSource;


architecture MultSourceArch of MultiplexerSource is
begin
  with(s) select 
    out_m <= in_0 when '0',
             in_1 when '1'; 
end MultSourceArch ; -- MultSourceArch

-- Multiplexer per address

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity MultiplexerAddress is
  port(
    in_0, in_1: in std_logic_vector(15 downto 0);
    s : in bit;
    out_m: out std_logic_vector(15 downto 0)
  );
end MultiplexerAddress;

architecture MultAddrArch of MultiplexerAddress is
  begin
    with(s) select 
      out_m <= in_0 when '0',
               in_1 when '1'; 
end MultAddrArch ; -- MultAddrArch

--Circuito interno

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity CircuitoInterno is 
  port(
    A, B, C, D, ADDR: in std_logic_vector(7 downto 0);
    Y: in std_logic_vector(2 downto 0);
    X : out std_logic_vector(7 downto 0);
    controllo_risorsa : in bit;
    trovato : out std_logic
);
end CircuitoInterno;

architecture CircuitoArch of CircuitoInterno is
  --dichiaro le componenti di circuito
component Xnor2in is
  port (
    x, y : in std_logic_vector(7 downto 0);
    z : out std_logic
  );
end component;

component Or4in is
  port(
    a, b, c, d: in std_logic;
    f : out std_logic
  );
end component;

component MultiplexerSource is
  port(
    in_0, in_1: in std_logic_vector(7 downto 0);
    s : in bit;
    out_m: out std_logic_vector(7 downto 0)

  );
end component;

--dichiaro i segnali interni
signal s5, s6, s7, s8, s9: std_logic;
signal s10: std_logic_vector(3 downto 0);
signal s11: std_logic_vector(7 downto 0); 
signal temp : std_logic;
  
begin

  s10 <= s8 & s7 & s6 & s5;
  s11 <= s9 & y & s10; 
  trovato <= s9;

  XorIst1 : Xnor2in 
    port map(x => a, y => addr, z => s5);
  XorIst2 : Xnor2in 
    port map(x => b, y => addr, z => s6);
  XorIst3 : Xnor2in 
    port map(x => c, y => addr, z => s7);
  XorIst4 : Xnor2in 
    port map(x => d, y => addr, z => s8);
  
  
  Or4inIst : Or4in
    port map(a => s5, b => s6, c => s7, d => s8, f => s9);

  MultiSourceIst : MultiplexerSource
    port map(in_0 => addr, in_1 => s11, s => controllo_risorsa, out_m => x); 
  
    
end CircuitoArch ; -- CircuitoArch


--Livello RTL

--Registro 8b

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Reg8b is
  port(
    r_in : in std_logic_vector(7 downto 0) := "11111111"; 
    r_out : out std_logic_vector(7 downto 0):= "11111111" ; 

    clk : in std_logic;
    reset : in std_logic;
    load : in std_logic
  );
end Reg8b;

architecture RegArch of Reg8b is

begin
  reg: process (reset,clk, load) 
   begin
    if(reset= '1')then
      
      r_out <= "11111111";
    elsif (clk' event and clk ='1' and load = '1' ) then
      r_out <= r_in;    
    end if; 
  end process; 
 

 end RegArch ; -- RegArch


-- Contatore 0-8

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Contatore is
  port (
    rst, incrementa, clk : in std_logic; 
    conteggio : out std_logic_vector(3 downto 0);
    eseguito : out std_logic
  ); 
end Contatore;


architecture ContatoreArch of Contatore is
signal tmp: std_logic_vector(3 downto 0);
signal flag: std_logic; 
begin
 incr : process (incrementa, rst, tmp, clk, flag)
    begin
      if (rst = '1' ) then 
        tmp <= "1000";
        eseguito <= '0';
        flag <= '0'; 
      elsif(incrementa = '0' ) then 
        flag <= '0'; 
        eseguito <= '0'; 
      elsif(clk' event and clk = '1')then
        if(incrementa='1' and flag = '0') then 
            if(tmp="1000") then
                tmp <= "0000";
            else
                tmp <= tmp + "0001";
                
            end if;
            flag <= '1'; 
           
            eseguito <= '1';
          
        end if;
      end if;
  end process;       
  
  conteggio <= tmp;
  

end ContatoreArch ; -- ContatoreArch


--Sommatore 8b

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Som8b is
port(
  clk : in std_logic;
  addendo1, addendo2: in std_logic_vector(7 downto 0):="11111111"; 
  s_out: out std_logic_vector(7 downto 0):= "11111111"
);
end Som8b;

architecture SomArch of Som8b is
begin
 somm: process(clk)
  begin

    if (rising_edge(clk) and clk = '1') then
      s_out <= addendo1 + addendo2;       
    end if; 
  end process;
end SomArch;

-- Macchina a stati

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity AF is
  port(
    clk, rst, start, trovato, address_ok, eseguito, ibase_ok, finito: in std_logic; --address_ok, ibase_ok il registro ha caricato address 
    count : in std_logic_vector(3 downto 0);
    we, en, load, load_address, incrementa,done, resetout : out std_logic;
    controllo_risorsa, s_addr : out bit

  );
end AF;
  

architecture AFArch of AF is
  type STATUS is (ReSeT, S0, S1, S2, S3, S4, S5, S6);
  signal PS, NS : STATUS; 
  
  
begin
  scegli_stato : process(PS, start, trovato, finito, count,eseguito, address_ok, ibase_ok)
    begin
      case PS is 
        when ReSeT =>
            NS <= ReSet;
            if (start = '1') then
                NS <= S0;
            end if;
        when S0 =>
            NS <= S0;
            if (address_ok = '1') then
                 NS <= S1 ;
            end if;
        when S1 =>
            NS <= S1;
            if (eseguito = '1') then
                 NS <= S2 ;
            end if;
        when S2 =>
            NS <= S2;
            if (ibase_ok = '1') then
                 NS <= S3 ;
            end if;
        when S3 =>
          if(trovato = '0') then
            NS <= S1;
          elsif (count = "1000") then
            NS <= S4 ;
          elsif (trovato = '1') then 
            NS <= S5 ; 
          else
            NS <= S3;       
          end if;
        when S4 =>
            NS <= S4;
            if (finito = '1') then
                 NS <= S6 ;
            end if;
        when S5 =>
            NS <= S5;
            if (finito = '1') then
                 NS <= S6 ;
            end if;
        when S6 =>
            NS <= S6;
            if (start = '0') then
                 NS <= ReSeT ;
            end if;

        when others =>
            NS <= ReSeT;  -- stato errore 
      end case;
    end process;

  -- Output 

  gestione_output: process( PS )
    begin
      case PS is
        when ReSeT =>
          we <= '0';
          en <= '1';
          load <= '0';
          controllo_risorsa <= '0';
          incrementa <= '0';
          done <= '0';
          load_address <= '0';
          s_addr <= '0';
          resetout <= '1';
          
        when S0 =>
          we <= '0';
          controllo_risorsa <= '0';
          incrementa <= '0';
          done <= '0';
          en <= '1';
          load <= '0';
          load_address <= '1';
          s_addr <= '0';
          resetout <= '0';
          
         when S1 =>
          we <= '0';
          controllo_risorsa <= '0';
          incrementa <= '1';
          done <= '0';
          en <= '1';
          load <= '0';
          load_address <= '0';
          s_addr <= '0';
          resetout <= '0';

        when S2 =>
          we <= '0';
          controllo_risorsa <= '0';
          incrementa <= '0';
          done <= '0';
          en <= '1';
          load <= '1';
          load_address <= '0';
          s_addr <= '0';
          resetout <= '0';

        when S3 =>
          we <= '0';
          en <= '0';
          load <= '0' ;
          controllo_risorsa <= '0';     
          done <= '0';
          incrementa <= '0';
          load_address <= '0';
          s_addr <= '0';
          resetout <= '0';

        when S4 => 
          incrementa <= '0';
          done <= '0';
          we <= '1';
          en <= '1';
          load <= '0';
          controllo_risorsa <= '0';
          load_address <= '0';
          s_addr <= '1';
          resetout <= '0';

        when S5 =>         
          incrementa <= '0';
          done <= '0';
          we <= '1';
          en <= '1';
          load <= '0';
          controllo_risorsa <= '1';
          load_address <= '0';
          s_addr <= '1';
          resetout <= '0';

        when S6 =>
          we <= '0';
          en <= '0';
          load <= '0';
          controllo_risorsa <= '0';
          incrementa <= '0';
          done <= '1';
          load_address <= '0';
          s_addr <= '1';
          resetout <= '0';

        when others => -- stato errore
          we <= '0';
          en <= '1';
          load <= '0';
          controllo_risorsa <= '0';
          incrementa <= '0';
          done <= '0';
          load_address <= '0';
          s_addr <= '0';
          resetout <= '0';

      end case;
    end process;
  
  -- Stato registro
  state: process( RST,CLK )
  begin
    if( CLK'event and CLK = '1' ) then
        if( RST = '1' ) then
            PS <= ReSeT;
        else
            PS <= NS;
        end if;
    end if; 
  end process;

                          
end AFArch ; -- AFArch



-- Circuito Completo

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity project_reti_logiche is
  port (
  i_clk : in std_logic;
  i_start : in std_logic;
  i_rst : in std_logic;
  i_data : in std_logic_vector(7 downto 0);
  o_address : out std_logic_vector(15 downto 0);
  o_done : out std_logic;
  o_en : out std_logic;
  o_we : out std_logic;
  o_data : out std_logic_vector (7 downto 0)
  );
end project_reti_logiche;

architecture ProjectArch of project_reti_logiche is

--dichiaro componenti

component CircuitoInterno is 
  port(
    A, B, C, D, ADDR: in std_logic_vector(7 downto 0);
    Y : in std_logic_vector(2 downto 0); 
    X : out std_logic_vector(7 downto 0);
    controllo_risorsa : in bit;
    trovato : out std_logic
);
end component;

component Contatore is
  port (
    rst, incrementa,clk : in std_logic;
    conteggio : out std_logic_vector(3 downto 0);
    eseguito : out std_logic
  );
end component;

component Reg8b is
  port(
    r_in : in std_logic_vector(7 downto 0);
    r_out : out std_logic_vector(7 downto 0);
    clk : in std_logic;
    reset : in std_logic;
    load : in std_logic
  );
end component;

component Som8b is
  port(
    clk : in std_logic;
    addendo1, addendo2: in std_logic_vector(7 downto 0);
    s_out: out std_logic_vector(7 downto 0)
  );
end component;

component AF is
  port(
    clk, rst, start, trovato, address_ok, eseguito, ibase_ok, finito: in std_logic;
     count : in std_logic_vector(3 downto 0);
    we, en, load, load_address, incrementa, done, resetout : out std_logic;
    controllo_risorsa, s_addr : out bit
    
  );
end component;

component MultiplexerAddress is
  port(
    in_0, in_1: in std_logic_vector(15 downto 0);
    s : in bit;
    out_m: out std_logic_vector(15 downto 0)
  );
end component;

component Xor2in_add is
  port (
    x, y : in std_logic_vector(7 downto 0);
    z : out std_logic
  );
end component;

component Xor16 is
  port (
    x: in std_logic_vector(15 downto 0);
    z : out std_logic
  );
end component;

component Concatenator is
  port(
   input : in std_logic_vector (3 downto 0);
   output : out std_logic_vector (15 downto 0)
  );
end component;

--dichiaro i segnali

signal data, data_in, data_in1, data_in2, data_in3, address :std_logic_vector(7 downto 0);
signal load, incrementa, load_address, address_ok, ibase_ok: std_logic;
signal sigcontrollo_risorsa, s_addr : bit;
signal trovatosig, eseguito : std_logic;
signal conteggiosig : std_logic_vector(3 downto 0);
signal addressconteggio, addresstoram : std_logic_vector(15 downto 0);
signal resetout : std_logic;
signal finito : std_logic;
signal trebitcontatore : std_logic_vector (2 downto 0);

-- Istanze componenti
begin
  
  o_address <= addresstoram;
  trebitcontatore <= conteggiosig(2) & conteggiosig(1) & conteggiosig(0); 

  ConcatenatorIst : Concatenator
    port map(input => conteggiosig, output => addressconteggio );

  XorOtto : Xor2in_add
    port map(x => address, y => i_data, z=>address_ok);

  XorOtto_ibase : Xor2in_add
    port map(x => data_in, y => i_data, z =>ibase_ok);
  
  XorSedici : Xor16
    port map(x => addresstoram,  z =>finito);

  MultiAddr : MultiplexerAddress
    port map(in_0 => addressconteggio , in_1 => "0000000000001001" , s => s_addr , out_m => addresstoram);

  RegAddressIst : Reg8b 
    port map (r_in => i_data, r_out => address, clk => i_clk, load => load_address, reset => resetout );

  RegIst : Reg8b 
    port map (r_in => i_data, r_out => data_in, clk => i_clk, load => load, reset => resetout); 
  
  Som1Ist : Som8b
    port map (clk => i_clk, addendo1 => data_in, addendo2 => "00000001", s_out => data_in1);
  
  Som2Ist : Som8b
    port map (clk => i_clk, addendo1 => data_in, addendo2 => "00000010", s_out => data_in2);

  Som3Ist : Som8b
    port map (clk => i_clk, addendo1 => data_in, addendo2 => "00000011", s_out => data_in3);

  ContIst : Contatore
    port map(rst => resetout, incrementa => incrementa, conteggio => conteggiosig,clk => i_clk, eseguito => eseguito); 
  
  CircuitoIntIst : CircuitoInterno
    port map(A => data_in , B => data_in1 , C => data_in2 , D => data_in3 , ADDR => address ,
     Y => trebitcontatore , X => o_data, controllo_risorsa => sigcontrollo_risorsa, trovato => trovatosig); 
  
  AFInst : AF
    port map(clk => i_clk , rst => i_rst , start => i_start , trovato => trovatosig, done => o_done, eseguito =>eseguito,
     count => conteggiosig, we => o_we, en => o_en, load => load, controllo_risorsa => sigcontrollo_risorsa,
      incrementa => incrementa, load_address => load_address, address_ok => address_ok,
       ibase_ok =>ibase_ok, s_addr => s_addr, resetout => resetout, finito => finito); 
       
end ProjectArch ; -- ProjectArch
