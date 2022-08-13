
module uvm_compile;

  // NOTE:: it is necessary to import uvm package and macros
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  initial begin
    `uvm_info("UVM", "Hello, welcome to RKV UVM training!", UVM_LOW)
    #1us;
    `uvm_info("UVM", "Bye, and more gifts waiting for you!", UVM_LOW)
  end


endmodule

// # UVM_INFO ../EXAM/lab0/uvm_compile.sv(9) @ 0: reporter [UVM] Hello, welcome to RKV UVM training!
// VSIM 4> run 1us
// # UVM_INFO ../EXAM/lab0/uvm_compile.sv(11) @ 1000: reporter [UVM] Bye, and more gifts waiting for you!