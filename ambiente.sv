class ambiente #(parameter WIDTH = 16,parameter MAX_RETARDO=10,parameter DISPOSITIVOS=16);
  
  //se definen los componentes de ambiente
  agente_generador #(.WIDTH(WIDTH),.MAX_RETARDO(MAX_RETARDO),.DISPOSITIVOS(DISPOSITIVOS)) agente_generador_inst;
  driver #(.pckg_sz(WIDTH), .drvrs(DISPOSITIVOS), .max_retardo(MAX_RETARDO)) driver_inst;
  monitor #(.pckg_sz(WIDTH), .drvrs(DISPOSITIVOS), .max_retardo(MAX_RETARDO)) monitor_inst;
  
  virtual bus_if #(.pckg_sz(WIDTH), .drvrs(DISPOSITIVOS)) _if;
  
  //declaracion de la interface del DUT
  
  
  //creacion mailboxes
  Comando_Test_Agente_mbx Test_Agente_mbx; //test agente
  Comando_Agente_Driver_mbx Agente_Driver_mbx; //agente driver
  Comando_Test_Scoreboard_mbx Test_Scoreboard_mbx; //test scoreboard
  Comando_Monitor_Checker_mbx Monitor_Checker_mbx; // monitor checker
  Comando_Driver_Checker_mbx Driver_Checker_mbx;
  function new();
    //instanciacion mailboxes
    Test_Agente_mbx =new();
    Agente_Driver_mbx =new();
    Test_Scoreboard_mbx= new();
    Monitor_Checker_mbx =new();
    Driver_Checker_mbx =new();
    //instanciacion componentes de ambiente
    agente_generador_inst= new();
    driver_inst =new();
    monitor_inst=new();
    //conexion interfaces y mailboxes en el ambiente
    agente_generador_inst.Test_Agente_mbx=Test_Agente_mbx;
    agente_generador_inst.Agente_Driver_mbx=Agente_Driver_mbx;
    driver_inst.Driver_Checker_mbx=Driver_Checker_mbx;
    driver_inst.Agente_Driver_mbx=Agente_Driver_mbx;
    monitor_inst.Monitor_Checker_mbx=Monitor_Checker_mbx;
    for (int i=0;i<DISPOSITIVOS; i++)begin
      automatic int j=i;
      driver_inst.driver_hijo_[j].Agente_Driver_mbx=Agente_Driver_mbx;
      driver_inst.driver_hijo_[j].Driver_Checker_mbx=Driver_Checker_mbx;
      driver_inst.driver_hijo_[j].vif=_if;
      monitor_inst.monitor_hijo_[j].Monitor_Checker_mbx=Monitor_Checker_mbx;
      monitor_inst.monitor_hijo_[j].vif=_if;
    end
    //driver_inst.Agente_Driver_mbx=Agente_Driver_mbx;
    //driver_inst.Driver_Checker_mbx=Driver_Checker_mbx;
    //monitor_inst.Monitor_Checker_mbx=Monitor_Checker_mbx;
    //fix mailbox drvr a checker
    //
    //monitor_inst.vif=_if;
  endfunction
  virtual task run();
    $display("Tiempo %0t Ambiente: El ambiente fue inicializado", $time);
    fork
      agente_generador_inst.run();
      driver_inst.run();
      monitor_inst.run();
    join_none
  endtask
  
endclass