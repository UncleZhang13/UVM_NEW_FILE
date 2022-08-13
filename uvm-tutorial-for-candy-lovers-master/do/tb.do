vlib work
vmap work work

# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_1_to_6.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_7_and_8.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_9.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_15.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_21.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_23/design.sv ../src/tutorial_23/testbench.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_24/design.sv ../src/tutorial_24/testbench.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_25/design.sv ../src/tutorial_25/testbench.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_26/design.sv ../src/tutorial_26/testbench.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_27/design.sv ../src/tutorial_27/testbench.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_28/design.sv ../src/tutorial_28/testbench.sv
# vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_29/design.sv ../src/tutorial_29/testbench.sv
vlog +incdir+D:/Questasim/Questasim/uvm-1.2/../verilog_src/uvm-1.2/src ../src/tutorial_33/design.sv ../src/tutorial_33/testbench.sv

vsim -novopt -sv_seed random +UVM_TESTNAME=jelly_bean_test work.top
# vsim -novopt -sv_seed random +UVM_TESTNAME=jelly_bean_recipe_test work.top
# vsim -novopt -sv_seed random +UVM_TESTNAME=jelly_bean_reg_test work.top

log -r /*
run -all