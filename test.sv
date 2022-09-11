//test
'timescale 1ns/1ps
'include "library.sv"//archivo con el dut
'include "Driver.sv"
'include "agente_generador.sv"
'include "transacciones.sv"
'include "interface_DUT.sv"

module test;
  parameter WIDTH =16;
  parameter DISPOSITIVOS = 2;
  parameter MAX_RETARDO=10;
  
  tipo_trans trans_elegida; //se define el tipo de transaccion que quiero
  tipo_reporte rep_elegido;// se define el tipo de reporte que quiero
  
  Comando_Test_Agente_mbx Test_Agente_mbx; //creo el mailbox del test al agente
  Comando_Test_Scoreboard_mbx Test_Scoreboard_mbx;
  //definir ambiente de prueba.
  
  //
  function new;
  //instanciacion de los mailboxes
  Test_Agente_mbx =new();
  endfunction
  
  initial begin
  $display("Tiempo %0t Test: Test fue inicializado", $time);

  trans_elegida = Trans_broadcast;
  Test_Agente_mbx.put(trans_elegida);
  $display("[Tiempo %0t Test: Se envia la primera instruccion al agente_generador-> trans_elegida= %s",$time, trans_elegida);

  rep_elegido =Reporte_completo;
  Test_Scoreboard_mbx.put(rep_elegido);
  $display("[Tiempo %0t Test: Se envia la segunda instruccion al agente_scoreboard-> rep_elegido= %s",$time, rep_elegido);

  #1500000

  $finish;

  end
endmodule
