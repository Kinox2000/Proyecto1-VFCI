class scoreboard #(parameter WIDTH = 16,parameter MAX_RETARDO=5,parameter DISPOSITIVOS=16);
  
  Comando_Test_Scoreboard_mbx Test_Scoreboard_mbx;
  Comando_Checker_Scoreboard_mbx Checker_Scoreboard_mbx;
  
  trans_checker_scoreboard transaccion_recibida;
  tipo_reporte reporte_seleccionado;
  
  task run;
    $display("Tiempo %0t Scoreboard: Inicia Scoreboard", $time);
    forever begin
      #5
      if (Checker_Scoreboard_mbx.num()>0)begin
        Checker_Scoreboard_mbx.get(transaccion_recibida);
        transaccion_recibida.print("Tiempo %0t Scoreboard: Se recibe transaccion del Checker", $time);
        
        
      end
      
    end
    
  endtask
  
  
  
endclass