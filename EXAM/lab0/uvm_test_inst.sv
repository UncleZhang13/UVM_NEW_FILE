
package test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class top extends uvm_test;
    `uvm_component_utils(top)
    function new(string name = "top", uvm_component parent = null);
      super.new(name, parent);
      `uvm_info("UVM_TOP", "UVM TOP creating", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      phase.raise_objection(this); 
      //如果这里不使用raise和drop控制run_phase的话，则这里并不会运行带有时间参量的代码，只会运行在0时刻运行的代码
      `uvm_info("UVM_TOP", "test is running", UVM_LOW)
      phase.drop_objection(this);
    endtask
  endclass

endpackage

module uvm_test_inst;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import test_pkg::*;

  initial begin
    `uvm_info("UVM_TOP", "test started", UVM_LOW)
    run_test("top");
    `uvm_info("UVM_TOP", "test finished", UVM_LOW) //这一行并不会执行，因为UVM中当9个phase结束后，整个环境就会退出
  end

endmodule

