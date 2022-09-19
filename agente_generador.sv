//agente generador version 1.0
class agente_generador #(parameter WIDTH = 16,parameter MAX_RETARDO=5,parameter DISPOSITIVOS=16);
   Comando_Agente_Driver_mbx Agente_Driver_mbx; //creo el mailbox del agente al driver
   Comando_Test_Agente_mbx Test_Agente_mbx; // mailbox del test al agente creado en el test
   Comando_Agente_Checker_mbx Agente_Checker_mbx;
   tipo_trans opcion; // defino el tipo que es opcion
   trans_agente_driver #(.pckg_sz(WIDTH), .max_dispositivos(DISPOSITIVOS), .dispositivos(DISPOSITIVOS),.max_retardo(MAX_RETARDO) ) trans_agente_driver_instancia ;
   trans_agente_checker trans_agente_checker_inst;
   rand int num_trans;//Variable aleatoria que determina el número de transacciones que se realizarán
  constraint const_num {num_trans < 200; num_trans > 0;}//Se asegura que el número de transacciones sea mayor a 0 y menor a 200
  
  function new();
  //instanciacion de los mailboxes
     Agente_Driver_mbx=new();
    trans_agente_driver_instancia=new();
    trans_agente_checker_inst = new();
    for (int i=0;i<200; i++)begin//fix no sé por qué no permite poner num_trans aquí
       trans_agente_driver_inst[i]=new();
     end
   endfunction
  
  //prueba para ver el mailbox del agente al driver
  trans_agente_driver trans_agente_driver_inst [200:0];//fix no sé por qué no permite poner num_trans aquí, pero 200 es el número maximo de transacciones, entonces siempre va a funcionar, pero se consumen recursos innecesariamente 
  
   
   task run;
     forever begin 
     #1
     
     trans_agente_checker_inst.num_trans = num_trans;
     Agente_Checker_mbx.put(trans_agente_checker_inst);
     
     if (Test_Agente_mbx.num() > 0) begin
       $display ("Tiempo %0t Agente_generador: se recibe una instruccion", $time);
       $display ("Agente: Número de transacciones: ", num_trans);
       Test_Agente_mbx.get(opcion);
       case(opcion)
         Trans_paquete_comun: begin
           for (int i=0;i<num_trans; i++)begin
             $display("Transacción: %d", i);
             //creo el tipo de transaccion 
             //fix falta parametrizar las transacciones, me tira un error que no entiendo
             
             trans_agente_driver_instancia.const_unique.constraint_mode(1);
             trans_agente_driver_instancia.const_destino.constraint_mode(1);
             trans_agente_driver_instancia.const_id.constraint_mode(1);
             trans_agente_driver_instancia.const_retardo.constraint_mode(1);
             trans_agente_driver_instancia.randomize();
             trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
             trans_agente_driver_instancia.tiempo=$time;
             trans_agente_driver_instancia.print();
             //envio por el mailbox
             trans_agente_driver_inst[i].D_push=trans_agente_driver_instancia.D_push;
             trans_agente_driver_inst[i].id=trans_agente_driver_instancia.id;
             trans_agente_driver_inst[i].destino=trans_agente_driver_instancia.destino;
             trans_agente_driver_inst[i].dato=trans_agente_driver_instancia.dato;
             trans_agente_driver_inst[i].retardo=trans_agente_driver_instancia.retardo;
             trans_agente_driver_inst[i].tiempo=trans_agente_driver_instancia.tiempo;
             Agente_Driver_mbx.put(trans_agente_driver_inst[i]);
             
             $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
           end
         end
         Trans_broadcast: begin
           //creo el tipo de transaccion 
           //fix falta parametrizar las transacciones, me tira un error que no entiendo
           trans_agente_driver_instancia.const_destino.constraint_mode(0);
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.destino={8{1'b1}};
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           //Agente_Driver_mbx.put(trans_agente_driver_instancia);
           trans_agente_driver_inst[0].D_push=trans_agente_driver_instancia.D_push;
           trans_agente_driver_inst[0].id=trans_agente_driver_instancia.id;
           trans_agente_driver_inst[0].destino=trans_agente_driver_instancia.destino;
           trans_agente_driver_inst[0].dato=trans_agente_driver_instancia.dato;
           trans_agente_driver_inst[0].retardo=trans_agente_driver_instancia.retardo;
           trans_agente_driver_inst[0].tiempo=trans_agente_driver_instancia.tiempo;
           Agente_Driver_mbx.put(trans_agente_driver_inst[0]);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end
         Trans_id_invalido: begin
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.const_destino.constraint_mode(0);
           trans_agente_driver_instancia.destino=DISPOSITIVOS+trans_agente_driver_instancia.id;
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           //Agente_Driver_mbx.put(trans_agente_driver_instancia);
           trans_agente_driver_inst[0].D_push=trans_agente_driver_instancia.D_push;
           trans_agente_driver_inst[0].id=trans_agente_driver_instancia.id;
           trans_agente_driver_inst[0].destino=trans_agente_driver_instancia.destino;
           trans_agente_driver_inst[0].dato=trans_agente_driver_instancia.dato;
           trans_agente_driver_inst[0].retardo=trans_agente_driver_instancia.retardo;
           trans_agente_driver_inst[0].tiempo=trans_agente_driver_instancia.tiempo;
           Agente_Driver_mbx.put(trans_agente_driver_inst[0]);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end
         Trans_ceros: begin
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.dato={WIDTH{1'b0}};
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           trans_agente_driver_inst[0].D_push=trans_agente_driver_instancia.D_push;
           trans_agente_driver_inst[0].id=trans_agente_driver_instancia.id;
           trans_agente_driver_inst[0].destino=trans_agente_driver_instancia.destino;
           trans_agente_driver_inst[0].dato=trans_agente_driver_instancia.dato;
           trans_agente_driver_inst[0].retardo=trans_agente_driver_instancia.retardo;
           trans_agente_driver_inst[0].tiempo=trans_agente_driver_instancia.tiempo;
           Agente_Driver_mbx.put(trans_agente_driver_inst[0]);
           //envio por el mailbox
           //Agente_Driver_mbx.put(trans_agente_driver_instancia);
           $display ("Tiempo %0t Agente_generador: transaccion %s ", $time, opcion );
         end
         Trans_A: begin
           trans_agente_driver_instancia.randomize();
           trans_agente_driver_instancia.dato={WIDTH{4'b1010}};
           trans_agente_driver_instancia.D_push={trans_agente_driver_instancia.destino,trans_agente_driver_instancia.dato};
           trans_agente_driver_instancia.print();
           trans_agente_driver_inst[0].D_push=trans_agente_driver_instancia.D_push;
           trans_agente_driver_inst[0].id=trans_agente_driver_instancia.id;
           trans_agente_driver_inst[0].destino=trans_agente_driver_instancia.destino;
           trans_agente_driver_inst[0].dato=trans_agente_driver_instancia.dato;
           trans_agente_driver_inst[0].retardo=trans_agente_driver_instancia.retardo;
           trans_agente_driver_inst[0].tiempo=trans_agente_driver_instancia.tiempo;
           Agente_Driver_mbx.put(trans_agente_driver_inst[0]);
           //envio por el mailbox
           //Agente_Driver_mbx.put(trans_agente_driver_instancia);
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