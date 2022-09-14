// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
`include "DUT.sv"
`include "transacciones.sv"
`include "agente_generador.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checker.sv"
`include "ambiente.sv"
`include "test.sv"


module test_bench;
  reg clk;
  parameter WIDTH =16;
  parameter DISPOSITIVOS = 16;
  parameter MAX_RETARDO=5;
  
  test #(.WIDTH(WIDTH), .DISPOSITIVOS(DISPOSITIVOS), .MAX_RETARDO(MAX_RETARDO)) test_inst;
  
  
  
  always #5 clk =~clk;
  
  bus_if #(.pckg_sz(WIDTH), .drvrs(DISPOSITIVOS)) _if( .clk(clk));
  
  bs_gnrtr_n_rbtr #(.pckg_sz(WIDTH+8), .drvrs(DISPOSITIVOS)) uut (.clk(_if.clk), .reset(_if.reset), .pndng(_if.pndng), .push(_if.push), .pop(_if.pop),.D_pop(_if.D_pop), .D_push(_if.D_push) );
  
  initial begin 
    clk=0;
    test_inst=new();
    test_inst._if=_if;
    test_inst.ambiente_inst.driver_inst.vif=_if;
    test_inst.ambiente_inst.monitor_inst.vif=_if;

    fork
      test_inst.run();
    join_none

  end
  always@(posedge clk) begin
    if($time> 100000000) begin
      $display("Timeout");
      $finish; 
    end
  end
endmodule