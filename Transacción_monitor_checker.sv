//Clase de transacción entre el Monitor y el Checker

typedef enum(Trans_paquete_comun, Trans_todos_a_todos, Trans_broadcast) tipo_trans;

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
