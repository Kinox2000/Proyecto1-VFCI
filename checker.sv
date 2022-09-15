//Código para el checker
class Checker #(parameter pckg_sz = 16);
        trans_driver_checker #(.pckg_sz(pckg_sz)) trans_driver;//Transacción recibidad en el mailbox
        Comando_Driver_Checker_mbx Driver_Checker_mbx;//Mailbox entre el driver y el checker

        trans_monitor_checker#(.pckg_sz(pckg_sz)) trans_monitor;
        Comando_Monitor_Checker_mbx Monitor_Checker_mbx;
  
  		int num_trans = 2;

        function new;//Instanciación de los mailboxes
                Driver_Checker_mbx = new;
                trans_driver = new;

                trans_monitor = new;
                Monitor_Checker_mbx = new;
        endfunction

  		bit [pckg_sz+7:0] driver_queue [$];//Cola para guardar los datos provenientes del driver
  		bit [pckg_sz+7:0] monitor_queue [$];//Cola para guardar los datos provenientes del monitor

        task run();
          $display("Inicia el Checker en el tiempo: [%g]", $time);

                forever begin
                  Driver_Checker_mbx.get(trans_driver);//Se espera la transacción con el dato proveniente del driver
                  //$display("Checker: Se recibió una transacción proveniente del driver, id: %d", trans_driver.identificacion);
                  //$display("Broadcast, [%b]", trans_driver.dato[pckg_sz+7:pckg_sz]);
                  $display("Dato, [%b], id:", trans_driver.dato, trans_driver.identificacion);
                  if(trans_driver.dato[pckg_sz+7:pckg_sz]==8'b1111_1111)begin
                    $display("Broadcast, [%b]", trans_driver.dato[pckg_sz+7:pckg_sz]);
                  end
                  driver_queue.push_back(trans_driver.dato);//Se inserta el dato proveniente del driver en la cola
                  driver_queue.push_back(trans_driver.identificacion);
                  
                  Monitor_Checker_mbx.get(trans_monitor);
                  $display("Se recibió una transacción proveniente del monitor, id: %d", trans_monitor.identificacion);//Se espera para obtener el dato proveniente del monitor
                  monitor_queue.push_back(trans_driver.dato);//Se inserta el dato proveniente del monitor en la cola
                  monitor_queue.push_back(trans_driver.identificacion);
                  
                  for(int j = 0; j < driver_queue.size(); j = j+1)begin
                    for(int i = 0; i < num_trans; i = i+1)begin
                      if(driver_queue[i]==monitor_queue[0] && driver_queue[i+1]==monitor_queue[1])begin
                        $display("Checker: El dato %b llegó correctamente a su destino %d", driver_queue[i], monitor_queue[1]);
                        monitor_queue.pop_front();
                      end
                    end
                  end                  
                end	
        endtask
endclass
