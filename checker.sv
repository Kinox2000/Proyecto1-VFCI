//Código para el checker
class Checker #(parameter pckg_sz = 16);
        trans_driver_checker #(.pckg_sz(pckg_sz)) trans_driver;//Transacción recibidad en el mailbox
        Comando_Driver_Checker_mbx Driver_Checker_mbx;//Mailbox entre el driver y el checker

        trans_monitor_checker#(.pckg_sz(pckg_sz)) trans_monitor;
        Comando_Monitor_Checker_mbx Monitor_Checker_mbx;

        function new;//Instanciación de los mailboxes
                Driver_Checker_mbx = new;
                trans_driver = new;

                trans_monitor = new;
                Monitor_Checker_mbx = new;
        endfunction

        task run();
          $display("Inicia el Checker en el tiempo: [%g]", $time);

                forever begin
                  Driver_Checker_mbx.get(trans_driver);//Se espera la transacción con el dato proveniente del driver
                  Monitor_Checker_mbx.get(trans_monitor);
                  $display("Se recibió una transacción proveniente del monitor");//Se espera para obtener el dato proveniente del monitor
                  
                  ->mensaje_checker; $display("Se levanta el evento");
                  
                  $display("Checker: Se recibió una transacción proveniente del driver");
                  //$display("Broadcast, [%b]", trans_driver.dato[pckg_sz+7:pckg_sz]);
                  $display("Dato, [%b]", trans_driver.dato);
                  
                  if(trans_driver.dato[pckg_sz+7:pckg_sz]==8'b1111_1111)begin
                    $display("Broadcast, [%b]", trans_driver.dato[pckg_sz+7:pckg_sz]);
                  end

                end
        endtask

endclass