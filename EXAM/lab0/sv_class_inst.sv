module sv_class_inst;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class top;
    function new();
      `uvm_info("SV_TOP", "SV TOP creating", UVM_LOW)
    endfunction
  endclass

  initial begin
    top t; 
    `uvm_info("SV_TOP", "test started", UVM_LOW)
    t = new();
    `uvm_info("SV_TOP", "test finished", UVM_LOW)
  end
endmodule

// # UVM_INFO ../EXAM/lab0/sv_class_inst.sv(14) @ 0: reporter [SV_TOP] test started
// # UVM_INFO ../EXAM/lab0/sv_class_inst.sv(8) @ 0: reporter [SV_TOP] SV TOP creating
// # UVM_INFO ../EXAM/lab0/sv_class_inst.sv(16) @ 0: reporter [SV_TOP] test finished