source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopys_tools.sh

vcs -Mupdate Testbench.sv -o salida -full64  -debug_acc+all -sverilog -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert;

./salida +ntb_random_seed=3 -cm line+tgl+cond+fsm+branch+assert;
dve -full64 -covdir salida.vdb & 
