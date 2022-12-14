module set_config_variable;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component; 
    int val1 = 1;
    string str1 = "null";
    `uvm_component_utils_begin(comp1)
      `uvm_field_int(val1, UVM_ALL_ON)
      // `uvm_field_string(str1, UVM_ALL_ON) //如果注册时声明了，则set的时候同步更新
    `uvm_component_utils_end
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("SETVAL", $sformatf("val1 is %d before get", val1), UVM_LOW)
      `uvm_info("SETVAL", $sformatf("str1 is %s before get", str1), UVM_LOW)
      get_config_string("str1", str1);
      `uvm_info("SETVAL", $sformatf("val1 is %d after get", val1), UVM_LOW)
      `uvm_info("SETVAL", $sformatf("str1 is %s after get", str1), UVM_LOW)
    endfunction
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    comp1 c1;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      uvm_component::print_config_matches = 1;
      set_config_int("c1", "val1", 100);
      set_config_string("c1", "str1", "comp1");
      c1 = comp1::type_id::create("c1", this);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule



// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_WARNING @ 0: uvm_test_top [UVM/CFG/SET/DPR] get/set_config_* API has been deprecated. Use uvm_config_db instead.
// UVM_INFO @ 0: uvm_test_top.c1 [CFGAPL] applying configuration settings
// UVM_INFO @ 0: uvm_test_top.c1 [CFGAPL] applying configuration to field val1
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] val1 is         100 before get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] str1 is null before get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] val1 is         100 after get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] str1 is comp1 after get
