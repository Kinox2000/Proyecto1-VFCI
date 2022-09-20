// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
`include "DUT.sv"
`include "transacciones.sv"
`include "agente_generador.sv"
`include "driver_1.sv"
`include "monitor_1.sv"
`include "checker.sv"
`include "Scoreboard.sv"
`include "ambiente.sv"
`include "test.sv"


module test_bench;
  reg clk;
  parameter WIDTH =16;
  parameter DISPOSITIVOS = 16;
  parameter MAX_RETARDO=5;
  
  test #(.WIDTH(WIDTH), .DISPOSITIVOS(DISPOSITIVOS), .MAX_RETARDO(MAX_RETARDO)) test_inst;
  
  bus_if #(.pckg_sz(WIDTH), .drvrs(DISPOSITIVOS)) _if( .clk(clk));
  
  always #10 clk =~clk;
  
  
  
  bs_gnrtr_n_rbtr #(.pckg_sz(WIDTH+8), .drvrs(DISPOSITIVOS)) uut (.clk(_if.clk), .reset(_if.reset), .pndng(_if.pndng), .push(_if.push), .pop(_if.pop),.D_pop(_if.D_pop), .D_push(_if.D_push) );
  
  initial begin 
    clk=0;
    test_inst=new();
    test_inst._if=_if;
    for (int i=0;i<DISPOSITIVOS; i++)begin
      automatic int j=i;
      test_inst.ambiente_inst.driver_inst.driver_hijo_[j].vif=_if;
      test_inst.ambiente_inst.monitor_inst.monitor_hijo_[j].vif=_if;
      
    end
    

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