//Clase de transacción para el agente al driver

typedef enum(Trans_paquete_comun, Trans_todos_a_todos, Trans_broadcast, Trans_dispsitivo_especifico, Trans_id_invalido, Trans_ceros) tipo_trans;

class trans_agente_driver #(parameter pckg_sz=16, parameter broadcast={8{1'b1}});
	rand int retardo;//retardo en ciclos de reloj que se debe esperar entre cada transacción
	int max_retardo;//número que se usará para crear el constraint del retardo
	rand bit[pckg_sz-1:0] dato;//Este es el dato que se va a enviar a las FIFOs que se conectarán al bus
	int tiempo;//Guarda el tiempo de simulación en el que se ejecuta la transacción
	rand tipo_trans = tipo;

	constraint const_retardo {retardo < max_retardo; retardo > 0;}//Asegura que el retardo sea un número positivo menor al retardo máximo establecido

	function new(int ret = 0, int max_ret = 10, data = 0, int time_ = 0, tipo_trans = Trans_paquete_comun);//constructor de la clase
	this.retardo = ret;
	this.max_retardo = max_ret;
	this.dato = data;
	this.tiempo = time_;
	this.tipo_trans = tipo;
	end function

	funtion void print(string tag = "");
		$display("Tiempo = %0t dato = 0x%0h retardo = %d", $time, data)			
	end fuction
endclass	
