//agente generador version 1.0
class agente_generador #(parameter WIDTH = 16,parameter MAX_RETARDO=5,parameter DISPOSITIVOS=16);
  
  
   Comando_Agente_Driver_mbx Agente_Driver_mbx; //creo el mailbox del agente al driver
   Comando_Test_Agente_mbx Test_Agente_mbx; // mailbox del test al agente creado en el test
   tipo_trans opcion; // defino el tipo que es opcion
  
   //prueba para ver el mailbox del agente al driver
   trans_agente_driver prueba;
   /////////////////////////////////////////////////
  
  
   function new;
  //instanciacion de los mailboxes
     Agente_Driver_mbx=new();
   endfunction

   // fix falta aleatorizar el numero de transacciones
   task run;
     forever begin 
     #1
     if (Test_Agente_mbx.num() > 0) begin
       $display ("Tiempo %0t Agente_generador: se recibe una instruccion", $time);
       Test_Agente_mbx.get(opcion);
       case(opcion)
         Trans_paquete_comun: begin
           //creo el tipo de transaccion 
           //fix falta parametrizar las transacciones, me tira un error que no entiendo
           trans_agente_driver trans_agente_driver_instancia ;
           trans_agente_driver_instancia=new;
           trans_agente_driver_instancia.const_destino.constraint_mode(1);
           trans_agente_driver_instancia.const_id.constraint_mode(1);
           trans_agente_driver_instancia.const_retardo.constraint_mode(1);
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           //envio por el mailbox
           Agente_Driver_mbx.put(trans_agente_driver_instancia);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end
         Trans_broadcast: begin
           //creo el tipo de transaccion 
           //fix falta parametrizar las transacciones, me tira un error que no entiendo
           trans_agente_driver trans_agente_driver_instancia ;
           trans_agente_driver_instancia=new;
           trans_agente_driver_instancia.const_destino.constraint_mode(0);
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.destino={8{1'b1}};
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           Agente_Driver_mbx.put(trans_agente_driver_instancia);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end
         Trans_id_invalido: begin
           trans_agente_driver trans_agente_driver_instancia ;
           trans_agente_driver_instancia=new;
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.const_destino.constraint_mode(0);
           trans_agente_driver_instancia.destino=DISPOSITIVOS+trans_agente_driver_instancia.id;
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           Agente_Driver_mbx.put(trans_agente_driver_instancia);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end
         Trans_ceros: begin
           trans_agente_driver trans_agente_driver_instancia ;
           trans_agente_driver_instancia=new;
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.dato={WIDTH{1'b0}};
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           //envio por el mailbox
           Agente_Driver_mbx.put(trans_agente_driver_instancia);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end
         Trans_A: begin
           trans_agente_driver trans_agente_driver_instancia ;
           trans_agente_driver_instancia=new;
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.dato={WIDTH{4'b1010}};
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           //envio por el mailbox
           Agente_Driver_mbx.put(trans_agente_driver_instancia);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end

       endcase
     end
       //para la prueba del mailbox al driver
     //Agente_Driver_mbx.peek(prueba);
       //$display ("Tiempo %0t Agente_generador: transaccion %s Resultado driver: retardo %g, id %b, dato %b, dpush %b, destino %b tiempo %0t ", $time, opcion, prueba.retardo, prueba.id, prueba.dato, prueba.D_push, prueba.destino, prueba.tiempo);
       ///////////////////////////////////////
      
     
     end
   endtask
endclass