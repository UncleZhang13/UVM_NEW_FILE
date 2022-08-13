
package phase_order_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp2 extends uvm_component;
    `uvm_component_utils(comp2)
    function new(string name = "comp2", uvm_component parent = null);
      super.new(name, parent);
      `uvm_info("CREATE", $sformatf("unit type [%s] created", name), UVM_LOW)
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("BUILD", "comp2 build phase entered", UVM_LOW)
      `uvm_info("BUILD", "comp2 build phase exited", UVM_LOW)
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("CONNECT", "comp2 connect phase entered", UVM_LOW)
      `uvm_info("CONNECT", "comp2 connect phase exited", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("RUN", "comp2 run phase entered", UVM_LOW)
      `uvm_info("RUN", "comp2 run phase entered", UVM_LOW)
    endtask
    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("REPORT", "comp2 report phase entered", UVM_LOW)
      `uvm_info("REPORT", "comp2 report phase exited", UVM_LOW)   
    endfunction
  endclass
  
  class comp3 extends uvm_component;
    `uvm_component_utils(comp3)
    function new(string name = "comp3", uvm_component parent = null);
      super.new(name, parent);
      `uvm_info("CREATE", $sformatf("unit type [%s] created", name), UVM_LOW)
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("BUILD", "comp3 build phase entered", UVM_LOW)
      `uvm_info("BUILD", "comp3 build phase exited", UVM_LOW)
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("CONNECT", "comp3 connect phase entered", UVM_LOW)
      `uvm_info("CONNECT", "comp3 connect phase exited", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("RUN", "comp3 run phase entered", UVM_LOW)
      `uvm_info("RUN", "comp3 run phase entered", UVM_LOW)
    endtask
    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("REPORT", "comp3 report phase entered", UVM_LOW)
      `uvm_info("REPORT", "comp3 report phase exited", UVM_LOW)   
    endfunction
  endclass
  
  class comp1 extends uvm_component;
    comp2 c2;
    comp3 c3;
    `uvm_component_utils(comp1)
    function new(string name = "comp1", uvm_component parent = null);
      super.new(name, parent);
      `uvm_info("CREATE", $sformatf("unit type [%s] created", name), UVM_LOW)
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("BUILD", "comp1 build phase entered", UVM_LOW)
      c2 = comp2::type_id::create("c2", this);
      c3 = comp3::type_id::create("c3", this);
      `uvm_info("BUILD", "comp1 build phase exited", UVM_LOW)
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("CONNECT", "comp1 connect phase entered", UVM_LOW)
      `uvm_info("CONNECT", "comp1 connect phase exited", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("RUN", "comp1 run phase entered", UVM_LOW)
      `uvm_info("RUN", "comp1 run phase entered", UVM_LOW)
    endtask
    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("REPORT", "comp1 report phase entered", UVM_LOW)
      `uvm_info("REPORT", "comp1 report phase exited", UVM_LOW)   
    endfunction
  endclass

  class phase_order_test extends uvm_test;
    comp1 c1;
    `uvm_component_utils(phase_order_test)
    function new(string name = "phase_order_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("BUILD", "phase_order_test build phase entered", UVM_LOW)
      c1 = comp1::type_id::create("c1", this);
      `uvm_info("BUILD", "phase_order_test build phase exited", UVM_LOW)
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("CONNECT", "phase_order_test connect phase entered", UVM_LOW)
      `uvm_info("CONNECT", "phase_order_test connect phase exited", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("RUN", "phase_order_test run phase entered", UVM_LOW)
      phase.raise_objection(this);
      #1us;
      phase.drop_objection(this);
      `uvm_info("RUN", "phase_order_test run phase exited", UVM_LOW)
    endtask
    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("REPORT", "phase_order_test report phase entered", UVM_LOW)
      `uvm_info("REPORT", "phase_order_test report phase exited", UVM_LOW)    
    endfunction
    
    task reset_phase(uvm_phase phase);
      `uvm_info("RESET", "phase_order_test reset phase entered", UVM_LOW)
      phase.raise_objection(this);
      #1us;
      phase.drop_objection(this);
      `uvm_info("RESET", "phase_order_test reset phase exited", UVM_LOW)
    endtask
    
    task main_phase(uvm_phase phase);
      `uvm_info("MAIN", "phase_order_test main phase entered", UVM_LOW)
      phase.raise_objection(this);
      #1us;
      phase.drop_objection(this);
      `uvm_info("MAIN", "phase_order_test main phase exited", UVM_LOW)
    endtask 
  endclass
endpackage

module phase_order_ref;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import phase_order_pkg::*;

  initial begin
    run_test(""); // empty test name
  end

endmodule

// vsim -novopt -classdebug +UVM_TESTNAME=phase_order_test work.phase_order_ref

// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(102) @ 0: uvm_test_top [BUILD] phase_order_test build phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(68) @ 0: uvm_test_top.c1 [CREATE] unit type [c1] created
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(104) @ 0: uvm_test_top [BUILD] phase_order_test build phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(72) @ 0: uvm_test_top.c1 [BUILD] comp1 build phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(10) @ 0: uvm_test_top.c1.c2 [CREATE] unit type [c2] created
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(38) @ 0: uvm_test_top.c1.c3 [CREATE] unit type [c3] created
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(75) @ 0: uvm_test_top.c1 [BUILD] comp1 build phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(14) @ 0: uvm_test_top.c1.c2 [BUILD] comp2 build phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(15) @ 0: uvm_test_top.c1.c2 [BUILD] comp2 build phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(42) @ 0: uvm_test_top.c1.c3 [BUILD] comp3 build phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(43) @ 0: uvm_test_top.c1.c3 [BUILD] comp3 build phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(19) @ 0: uvm_test_top.c1.c2 [CONNECT] comp2 connect phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(20) @ 0: uvm_test_top.c1.c2 [CONNECT] comp2 connect phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(47) @ 0: uvm_test_top.c1.c3 [CONNECT] comp3 connect phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(48) @ 0: uvm_test_top.c1.c3 [CONNECT] comp3 connect phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(79) @ 0: uvm_test_top.c1 [CONNECT] comp1 connect phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(80) @ 0: uvm_test_top.c1 [CONNECT] comp1 connect phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(108) @ 0: uvm_test_top [CONNECT] phase_order_test connect phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(109) @ 0: uvm_test_top [CONNECT] phase_order_test connect phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(113) @ 0: uvm_test_top [RUN] phase_order_test run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(84) @ 0: uvm_test_top.c1 [RUN] comp1 run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(85) @ 0: uvm_test_top.c1 [RUN] comp1 run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(52) @ 0: uvm_test_top.c1.c3 [RUN] comp3 run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(53) @ 0: uvm_test_top.c1.c3 [RUN] comp3 run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(24) @ 0: uvm_test_top.c1.c2 [RUN] comp2 run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(25) @ 0: uvm_test_top.c1.c2 [RUN] comp2 run phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(126) @ 0: uvm_test_top [RESET] phase_order_test reset phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(117) @ 1000: uvm_test_top [RUN] phase_order_test run phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(130) @ 1000: uvm_test_top [RESET] phase_order_test reset phase exited
// # UVM_INFO verilog_src/uvm-1.1d/src/base/uvm_objection.svh(1268) @ 1000: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(134) @ 1000: uvm_test_top [MAIN] phase_order_test main phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(138) @ 2000: uvm_test_top [MAIN] phase_order_test main phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(29) @ 2000: uvm_test_top.c1.c2 [REPORT] comp2 report phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(30) @ 2000: uvm_test_top.c1.c2 [REPORT] comp2 report phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(57) @ 2000: uvm_test_top.c1.c3 [REPORT] comp3 report phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(58) @ 2000: uvm_test_top.c1.c3 [REPORT] comp3 report phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(89) @ 2000: uvm_test_top.c1 [REPORT] comp1 report phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(90) @ 2000: uvm_test_top.c1 [REPORT] comp1 report phase exited
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(121) @ 2000: uvm_test_top [REPORT] phase_order_test report phase entered
// # UVM_INFO C:/Users/Uncle/Desktop/UVM_File/EXAM/lab1/phase_order_ref.sv(122) @ 2000: uvm_test_top [REPORT] phase_order_test report phase exited
