//Código para el checker
//
//
//
class Checker #(parameter pckg_sz = 16);
        trans_driver_checker #(.pckg_sz(pckg_sz)) trans_driver;//Transacción recibidad en el mailbox
        Comando_Driver_Checker_mbx Driver_Checker_mbx;//Mailbox entre el driver y el checker
  		trans_agente_checker trans_agente;
  		Comando_Agente_Checker_mbx Agente_Checker_mbx;

        trans_monitor_checker#(.pckg_sz(pckg_sz)) trans_monitor;
        Comando_Monitor_Checker_mbx Monitor_Checker_mbx;
  		
  		Comando_Agente_Checker_mbx Agente_Checker_mbx;

        function new;//Instanciación de los mailboxes
                trans_driver = new;
                trans_monitor = new;
        endfunction

  		bit [pckg_sz+7:0] driver_queue [$];//Cola para guardar los datos provenientes del driver
  		bit [pckg_sz+7:0] monitor_queue [$];//Cola para guardar los datos provenientes del monitor
  
  		int contador = 0;		
  
        task run();
          $display("Tiempo %0t Inicia el Checker", $time);
          
                forever begin
                  Agente_Checker_mbx.get(trans_agente);
                  $display("Checker: Número de transacciones: %d", trans_agente.num_trans);
                  Driver_Checker_mbx.get(trans_driver);//Se espera la transacción con el dato proveniente del driver
                  $display("Checker: Se recibió un paquete desde el driver: dato, [%b], id:", trans_driver.dato, trans_driver.id);
                  if(trans_driver.dato[pckg_sz+7:pckg_sz]==8'b1111_1111)begin
                    $display("Checker: La transacción es un Broadcast, [%b]", trans_driver.dato[pckg_sz+7:pckg_sz]);
                  end
                  driver_queue.push_back(trans_driver.dato);//Se inserta el dato proveniente del driver en la cola
                  
                  Monitor_Checker_mbx.get(trans_monitor);
                  $display("Se recibió una transacción proveniente del monitor: dato %b destino: %d", trans_monitor.dato,trans_monitor.destino);//Se espera para obtener el dato proveniente del monitor
                  monitor_queue.push_back(trans_driver.dato);//Se inserta el dato proveniente del monitor en la cola 
                  
                  for(int j = 0; j < driver_queue.size(); j = j+1)begin
                    if(driver_queue[j]==monitor_queue[0])begin
                      $display("Checker: El dato %b llegó correctamente a su destino [%b]", driver_queue[j], monitor_queue[0][pckg_sz+7:pckg_sz]);
                      monitor_queue.pop_front();
                      contador = contador+1;
                    end
                  end 
                  
                  if(contador == trans_agente.num_trans)begin
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
                      $display("------------------------------Las transacciones NO se hicieron correctamente------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    	$display("-------------------------------------------------------------------------------------------------------");
                    end

                  end
                  
                end	
        endtask
endclass
