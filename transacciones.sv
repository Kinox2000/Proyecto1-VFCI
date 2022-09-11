//en este archivo se definen los objetos de las transacciones que se van a enviar por el mailbox
//se definen los mailboxes 

typedef enum(Trans_paquete_comun, Trans_todos_a_todos, Trans_broadcast, Trans_dispsitivo_especifico, Trans_id_invalido, Trans_ceros) tipo_trans;
typedef enum(Reporte_completo, Reporte_parcial) tipo_reporte;

class trans_agente_driver #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
	rand int retardo;//retardo en ciclos de reloj que se debe esperar entre cada transacción
	int max_retardo;//número que se usará para crear el constraint del retardo
	rand bit[pckg_sz-1:0] dato;//Este es el dato que se va a enviar a las FIFOs que se conectarán al bus
	int tiempo;//Guarda el tiempo de simulación en el que se ejecuta la transacción

	constraint const_retardo {retardo < max_retardo; retardo > 0;}//Asegura que el retardo sea un número positivo menor al retardo máximo establecido

	function new(int ret = 0, int max_ret = 10, data = 0, int time = 0, tipo_trans = Trans_paquete_comun);//constructor de la clase
	this.retardo = ret;
	this.max_retardo = max_ret;
	this.dato = data;
	this.tiempo = time;
	end function

	funtion void print(string tag = "");
		$display("Tiempo = %0t dato = 0x%0h retardo = %d", $time, data)			
	end fuction
endclass

class trans_checker_scoreboard #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
	int retardo;//retardo en ciclos de reloj que se debe esperar entre cada transacción
	bit[pckg_sz-1:0] dato;//Este es el dato que se va a enviar a las FIFOs que se conectarán al bus
	int tiempo;//Guarda el tiempo de simulación en el que se ejecuta la transacción
	int latencia;
	int tiempo_envio;
	int tiempo_recibido;
	int flag_comprobacion;

	function new(int ret = 0, data = 0, int time = 0, tipo_trans = Trans_paquete_comun, lat = 0, envio = 0, recibido = 0, comprobacion = 0);//constructor
	this.retardo = ret;
	this.dato = data;
	this.tiempo = time;
	this.latencia = lat
	this.tiempo_recibido = recibido;
	this.tiempo_envio = envio;
	this.flag_comprobacion = comprobacion;
	end function

	funtion void print(string tag = "");
		$display("Tiempo = %0t dato = 0x%0h retardo = %d" latencia = %d, $time, data, latencia)			
	end fuction
endclass

class trans_monitor_checker #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
	rand int retardo;//retardo en ciclos de reloj que se debe esperar entre cada transacción
	rand bit[pckg_sz-1:0] dato;//Este es el dato que se envió a las FIFOs
	int tiempo;//Guarda el tiempo de simulación en el que se ejecuta la transacción
	int latencia;

	function new(int ret = 0, data = 0, int time = 0, tipo_trans = Trans_paquete_comun, lat = 0);//constructor de la clase
	this.retardo = ret;
	this.dato = data;
	this.tiempo = time;
	this.latencia = lat
	end function

	funtion void print(string tag = "");
		$display("Tiempo = %0t dato = 0x%0h retardo = %d" latencia = %d, $time, data, lat)			
	end fuction
endclass
// creo aliases para los mailbox parametrizados
typedef mailbox #(tipo_trans) Comando_Test_Agente_mbx;	
typedef mailbox #(trans_agente_driver)  Comando_Agente_Driver_mbx;
typedef mailbox #(trans_monitor_checker)  Comando_Monitor_Checker_mbx;
typedef mailbox #(trans_checker_scoreboard)  Comando_Checker_Scoreboard_mbx;	
typedef mailbox #(tipo_reporte)  Comando_Test_Scoreboard_mbx;	
