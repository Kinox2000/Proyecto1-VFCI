//Código para el checker
//
//
//
class Checker #(parameter pckg_sz = 16);
  trans_driver_checker #(.pckg_sz(pckg_sz)) trans_driver;//Transacción que llega al mailbox entre el driver y el checker
        Comando_Driver_Checker_mbx Driver_Checker_mbx;//Mailbox entre el driver y el checker
  
  		trans_agente_checker trans_agente;//Transacción que llega al mailbox entre agente/generador y el checker
  		Comando_Agente_Checker_mbx Agente_Checker_mbx;//Mailbox entre agente/generador y el checker
  
        Comando_Checker_Scoreboard_mbx Checker_Scoreboard_mbx;//Mailbox entre el checker y el scoreboard
        trans_checker_scoreboard transaccion_enviada_sb;//Transacción que llega al mailbox entre el checker y el scoreboard

        trans_monitor_checker#(.pckg_sz(pckg_sz)) trans_monitor;//Transacción que llega al mailbox entre el monitor y el scoreboard
        Comando_Monitor_Checker_mbx Monitor_Checker_mbx;//Mailbox entre el monitor y el scoreboard
  
        trans_monitor_checker #(.pckg_sz(pckg_sz)) trans_monitor_aux[$];
        trans_driver_checker #(.pckg_sz(pckg_sz)) trans_driver_aux[$];

        function new;//Instanciación de los mailboxes
                trans_driver = new;
                trans_monitor = new;
                transaccion_enviada_sb=new;
                trans_monitor_aux={};
                trans_driver_aux={};
        endfunction

  		bit [pckg_sz+7:0] driver_queue [$];//Cola para guardar los datos provenientes del driver
  		bit [pckg_sz+7:0] monitor_queue [$];//Cola para guardar los datos provenientes del monitor
        
  
  		int contador = 0;
        int done =0;
        int latencia=0;
  
        task run();
          $display("Tiempo %0t Inicia el Checker", $time);
          Agente_Checker_mbx.get(trans_agente);
          $display("Checker: Número de transacciones: %d", trans_agente.num_trans);
          
                forever begin
                  #1
                  if (Driver_Checker_mbx.num()>0)begin
                    Driver_Checker_mbx.get(trans_driver);//Se espera la transacción con el dato proveniente del driver
                    $display("Checker: Se recibió un paquete desde el driver: dato, [%b], id:", trans_driver.dato, trans_driver.id);
                    if(trans_driver.dato[pckg_sz+7:pckg_sz]==8'b1111_1111)begin
                      $display("Checker: La transacción es un Broadcast, [%b]", trans_driver.dato[pckg_sz+7:pckg_sz]);
                    end
                    driver_queue.push_back(trans_driver.dato);//Se inserta el dato proveniente del driver en la cola
                    trans_driver_aux.push_back(trans_driver);
                    
                  end
                  if (Monitor_Checker_mbx.num()>0)begin
                    Monitor_Checker_mbx.get(trans_monitor);
                    $display("Se recibió una transacción proveniente del monitor: dato %b destino: %d transacciones en espera %g", trans_monitor.dato,trans_monitor.destino, Monitor_Checker_mbx.num());//Se espera para obtener el dato proveniente del monitor
                    monitor_queue.push_back(trans_monitor.dato);//Se inserta el dato proveniente del monitor en la cola
                    trans_monitor_aux.push_back(trans_monitor);
                  end
                  
                  for(int j = 0; j < driver_queue.size(); j = j+1)begin
                    if(driver_queue[j]==monitor_queue[0])begin
                      
                      $display("Checker: El dato %b llegó correctamente a su destino [%b]", driver_queue[j], monitor_queue[0][pckg_sz+7:pckg_sz]);
                      transaccion_enviada_sb.dato_enviado=trans_driver_aux[j].dato;
                      transaccion_enviada_sb.dato_recibido=trans_monitor_aux[0].dato;
                      transaccion_enviada_sb.tiempo_recibido=trans_monitor_aux[0].tiempo_recibido;
                      transaccion_enviada_sb.tiempo_envio=trans_driver_aux[j].tiempo_envio;
                      if(trans_driver_aux[j].id==trans_monitor_aux[0].destino)begin
                        transaccion_enviada_sb.flag_comprobacion=1;
                      end else begin
                        transaccion_enviada_sb.flag_comprobacion=0;
                      end
                      latencia=trans_monitor_aux[0].tiempo_recibido-trans_driver_aux[j].tiempo_envio;
                      transaccion_enviada_sb.latencia=latencia;
                      monitor_queue.pop_front();
                      trans_monitor_aux.pop_front();
                      contador = contador+1;
                      Checker_Scoreboard_mbx.put(transaccion_enviada_sb);
                      $display("Checker: Transacción enviada al Scoreboard");
                    end
                  end 
                  
                  if(contador == trans_agente.num_trans && done==0 )begin
                    if(monitor_queue.size == 0)begin
                      	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("---------------------------Todas las transacciones se hicieron correctamente---------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    end
                    else begin
                      	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                        $display("----------------------------Las transacciones NO se hicieron correctamente-----------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    end
                    done=1;
                  end                  
                end	
        endtask
endclass