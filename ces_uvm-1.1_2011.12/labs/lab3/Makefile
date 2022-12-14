# Makefile for UVM Lab3
rtl_path = ../../rtl
test = test_base
TB_TOP = ./test.sv
UVM_HOME = ../../uvm-1.1a
verbosity = UVM_MEDIUM
uvm_ver = uvm-1.1
seed = 1
defines = UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
plus = 
option = UVM_TR_RECORD +UVM_LOG_RECORD
SOLVER = 2

all: simv run

simv compile: *.sv $(TB_OP)
	vcs -sverilog -ntb_opts ${uvm_ver} -timescale="1ns/100ps" -l comp.log -debug_all +vcs+vcdpluson $(DUT) $(HARNESS_TOP) $(TB_TOP) +define+${defines}

run:
	./simv -l simv.log +ntb_random_seed=$(seed) +UVM_TESTNAME=$(test) +ntb_solver_mode=$(SOLVER) +UVM_VERBOSITY=$(verbosity) +${plus} +${option}

uvm1.1a: uvm_compile run

uvm_compile: *.sv
	vcs -sverilog ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS ${UVM_HOME}/src/uvm_pkg.sv +incdir+${UVM_HOME}/src+${VCS_HOME}/etc/uvm-1.1/vcs ${VCS_HOME}/etc/uvm-1.1/vcs/uvm_custom_install_vcs_recorder.sv -timescale="1ns/100ps" -l comp.log -debug_all +vcs+vcdpluson $(DUT) $(HARNESS_TOP) $(TB_TOP) +define+${defines}

random: simv
	./simv -l simv.log +ntb_random_seed_automatic +UVM_TESTNAME=$(test) +ntb_solver_mode=$(SOLVER) +UVM_VERBOSITY=$(verbosity) +${plus} +${option}

dve_i: simv
	./simv -l simv.log -gui +ntb_random_seed=$(seed) +UVM_TESTNAME=$(test) +ntb_solver_mode=$(SOLVER) +UVM_VERBOSITY=$(verbosity) +${plus}

solution: nuke
	cp ../../solutions/lab3/*.sv .

mycopy: nuke
	cp ../lab2/*.sv .
	cp ../../solutions/lab3/reset* .

original: copy

copy: nuke
	cp ../../solutions/lab2/*.sv .
	cp ../../solutions/lab3/packet_sequence.sv.orig packet_sequence.sv
	cp ../../solutions/lab3/test_collection.sv.orig test_collection.sv
	cp ../../solutions/lab3/router_env.sv.orig router_env.sv
	cp ../../solutions/lab3/driver.sv.orig driver.sv
	cp ../../solutions/lab3/reset* .

clean:
	rm -rf simv* csrc* *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *~

nuke: clean
	rm -rf *.sv

help:
	@echo =======================================================================
	@echo  " 								       "
	@echo  " USAGE: make target <seed=xxx> <verbosity=YYY> <test=ZZZ>              "
	@echo  " 								       "
	@echo  "  xxx is the random seed.  Can be any integer except 0. Defaults to 1  "
	@echo  "  YYY sets the verbosity filter.  Defaults to UVM_MEDIUM               "
	@echo  "  ZZZ selects the uvm test.       Defaults to test_base                "
	@echo  " 								       "
	@echo  " ------------------------- Test TARGETS ------------------------------ "
	@echo  " all             => Compile TB and DUT files and run the simulation    "
	@echo  " compile         => Compile TB and DUT files                           "
	@echo  " run             => Run the simulation with seed                       "
	@echo  " random          => Run the simulation with random seed                "
	@echo  " dve_i           => Run simulation interactively with DVE              "
	@echo  "                                                                       "
	@echo  " -------------------- ADMINISTRATIVE TARGETS ------------------------- "
	@echo  " help       => Displays this message.                                  "
	@echo  " clean      => Remove all intermediate simv and log files              "
	@echo  " nuke       => Remove all source code and debug files                  "
	@echo  " original   => Return content of lab back to original state            "
	@echo  " copy       => Copy files from previous lab's solutions directory      "
	@echo  " mycopy     => Copy files from user's previous lab directory           "
	@echo  " solution   => Copy files from solutions directory for lab             "
	@echo  "								       "
	@echo  " ---------------------- EMBEDDED SETTINGS -----------------------------"
	@echo  " -timescale=\"1ns/100ps\"                                              "
	@echo  " -debug_all                                                            "
	@echo =======================================================================
