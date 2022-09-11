class ambiente #(parameter WIDTH = 16,parameter MAX_RETARDO=10,parameter DISPOSITIVOS=16);
  
  //se definen los componentes de ambiente
  agente_generador #(.WIDTH(WIDTH),.MAX_RETARDO(MAX_RETARDO),.DISPOSITIVOS(DISPOSITIVOS)) agente_generador_inst;
  
  
  
  //declaracion de la interface del DUT
  
  
  //creacion mailboxes
  Comando_Test_Agente_mbx Test_Agente_mbx; //test agente
  Comando_Agente_Driver_mbx Agente_Driver_mbx; //agente driver
  Comando_Test_Scoreboard_mbx Test_Scoreboard_mbx; //test scoreboard
  
  function new();
    //instanciacion mailboxes
    Test_Agente_mbx =new();
    Agente_Driver_mbx =new();
    Test_Scoreboard_mbx= new();
    //instanciacion componentes de ambiente
    agente_generador_inst= new();
    
    //conexion interfaces y mailboxes en el ambiente
    agente_generador_inst.Test_Agente_mbx=Test_Agente_mbx;
    agente_generador_inst.Agente_Driver_mbx=Agente_Driver_mbx;
  endfunction
  virtual task run();
    $display("Tiempo %0t Ambiente: El ambiente fue inicializado", $time);
    fork
      agente_generador_inst.run();
    join_none
  endtask
  
endclass
