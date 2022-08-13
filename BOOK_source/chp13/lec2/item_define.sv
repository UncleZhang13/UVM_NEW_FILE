module item_define;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class bus_trans extends uvm_sequence_item;
    rand bit write;
    rand int data;
    rand int addr;
    rand int delay;
    static int id_num; 
    `uvm_object_utils_begin(bus_trans)
      `uvm_field_int(write, UVM_ALL_ON)
      `uvm_field_int(data, UVM_ALL_ON)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(delay, UVM_ALL_ON)
      `uvm_field_int(id_num, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "bus_trans");
      super.new(name);
      id_num++;
    endfunction
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_phase(uvm_phase phase);
      bus_trans t1, t2, t3;
      phase.raise_objection(phase);
      #100ns;
      t1 = new("t1");
      t1.print();
      #200ns;
      t2 = new("t2");
      void'(t2.randomize());
      t2.print();
      t3 = new("t3");
      t3.copy(t2);
      t3.print();
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule




// # --------------------------------
// # Name      Type       Size  Value
// # --------------------------------
// # t1        bus_trans  -     @391
// #   write   integral   1     'h0
// #   data    integral   32    'h0
// #   addr    integral   32    'h0
// #   delay   integral   32    'h0
// #   id_num  integral   32    'h1
// # --------------------------------
// # -------------------------------------
// # Name      Type       Size  Value
// # -------------------------------------
// # t2        bus_trans  -     @395
// #   write   integral   1     'h0
// #   data    integral   32    'ha061c851
// #   addr    integral   32    'ha0deb9d8
// #   delay   integral   32    'hb485072a
// #   id_num  integral   32    'h2
// # -------------------------------------
// # -------------------------------------
// # Name      Type       Size  Value
// # -------------------------------------
// # t3        bus_trans  -     @399
// #   write   integral   1     'h0
// #   data    integral   32    'ha061c851
// #   addr    integral   32    'ha0deb9d8
// #   delay   integral   32    'hb485072a
// #   id_num  integral   32    'h3
// # -------------------------------------
