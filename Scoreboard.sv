class scoreboard #(parameter WIDTH = 16,parameter MAX_RETARDO=5,parameter DISPOSITIVOS=16);
  
  Comando_Test_Scoreboard_mbx Test_Scoreboard_mbx;
  Comando_Checker_Scoreboard_mbx Checker_Scoreboard_mbx;
  
  trans_checker_scoreboard transaccion_recibida;
  tipo_reporte reporte_seleccionado;
  
  int archivo_csv;
  
  task run;
    
    archivo_csv = $fopen("output.csv"); // open file
    $fdisplay(archivo_csv, "Data , Shipping time, Source, Destination, Received time, Delay");
    $display("Tiempo %0t Scoreboard: Inicia Scoreboard", $time);
    forever begin
      #5
      if (Checker_Scoreboard_mbx.num()>0)begin
        Checker_Scoreboard_mbx.get(transaccion_recibida);
        //transaccion_recibida.print("Scoreboard Tiempo %0t: Se recibe transacción del Checker", $time);
        $display("Scoreboard Tiempo %0t: Se recibe transacción del Checkerdato = 0x%0h retardo = %d latencia = %d", $time, transaccion_recibida.dato_enviado, transaccion_recibida.retardo, transaccion_recibida.latencia);
        $fdisplay(archivo_csv, "%h, %d, %d, %d, %d, %d", transaccion_recibida.dato_enviado, transaccion_recibida.tiempo_envio, transaccion_recibida.id, transaccion_recibida.destino, transaccion_recibida.tiempo_recibido,transaccion_recibida.latencia);
      end
    end
  endtask
endclass