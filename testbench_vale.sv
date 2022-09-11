//hay que unir los testbench jaja
// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
`include "transacciones.sv"
`include "agente_generador.sv"
`include "ambiente.sv"
`include "test.sv"



module testbench;
  reg clk;
  parameter WIDTH =16;
  parameter DISPOSITIVOS = 16;
  parameter MAX_RETARDO=5;
  
  test #(.WIDTH(WIDTH), .DISPOSITIVOS(DISPOSITIVOS), .MAX_RETARDO(MAX_RETARDO)) test_inst;
  
  initial begin 
    test_inst=new();
    fork
      test_inst.run();
    join_none
  end
endmodule
