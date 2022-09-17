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

class driver_hijo #(parameter pckg_sz = 16, parameter drvrs = 16, max_retardo = 10, parameter broadcast = {8{1'b1}});
  fifo_sim #(.pckg_size(pckg_sz), .drvrs(drvrs)) fifo [drvrs-1:0] ;
  
  virtual bus_if #(.pckg_sz(pckg_sz), .drvrs(drvrs)) vif;
  Comando_Agente_Driver_mbx Agente_Driver_mbx;//mailbox entre Agente/Generador al driver
  Comando_Driver_Checker_mbx Driver_Checker_mbx;
  
  trans_agente_driver #(.pckg_sz(pckg_sz)) transaccion;
  trans_driver_checker#(.pckg_sz(pckg_sz), .broadcast(broadcast)) trans_checker;
  
  int id_hijo;
  
  function new(int n);
    this.id_hijo=n;
    transaccion=new();
    trans_checker=new();
    fifo[n]=new();
    this.init(n);

  endfunction
  
  function init (int l);
    fork
      vif.pndng[0][l]<=0;
      vif.D_push[0][l]<=0;
      vif.reset<=1;
      #2vif.reset<=0;
    join_none
    
  endfunction
  
  task run;
    @(posedge vif.clk);
    #1
    Agente_Driver_mbx.peek(transaccion);
    $display("Se creó el hijo %d", id_hijo);
    if(transaccion.id==id_hijo)begin
      $display("Tiempo %0t Driver: Inicia el driver_hijo", $time);
      Agente_Driver_mbx.get(transaccion);
      fifo[id_hijo].D_push=transaccion.D_push;
      fifo[id_hijo].fifo_queue.push_back(fifo[id_hijo].D_push);
      for (int w=0; w<transaccion.retardo; w++)begin
        #1 $display("Driver:wait");
      end
      fifo[id_hijo].update();
      vif.D_pop[0][id_hijo] =fifo[id_hijo].fifo_queue.pop_front();
      vif.pndng[0][id_hijo] = fifo[id_hijo].pndng;
      @(posedge vif.pop[0][id_hijo]);
      $display ("Tiempo %0t Driver: Se ha enviado el dato a la interfaz dato= %b pop= %b",$time, vif.D_pop[0][id_hijo], vif.pop[0][id_hijo]);
      trans_checker.dato=vif.D_pop[0][id_hijo];
      trans_checker.id=id_hijo;
      trans_checker.tiempo_envio=$time;
      Driver_Checker_mbx.put(trans_checker);
      $display ("Tiempo %0t Driver: Se ha enviado la transaccion al checker dato= %b id= %b",$time, trans_checker.dato, trans_checker.id);
    end
    
  endtask
  
  
  
endclass

class driver #(parameter pckg_sz = 16, parameter drvrs = 16, max_retardo = 10, parameter broadcast = {8{1'b1}});

  driver_hijo #(.pckg_sz(pckg_sz), .broadcast(broadcast), .drvrs(drvrs)) driver_hijo_ [drvrs-1:0];
  Comando_Driver_Checker_mbx Driver_Checker_mbx;
  Comando_Agente_Driver_mbx Agente_Driver_mbx;

  //código para hacer correr a los hijos con un fork join_none
  task run();
	  Driver_Checker_mbx=new();
	  fork
	  begin 
		  for(int i = 0; i < drvs; i++)begin
			  automatic int j = i;
			  driver_hijo_[j] = new(j);
			  driver_hijo_[j].run();
		  end
	  end
	  join_none 
  end task
  //fin del código 

  //se crean los hijos
  /*function new;
    Driver_Checker_mbx=new();
    for (int i=0;i<drvrs; i++)begin
      automatic int j=i;
      driver_hijo_[j]=new(i);
    end
  endfunction

  task run();
    $display("Tiempo %0t Driver: Inicia el driver_padre", $time);
    forever begin
      #1
      $display("Tiempo %0t Driver: faltan trans %g", $time, Driver_Checker_mbx.num());
      for (int i=0;i<drvrs; i++)begin
        automatic int j;
        j=i;
        driver_hijo_[j].run();
      end
    end
  endtask*/
  
  
endclass
