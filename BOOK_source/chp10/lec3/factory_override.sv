
module factory_override;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component;
    `uvm_component_utils(comp1)
    function new(string name="comp1", uvm_component parent=null);
      super.new(name, parent);
      $display($sformatf("comp1:: %s is created", name));
    endfunction: new
    virtual function void hello(string name);
      $display($sformatf("comp1:: %s said hello!", name));
    endfunction
  endclass

  class comp2 extends comp1;
    `uvm_component_utils(comp2)
    function new(string name="comp2", uvm_component parent=null);
      super.new(name, parent); // 因此这里会多显示一个 comp1:: %s is created
      $display($sformatf("comp2:: %s is created", name));
    endfunction: new
    function void hello(string name);
      $display($sformatf("comp2:: %s said hello!", name));
    endfunction
  endclass
 
  comp1 c1, c2, c3;

  initial begin
    comp1::type_id::set_type_override(comp2::get_type());

    c1 = comp1::type_id::create("c1", null);
    c2 = comp1::type_id::create("c2", null);
    c3 = new("c3"); 
    c1.hello("c1");
    c2.hello("c2");
    c3.hello("c3"); // 用new是不用完成覆盖的，factory中的create机制在创建对象的时候会查询对象是否被覆盖
  end

endmodule

// # comp1:: c1 is created
// # comp2:: c1 is created
// # comp1:: c2 is created
// # comp2:: c2 is created
// # comp1:: c3 is created
// # comp2:: c1 said hello!
// # comp2:: c2 said hello!
// # comp1:: c3 said hello!
