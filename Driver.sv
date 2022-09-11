//Código para el driver
class driver #(parameter pckg_sz = 16, parameter broadcast = {8{1'b1}})
	int contador_retardo = 0;
	Comando_Agente_Driver_mbx agente_driver_mbx;
	trans_agente_driver #(.pckg_sz(pckg_sz), .broadcast(broadcast)) mensaje_agente_driver;

	task run();
	forever begin
		agente_driver_mbx.get(mensaje_agente_driver);
		$display("Transacción recibida en el Driver")
		while(contador_retardo<transaccion.retardo) begin
			contador_retardo=contador_retardo+1;
		end
	end

	fifo_sim #(.pckg_size())

		$display("Inicia el driver");
		trans_agente_driver #(parameter pckg_sz = 16, broadcast = {8{1'b1}}) transaccion;
		
	
	endtask

endclass

class fifo_sim #(parameter pckg_size = 16)//Clase para simular las FIFOs
	bit D_pop[pckg_sz-1:0];//bits de entrada de la FIFO
	bit D_pop[pckg_sz-1:0];//bits de salida de la FIFO
	bit pndng;//bit de pending de la FIFO
	int fifo[$]//FIFO infinita para evitar el overflow
endclass



