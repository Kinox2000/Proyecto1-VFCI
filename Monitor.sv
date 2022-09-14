class monitor #(parameter pckg_sz = 16, parameter drvrs = 16, max_retardo = 10, parameter broadcast = {8{1'b1}});

  int encontrar=0;
  Comando_Monitor_Checker_mbx Monitor_Checker_mbx;//mailbox entre Agente/Generador al driver
  trans_monitor_checker #(.pckg_sz(pckg_sz), .broadcast(broadcast)) transaccion_mointor[drvrs-1:0];
  virtual bus_if #(.pckg_sz(pckg_sz), .drvrs(drvrs)) vif;
  fifo_sim #(.pckg_size(pckg_sz), .drvrs(drvrs)) fifo_destino [drvrs-1:0];
  
  task run();
	forever begin
      //$display("Inicia el Monitor");
      for (int i=0;i<drvrs; i++)begin
        fifo_destino[i]=new();
        fifo_destino[i].D_push=vif.D_push[0][i];
        fifo_destino[i].fifo_queue.push_back(fifo_destino[i].D_push);
        fifo_destino[i].update();
        #1
        if (vif.pop[0][i] == 1 )begin
          $display("Time %0t Monitor: Encuentra enviado %g pop %b Dato %b" , $time ,i,vif.pop[0][i], vif.D_pop[0][i]);
          @(negedge vif.pop[0][i]);
          encontrar<=i;
          

        end
        
          // se obtiene el dato enviado
      end
      for (int j=0;j<drvrs; j++)begin
        $display("Time %0t Monitor: Buscando destino %g" , $time ,j);
        transaccion_mointor[j]=new();
        
        if (j!=encontrar && encontrar>0)begin
          
          wait (vif.push[0][j] == 1'b1);
        end  
        #1
        if (vif.push[0][j] == 1)begin
          transaccion_mointor[j].dato=vif.D_push[0][j];
          transaccion_mointor[j].tiempo_recibido= $time;
          Monitor_Checker_mbx.put(transaccion_mointor[j]);
          $display("Time %0t Monitor: Obtiene dato %d del bus al tiempo recibido %0t ",$time, transaccion_mointor[j].dato, transaccion_mointor[j].tiempo_recibido );
        end
            
      end
    end
     	
  endtask

endclass