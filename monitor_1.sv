class fifo_sim_monitor #(parameter pckg_size = 16,drvrs=4);
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

class monitor_hijo  #(parameter pckg_sz = 16, parameter drvrs = 16, max_retardo = 10, parameter broadcast = {8{1'b1}});
  
  fifo_sim_monitor #(.pckg_size(pckg_sz), .drvrs(drvrs)) fifo_destino [drvrs-1:0] ;
  
  virtual bus_if #(.pckg_sz(pckg_sz), .drvrs(drvrs)) vif;
  Comando_Monitor_Checker_mbx Monitor_Checker_mbx;
  
  trans_monitor_checker #(.pckg_sz(pckg_sz), .broadcast(broadcast)) transaccion_monitor;
  
  int id_hijo_monitor;
  int encontrado;
  function new(int m);
    this.id_hijo_monitor=m;
    transaccion_monitor=new();
    fifo_destino[m]=new();
    encontrado=0;
  endfunction
  
  task run;
    //#1
    //@(posedge vif.clk);
    //$display("Tiempo %0t Monitor: Inicia el monitor_padre push %d", $time,vif.push[0][id_hijo_monitor] );
    if (vif.push[0][id_hijo_monitor]==1 && encontrado==0 )begin
      encontrado=1;
      fifo_destino[id_hijo_monitor].D_push=vif.D_push[0][id_hijo_monitor];
      fifo_destino[id_hijo_monitor].fifo_queue.push_back(fifo_destino[id_hijo_monitor].D_push);
      fifo_destino[id_hijo_monitor].update();
      transaccion_monitor.dato=fifo_destino[id_hijo_monitor].fifo_queue.pop_front();
      $display("Tiempo %0t Monitor: Encontro destino %d Dato %d", $time, id_hijo_monitor,vif.D_push[0][id_hijo_monitor]);
      transaccion_monitor.destino=id_hijo_monitor;
      transaccion_monitor.tiempo_recibido=$time;
      Monitor_Checker_mbx.put(transaccion_monitor);      
      $display("Tiempo %0t Monitor: Se envia transaccion al checker Dato %d, Destino", $time, transaccion_monitor.dato, transaccion_monitor.destino);
      
    end
    
  endtask
  
  
endclass

class monitor #(parameter pckg_sz = 16, parameter drvrs = 16, max_retardo = 10, parameter broadcast = {8{1'b1}});
  monitor_hijo  #(.pckg_sz(pckg_sz), .broadcast(broadcast), .drvrs(drvrs)) monitor_hijo_ [drvrs-1:0];
  Comando_Monitor_Checker_mbx Monitor_Checker_mbx;
  
  function new;
    Monitor_Checker_mbx=new();
    for (int i=0;i<drvrs; i++)begin
      automatic int j=i;
      monitor_hijo_[j]=new(i);
    end
  endfunction
  
  task run;
    $display("Tiempo %0t Monitor: Inicia el monitor_padre", $time);
    forever begin
      #1
      for (int i=0;i<drvrs; i++)begin
        automatic int j=i;
        monitor_hijo_[j].run();
      end
      
    end
    
  endtask
  
  
endclass