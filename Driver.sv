//Código para el driver
//
class fifo_sim #(parameter pckg_size = 16,drvrs=4);
    bit [pckg_size+7:0] D_push;
    bit D_pop [pckg_size+7:0];
	bit pndng;
    bit pop;
    bit push;
    bit [pckg_size+7:0] fifo_queue [$];

    task update;
      if (fifo_queue.size>0)begin
        pndng=1;
      end else begin 
        pndng=0;
        
      end
      
    endtask
endclass

class num_trans;
    rand int num;
	constraint const_num_trans {num<200; num>5;};
endclass

class driver #(parameter pckg_sz = 16, parameter drvrs = 16, max_retardo = 10, parameter broadcast = {8{1'b1}});
	int contador_retardo = 0;
    int contador_trans = 0;
  	num_trans transacciones = new();
  	transacciones.randomize();
    //bit [pckg_sz+7:0] dato_recibido;
	Comando_Agente_Driver_mbx Agente_Driver_mbx;//mailbox entre Agente/Generador al driver
    Comando_Driver_Checker_mbx Driver_Checker_mbx;
  
    trans_agente_driver #(.pckg_sz(pckg_sz), .broadcast(broadcast)) transaccion[drvrs-1:0];
    trans_driver_checker#(.pckg_sz(pckg_sz), .broadcast(broadcast)) trans_checker;
    virtual bus_if #(.pckg_sz(pckg_sz), .drvrs(drvrs)) vif;
    fifo_sim #(.pckg_size(pckg_sz), .drvrs(drvrs)) fifo [drvrs-1:0];
  
    function new;
  //instanciacion de los mailboxes
      Driver_Checker_mbx=new();
      trans_checker=new();
    endfunction
  
	task run();
	forever begin
        
        @(posedge vif.clk);
        for (int i=0;i<drvrs;i++)begin 
          vif.pndng[0][i]<=0;
          vif.D_push[0][i]<=0;
          vif.reset<=1;
          #2vif.reset<=0;
        end
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
            for(int k = 0; k<=num_trans;k=k+1)begin
            Agente_Driver_mbx.get(transaccion[i]);
            #1fifo[i].D_push=transaccion[i].D_push;
            #1fifo[i].fifo_queue.push_back(fifo[i].D_push);
            fifo[i].update();
            #1vif.D_pop[0][i] =fifo[i].fifo_queue.pop_front();
            #1vif.pndng[0][i] = fifo[i].pndng;
            #1
            @(posedge vif.pop[0][i]);
            $display ("Tiempo %0t Driver: Se ha enviado el dato a la interfaz dato= %b pop= %b",$time, vif.D_pop[0][i], vif.pop[0][i]);
            contador_trans=contador_trans+1;
            @(negedge vif.pop[0][i]);
            fifo[i].update();
            vif.pndng[0][i] = fifo[i].pndng;
            $display ("Tiempo %0t Driver: Se ha enviado el dato a la interfaz dato= %b pop= %b",$time, vif.D_pop[0][i], vif.pop[0][i]);
            trans_checker.dato=vif.D_pop[0][i];
            //$display("Dato recibido, [%b]", trans_checker.dato);//Quitar
            Driver_Checker_mbx.put(trans_checker);//Quitar
            //$display("Se envió el dato al checker, [%b]", trans_checker.dato);//Quitar
            trans_checker.tiempo_envio=$time;
            end

          end       
      end
	end		
	endtask
endclass
