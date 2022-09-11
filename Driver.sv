//Código para el driver
class driver #(parameter pckg_sz = 16, parameter drvrs = 4, max_retardo = 10, parameter broadcast = {8{1'b1}})
	int contador_retardo = 0;
	Comando_Agente_Driver_mbx agente_driver_mbx;//mailbox entre Agente/Generador al driver
	trans_agente_driver #(.pckg_sz(pckg_sz), .broadcast(broadcast)) mensaje_agente_driver;//paquete de transacción entre Agente y Driver
	class Interface_DUT #(.WITDH(pckg_sz), .MAX_RETARDO(max_retardo), .DISPOSITIVOS(drvrs)) BUS;

	task run();
	forever begin
		fifo_sim #(.pckg_size(pckg_sz =16)) fifo;
		$display("Inicia el driver");
		trans_agente_driver #(parameter pckg_sz = 16, broadcast = {8{1'b1}}) transaccion;
		agente_driver_mbx.get(transaccion);//Se recibe el paquete enviado al driver desde el agente/generador
		$display("Transacción recibida en el Driver")

		while(contador_retardo<transaccion.retardo) begin//Este ciclo espera a cumplir con el retardo entre paquetes
			contador_retardo=contador_retardo+1;
		end
		case(mensaje_agente_driver.tipo)//revisa el tipo de transacción que se recibe
			Trans_paquete_comun: begin
				fifo.D_push = transaccion.dato;//Se toma el dato para insertar en la FIFO
				fifo.push_back(fifo.D_push);//Se inserta el dato en la FIFO
				fifo.pndng = 1'b1;//Se pone el bit de pndng en 1
			end
			Trans_todos_a_todos: begin
				fifo.D_push = transaccion.dato;//Se toma el dato para insertar en la FIFO
				fifo.push_back(fifo.D_push);//Se inserta el dato en la FIFO
				fifo.pndng = 1'b1;//Se pone el bit de pndng en 1

			end
			Trans_broadcast: begin 
				fifo.D_push = transaccion.dato;//Se toma el dato para insertar en la FIFO
				fifo.push_back(fifo.D_push);//Se inserta el dato en la FIFO
				fifo.pndng = 1'b1;//Se pone el bit de pndng en 1

			end
			Trans_dispositivo_especifico: begin 
				fifo.D_push = transaccion.dato;//Se toma el dato para insertar en la FIFO
				fifo.push_back(fifo.D_push);//Se inserta el dato en la FIFO
				fifo.pndng = 1'b1;//Se pone el bit de pndng en 1

			end
			Trans_id_invalido: begin
				fifo.D_push = transaccion.dato;//Se toma el dato para insertar en la FIFO
				fifo.push_back(fifo.D_push);//Se inserta el dato en la FIFO
				fifo.pndng = 1'b1;//Se pone el bit de pndng en 1

			end
			Trans_ceros: begin
				fifo.D_push = transaccion.dato;//Se toma el dato para insertar en la FIFO
				fifo.push_back(fifo.D_push);//Se inserta el dato en la FIFO
				fifo.pndng = 1'b1;//Se pone el bit de pndng en 1

			end
			Trans_reset: begin//Se limpian los datos de la FIFO
				fifo.D_pop <= {pckg_zs{1'b0}};
				fifo.D_push <= {pckg_zs{1'b0}};
				fifo.pndng <= 1'b0;
				fifo.queue_fifo.delete();
			end

		endcase

		if(fifo.pndng == 1'b1)begin
			BUS.D_push = fifo.D_push;
			BUS.pngng = 1'b1;
		end
	end		
	
	endtask

endclass

class fifo_sim #(parameter pckg_size = 16)//Clase para simular las FIFOs
	bit D_pop[pckg_sz-1:0];//bits de entrada de la FIFO
	bit D_pop[pckg_sz-1:0];//bits de salida de la FIFO
	bit pndng;//bit de pending de la FIFO
	int queue_fifo[$]//FIFO infinita para evitar el overflow
endclass



