//Módulo para correr la prueba del bus

'timescale 1ns/1ps
'include "library.sv"//archivo con el dut
'include "Driver.sv"
'include "Interface_agentegenerador_driver"
'include "Interface_checker_scoreboard"
'include "Interface_monitor_checker"

module testbench; 
	reg clk; 
	parameter bits = 1;
	parameter drvrs = 4;
	parameter pckg_sz = 16;
	parameter broadcast = {8{1'b1}};


	bs_gnrtr_n_rbtr#(.bits(bits), .drvrs(drvrs), .pckg_sx(pckg_sz), .broadcast(broadcast)) dut(
	.clk();
	.reset();
	.pndng();
	.push();
	.pop();
	.D_pop();
	.D_push();
	)
