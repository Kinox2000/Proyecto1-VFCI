//Clase de transacción entre el checker y el scoreboard

typedef enum(Trans_paquete_comun, Trans_todos_a_todos, Trans_broadcast) tipo_trans;

class trans_monitor_checker #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
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
