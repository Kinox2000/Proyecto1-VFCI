//en este archivo se definen los objetos de las transacciones que se van a enviar por el mailbox
//se definen los mailboxes 
 
typedef enum{Trans_paquete_comun, Trans_broadcast, Trans_id_invalido, Trans_ceros, Trans_A} tipo_trans;
typedef enum{Reporte_completo, Reporte_parcial} tipo_reporte;

//interface DUT
interface bus_if #(parameter pckg_sz= 16, parameter drvrs= 4, parameter bits=1, parameter broadcast={8{1'b1}})(input clk);
   logic reset;
   logic pndng[bits-1:0][drvrs-1:0];
   logic push[bits-1:0][drvrs-1:0];
   logic pop[bits-1:0][drvrs-1:0];
   logic [pckg_sz+7:0] D_pop[bits-1:0][drvrs-1:0];
   logic [pckg_sz+7:0] D_push[bits-1:0][drvrs-1:0];
  
endinterface

class trans_agente_checker;
  int num_trans;
  function new(int num = 200);
    this.num_trans = num;
  endfunction
endclass

class trans_agente_driver #(parameter pckg_sz=16, parameter max_retardo=10, parameter max_dispositivos=16, parameter dispositivos=16);
  
  rand int retardo;//retardo en ciclos de reloj que se debe esperar entre cada transacción
  rand int id;
  bit [pckg_sz+7 :0] D_push;
  rand bit [7:0]destino;
  //int max_retardo;//número que se usará para crear el constraint del retardo
  rand bit[pckg_sz-1:0] dato;//Este es el dato que se va a enviar a las FIFOs que se conectarán al bus
  int tiempo;//Guarda el tiempo de simulación en el que se ejecuta la transacción
  
  constraint const_id {id < max_dispositivos; id > 0;}
  constraint const_unique {unique {id};}
  constraint const_retardo {retardo < max_retardo; retardo > 0;}//Asegura que el retardo sea un número positivo menor al retardo máximo establecido
  constraint const_destino {destino < dispositivos; destino !=id;}
  
  
  function new(int ret = 1, int data = 0, int _id=2);//constructor de la clase
    this.retardo = ret;
	this.dato = data;
    this.id = _id;
    this.destino = max_dispositivos-1;
	this.tiempo = $time;
  endfunction

  function void print (string tag = "");
    $display("Tiempo %0t Transacciones: La Transaccion es trans_agente_driver dato = %h retardo = %g D_push %d Id %g destino %d", tiempo, dato, retardo, D_push, id, destino);			
  endfunction
endclass

class trans_checker_scoreboard #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
	int retardo;//retardo en ciclos de reloj que se debe esperar entre cada transacción
    bit[pckg_sz-1:0] dato_enviado;//Este es el dato que se va a enviar a las FIFOs que se conectarán al bus
    bit[pckg_sz-1:0] dato_recibido;
	int tiempo;//Guarda el tiempo de simulación en el que se ejecuta la transacción
	int latencia;
	int tiempo_envio;
	int tiempo_recibido;
	int flag_comprobacion;
    int id;
  	int destino;

    function new(int ret = 0, int data = 0, int _time = 0, tipo_trans = Trans_paquete_comun, lat = 0, envio = 0, recibido = 0, comprobacion = 0, int ident = 0, int dest = 0);//constructor
	this.retardo = ret;
	this.dato_enviado = data;
    this.dato_recibido = data;
	this.tiempo = $time;
	this.latencia = lat;
	this.tiempo_recibido = recibido;
	this.tiempo_envio = envio;
	this.flag_comprobacion = comprobacion;
    this.id = ident;
    this.destino = dest;
	endfunction

	function void print(string tag = "");
      $display("Tiempo = %0t dato = 0x%0h retardo = %d latencia = %d", $time, this.dato_enviado, this.retardo, this.latencia);			
	endfunction
endclass

class trans_monitor_checker #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
	int destino;//retardo en ciclos de reloj que se debe esperar entre cada transacción
    bit[pckg_sz+7:0] dato;//Este es el dato que se envió a las FIFOs
	int tiempo_recibido;//Guarda el tiempo de simulación en el que se ejecuta la transacción
	int latencia;

  function new(int des = 0, int data = 0, int _time = 0, tipo_trans = Trans_paquete_comun, lat = 0);//constructor de la clase
	this.destino = des;
	this.dato = data;
	this.tiempo_recibido = $time;
	this.latencia = lat;
	endfunction

	function void print(string tag = "");
      $display("Tiempo = %0t dato = 0x%0h destino = %d latencia = %d", $time, dato, destino,latencia);			
	endfunction
endclass

class trans_driver_checker #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
    bit[pckg_sz+7:0] dato;//Este es el dato que se envió a las FIFOs
	int tiempo_envio;//Guarda el tiempo de simulación en el que se ejecuta la transacción
    int id;


    function new(int id_ = 0, int data = 0, int _time = 0, tipo_trans = Trans_paquete_comun, trans = 0);//constructor de la clase
	this.dato = data;
	this.tiempo_envio = $time;
    this.id=id_;
	endfunction

	function void print(string tag = "");
      $display("Tiempo = %0t dato = 0x%0h ", $time, dato);			
	endfunction
endclass
// creo aliases para los mailbox parametrizados
typedef mailbox #(trans_agente_checker) Comando_Agente_Checker_mbx;
typedef mailbox #(tipo_trans) Comando_Test_Agente_mbx;	
typedef mailbox #(trans_agente_driver)  Comando_Agente_Driver_mbx;
typedef mailbox #(trans_driver_checker)  Comando_Driver_Checker_mbx;	
typedef mailbox #(trans_monitor_checker)  Comando_Monitor_Checker_mbx;
typedef mailbox #(trans_checker_scoreboard)  Comando_Checker_Scoreboard_mbx;	
typedef mailbox #(tipo_reporte)  Comando_Test_Scoreboard_mbx;