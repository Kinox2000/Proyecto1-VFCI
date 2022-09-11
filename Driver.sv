//Código para el driver
class driver #(parameter pckg_sz = 16)
	int contador_retardo = 0;
	task run();
		$display("Inicia el driver");
	endtask

endclass
