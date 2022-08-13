vlib work
vmap work work

vlog ../../mcdf/*.v
vlog ../../lab5/arb_pkg.sv
vlog ../../lab5/chnl_pkg.sv
vlog ../../lab5/fmt_pkg.sv
vlog ../../lab5/reg_pkg.sv
vlog ../../lab5/mcdf_rgm_pkg_ref.sv
vlog ../../lab5/mcdf_pkg_ref.sv
vlog ../../lab5/tb.sv


# vsim -i -novopt -classdebug -solvefaildebug -coverage -coverstore ./mti_covdb -testname mcdf_data_consistence_basic_test -sv_seed random +UVM_TESTNAME=mcdf_data_consistence_basic_test work.tb
vsim -i -novopt -classdebug -solvefaildebug -coverage -coverstore ./mti_covdb -testname mcdf_reg_illegal_test -sv_seed random +UVM_TESTNAME=mcdf_reg_illegal_test work.tb
# vsim -i -novopt -classdebug -solvefaildebug -coverage -coverstore ./mti_covdb -testname mcdf_reg_builtin_test -sv_seed random +UVM_TESTNAME=mcdf_reg_builtin_test work.tb
# vsim -i -novopt -classdebug -solvefaildebug -coverage -coverstore ./mti_covdb -testname mcdf_down_stream_low_bandwidth_test -sv_seed random +UVM_TESTNAME=mcdf_down_stream_low_bandwidth_test work.tb
# vsim -i -novopt -classdebug -solvefaildebug -coverage -coverstore ./mti_covdb -testname mcdf_full_random_test -sv_seed random +UVM_TESTNAME=mcdf_full_random_test work.tb

log -r /*

run -all