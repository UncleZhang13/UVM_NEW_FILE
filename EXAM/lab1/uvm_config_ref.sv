interface uvm_config_if;
  logic [31:0] addr;
  logic [31:0] data;
  logic [ 1:0] op;
endinterface

package uvm_config_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class config_obj extends uvm_object;
    int comp1_var;
    int comp2_var;
    `uvm_object_utils(config_obj)
    function new(string name = "config_obj");
      super.new(name);
      `uvm_info("CREATE", $sformatf("config_obj type [%s] created", name), UVM_LOW)
    endfunction
  endclass
  
  class comp2 extends uvm_component;
    int var2;
    virtual uvm_config_if vif;  
    config_obj cfg; 
    `uvm_component_utils(comp2)
    function new(string name = "comp2", uvm_component parent = null);
      super.new(name, parent);
      var2 = 200;
      `uvm_info("CREATE", $sformatf("unit type [%s] created", name), UVM_LOW)
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("BUILD", "comp2 build phase entered", UVM_LOW)
      if(!uvm_config_db#(virtual uvm_config_if)::get(this, "", "vif", vif))
        `uvm_error("GETVIF", "no virtual interface is assigned")
        
      `uvm_info("GETINT", $sformatf("before config get, var2 = %0d", var2), UVM_LOW)
      uvm_config_db#(int)::get(this, "", "var2", var2);
      `uvm_info("GETINT", $sformatf("after config get, var2 = %0d", var2), UVM_LOW)
      
      uvm_config_db#(config_obj)::get(this, "", "cfg", cfg);
      `uvm_info("GETOBJ", $sformatf("after config get, cfg.comp2_var = %0d", cfg.comp2_var), UVM_LOW)     
      
      `uvm_info("BUILD", "comp2 build phase exited", UVM_LOW)
    endfunction
  endclass

  class comp1 extends uvm_component;
    int var1;
    comp2 c2;
    config_obj cfg; 
    virtual uvm_config_if vif;
    `uvm_component_utils(comp1)
    function new(string name = "comp1", uvm_component parent = null);
      super.new(name, parent);
      var1 = 100;
      `uvm_info("CREATE", $sformatf("unit type [%s] created", name), UVM_LOW)
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("BUILD", "comp1 build phase entered", UVM_LOW)
      if(!uvm_config_db#(virtual uvm_config_if)::get(this, "", "vif", vif))
        `uvm_error("GETVIF", "no virtual interface is assigned")
        
      `uvm_info("GETINT", $sformatf("before config get, var1 = %0d", var1), UVM_LOW)
      uvm_config_db#(int)::get(this, "", "var1", var1);
      `uvm_info("GETINT", $sformatf("after config get, var1 = %0d", var1), UVM_LOW)
      
      uvm_config_db#(config_obj)::get(this, "", "cfg", cfg);
      `uvm_info("GETOBJ", $sformatf("after config get, cfg.comp1_var = %0d", cfg.comp1_var), UVM_LOW)
      
      c2 = comp2::type_id::create("c2", this);
      `uvm_info("BUILD", "comp1 build phase exited", UVM_LOW)
    endfunction
  endclass

  class uvm_config_test extends uvm_test;
    comp1 c1;
    config_obj cfg;
    `uvm_component_utils(uvm_config_test)
    function new(string name = "uvm_config_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("BUILD", "uvm_config_test build phase entered", UVM_LOW)
      
      cfg = config_obj::type_id::create("cfg");
      cfg.comp1_var = 100;
      cfg.comp2_var = 200;
      uvm_config_db#(config_obj)::set(this, "*", "cfg", cfg);
      
      uvm_config_db#(int)::set(this, "c1", "var1", 10);
      uvm_config_db#(int)::set(this, "c1.c2", "var2", 20);
      
      c1 = comp1::type_id::create("c1", this);
      `uvm_info("BUILD", "uvm_config_test build phase exited", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("RUN", "uvm_config_test run phase entered", UVM_LOW)
      phase.raise_objection(this);
      #1us;
      phase.drop_objection(this);
      `uvm_info("RUN", "uvm_config_test run phase exited", UVM_LOW)
    endtask
  endclass
endpackage

module uvm_config_ref;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uvm_config_pkg::*;
  
  uvm_config_if if0();

  initial begin
    uvm_config_db#(virtual uvm_config_if)::set(uvm_root::get(), "uvm_test_top.*", "vif", if0);
    run_test(""); // empty test name
  end

endmodule

// vsim -novopt -classdebug +UVM_TESTNAME=uvm_config_test work.uvm_config_ref

// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(86) @ 0: uvm_test_top [BUILD] uvm_config_test build phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(17) @ 0: reporter [CREATE] config_obj type [config_obj] created
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(57) @ 0: uvm_test_top.c1 [CREATE] unit type [c1] created
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(97) @ 0: uvm_test_top [BUILD] uvm_config_test build phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(61) @ 0: uvm_test_top.c1 [BUILD] comp1 build phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(65) @ 0: uvm_test_top.c1 [GETINT] before config get, var1 = 100
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(67) @ 0: uvm_test_top.c1 [GETINT] after config get, var1 = 10
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(70) @ 0: uvm_test_top.c1 [GETOBJ] after config get, cfg.comp1_var = 100
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(29) @ 0: uvm_test_top.c1.c2 [CREATE] unit type [c2] created
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(73) @ 0: uvm_test_top.c1 [BUILD] comp1 build phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(33) @ 0: uvm_test_top.c1.c2 [BUILD] comp2 build phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(37) @ 0: uvm_test_top.c1.c2 [GETINT] before config get, var2 = 200
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(39) @ 0: uvm_test_top.c1.c2 [GETINT] after config get, var2 = 20
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(42) @ 0: uvm_test_top.c1.c2 [GETOBJ] after config get, cfg.comp2_var = 200
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(44) @ 0: uvm_test_top.c1.c2 [BUILD] comp2 build phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(101) @ 0: uvm_test_top [RUN] uvm_config_test run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/uvm_config_ref.sv(105) @ 1000: uvm_test_top [RUN] uvm_config_test run phase exited
// # UVM_INFO verilog_src/uvm-1.1d/src/base/uvm_objection.svh(1268) @ 1000: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
