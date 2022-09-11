//Código para el driver
class driver #(parameter pckg_sz = 16, parameter broadcast = {8{1'b1}})
	int contador_retardo = 0;
	Comando_Agente_Driver_mbx agente_driver_mbx;//mailbox entre Agente/Generador al driver
	trans_agente_driver #(.pckg_sz(pckg_sz), .broadcast(broadcast)) mensaje_agente_driver;//paquete de transacción entre Agente y Driver

	task run();
	forever begin
		fifo_sim #(.pckg_size())
		$display("Inicia el driver");
		trans_agente_driver #(parameter pckg_sz = 16, broadcast = {8{1'b1}}) transaccion;
		agente_driver_mbx.get(mensaje_agente_driver);//Se recibe el paquete enviado al driver desde el agente/generador
		$display("Transacción recibida en el Driver")

		while(contador_retardo<mensaje_agente_driver.retardo) begin//Este ciclo espera a cumplir con el retardo entre paquetes
			contador_retardo=contador_retardo+1;
		end
		case(mensaje_agente_driver.tipo)//revisa el tipo de transacción que se recibe
			Trans_paquete_comun: begin

			end
			Trans_todos_a_todos: begin
			end
			Trans_broadcast: begin 
			end
			Trans_dispositivo_especifico: begin 
			end
			Trans_id_invalido: begin
			end
			Trans_ceros: begin
			end

		endcase
	end		
	
	endtask

endclass

class fifo_sim #(parameter pckg_size = 16)//Clase para simular las FIFOs
	bit D_pop[pckg_sz-1:0];//bits de entrada de la FIFO
	bit D_pop[pckg_sz-1:0];//bits de salida de la FIFO
	bit pndng;//bit de pending de la FIFO
	int fifo[$]//FIFO infinita para evitar el overflow
endclass



