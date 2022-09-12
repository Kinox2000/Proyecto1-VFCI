bs_gnrtr_n_rbtr #( parameter bits = 1,
 		parameter drvrs = 4, 
		parameter pckg_sz = 16, 
		parameter broadcast = {8{1'b1}}) (
 input clk,
 input reset,
 input pndng[bits-1:0][drvrs-1:0],
 output push[bits-1:0][drvrs-1:0],
 output pop[bits-1:0][drvrs-1:0],
 input [pckg_sz-1:0] D_pop[bits-1:0][drvrs-1:0],
 output [pckg_sz-1:0] D_push[bits-1:0][drvrs-1:0]
);
