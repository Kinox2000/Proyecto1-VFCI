//Código para el driver
//
class fifo_sim #(parameter pckg_size = 16,drvrs=4);
    bit [pckg_size+7:0] D_push;
    bit D_pop [pckg_size+7:0];
	bit pndng;
    bit [pckg_size-1:0] fifo_queue [$];
endclass

class driver #(parameter pckg_sz = 16, parameter drvrs = 4, max_retardo = 10, parameter broadcast = {8{1'b1}});
	int contador_retardo = 0;
    int contador_trans=0;
    bit [pckg_sz+7:0] dato_recibido;
	Comando_Agente_Driver_mbx Agente_Driver_mbx;//mailbox entre Agente/Generador al driver
  
    trans_agente_driver #(.pckg_sz(pckg_sz), .broadcast(broadcast)) transaccion[drvrs-1:0];
  
    virtual bus_if #(.pckg_sz(pckg_sz), .drvrs(drvrs)) vif;
    fifo_sim #(.pckg_size(pckg_sz), .drvrs(drvrs)) fifo [drvrs-1:0];
  
	task run();
	forever begin
        @(posedge vif.clk);
		$display("Inicia el driver");
      for (int i=0;i<drvrs-1; i++)begin
          transaccion[i]=new();
          fifo[i]=new();
          Agente_Driver_mbx.peek(transaccion[i]);
          while(contador_retardo<transaccion[i].retardo) begin
            contador_retardo=contador_retardo+1;
		  end
          if (contador_retardo==transaccion[i].retardo)begin
            contador_retardo=0;
          end
          if (i==transaccion[i].id)begin
            Agente_Driver_mbx.get(transaccion[i]);
            $display ("Tiempo %0t Driver: se encuentra el id correcto y se obtiene la transaccion del agente", $time);
            fifo[i].D_push=transaccion[i].D_push;
            fifo[i].fifo_queue.push_back(fifo[i].D_push);
            dato_recibido=fifo[i].fifo_queue.pop_front();
            fifo[i].pndng = 1'b1;
            if(fifo[i].pndng == 1'b1)begin
              vif.D_push[0][i] = dato_recibido;
		      vif.pndng[0][i] = 1'b1;
              vif.push[0][i] = 1'b1;
              contador_trans=contador_trans+1;
              $display ("Tiempo %0t Driver: Se ha enviado el dato a la interfaz dato= %d contador_trans= %d",$time, vif.D_push[0][i], contador_trans);
		    end

          end

         
        end

	end		
	
	endtask

endclass



