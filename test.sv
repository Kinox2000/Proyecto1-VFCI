//test

class test#(parameter WIDTH=16, parameter DISPOSITIVOS =2,parameter MAX_RETARDO=10  );

  
  tipo_trans trans_elegida; //se define el tipo de transaccion que quiero
  tipo_reporte rep_elegido;// se define el tipo de reporte que quiero
  
  Comando_Test_Agente_mbx Test_Agente_mbx; //creo el mailbox del test al agente
  Comando_Test_Scoreboard_mbx Test_Scoreboard_mbx;
  
  //definir ambiente de prueba.
  ambiente #(.WIDTH(WIDTH),.MAX_RETARDO(MAX_RETARDO),.DISPOSITIVOS(DISPOSITIVOS)) ambiente_inst;
  //definicion de la interface
  virtual bus_if #(.pckg_sz(WIDTH), .drvrs(DISPOSITIVOS)) _if;
  
  function new;
  //instanciacion de los mailboxes
    Test_Agente_mbx =new();
    Test_Scoreboard_mbx =new();
    
    
    //definicion ambiente
    ambiente_inst=new();
    ambiente_inst._if=_if;
    
    ambiente_inst.Test_Agente_mbx=Test_Agente_mbx;
    ambiente_inst.agente_generador_inst.Test_Agente_mbx=Test_Agente_mbx;

  endfunction
  
  task run;
    $display("Tiempo %0t Test: Test fue inicializado", $time);
    fork
      ambiente_inst.run();
    join_none
    
    trans_elegida = Trans_paquete_comun;
    Test_Agente_mbx.put(trans_elegida);
    $display("Tiempo %0t Test: Se envia la primera instruccion al agente_generador-> trans_elegida= %s",$time, trans_elegida);

    rep_elegido =Reporte_completo;
    Test_Scoreboard_mbx.put(rep_elegido);
    $display("Tiempo %0t Test: Se envia la segunda instruccion al agente_scoreboard-> rep_elegido= %s",$time, rep_elegido);

    #150000

    $finish;

  endtask
endclass