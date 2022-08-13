
`ifndef APB_MASTER_DRIVER_SV
`define APB_MASTER_DRIVER_SV

function apb_master_driver::new (string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

task apb_master_driver::run();
   fork
     get_and_drive();
     reset_signals();
   join_none
endtask : run

task apb_master_driver::get_and_drive();
    uvm_sequence_item item;
    apb_transfer t;

    forever begin
      
      seq_item_port.get_next_item(req);

      // debug
      `uvm_info(get_type_name(), "sequencer got next item", UVM_HIGH)

      // $cast(t, item);
      drive_transfer(req);
      void'($cast(rsp, req.clone()));
      rsp.set_sequence_id(req.get_sequence_id());
      seq_item_port.item_done(rsp);

      // debug
      `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
      // Advance clock
      // send_idle();    
    end
   
endtask : get_and_drive

task apb_master_driver::drive_transfer (apb_transfer t);
  `uvm_info(get_type_name(), "drive_transfer", UVM_HIGH)
  // USER: Add implementation  
  case(t.trans_kind)
    IDLE: this.do_idle();
    WRITE: this.do_write();
    READ: this.do_read();
    default : `uvm_error("ERRTYPE", "unrecognized transaction type")
  endcase
endtask : drive_transfer

task apb_master_driver::do_write(apb_transfer t);
  `uvm_info(get_type_name(), "do_write ...", UVM_HIGH)
  // USER: Add implementation
  @(vif.cb_mst);
  vif.cb_mst.paddr <= t.addr;
  vif.cb_mst.pwrite <= 1;
  vif.cb_mst.psel <= 1;
  vif.cb_mst.penable <= 0;
  vif.cb_mst.pwdata <= t.data;
  @(vif.cb_mst);
  vif.cb_mst.penable <= 1;
  repeat(t.idle_cycles) this.do_idle();
endtask:do_write

task apb_master_driver::do_idle();
  `uvm_info(get_type_name(), "do_idle ...", UVM_HIGH)
  // USER: Add implementation
  @(vif.cb_mst);
  // vif.cb_mst.paddr <= t.addr;
  // vif.cb_mst.pwrite <= 1;
  vif.cb_mst.psel <= 0;
  vif.cb_mst.penable <= 0;
  vif.cb_mst.pwdata <= 0;
  // @(vif.cb_mst);
  // vif.cb_mst.penable <= 1;
  // repeat(t.idle_cycles) this.do_idle();
endtask:do_idle

task apb_master_driver::reset_signals();
  `uvm_info(get_type_name(), "reset_signals ...", UVM_HIGH)
  // USER: Add implementation
  fork
    forever begin
      @(negedge vif.rstn);
      vif.paddr <= 0;
      vif.pwrite <= 0;
      vif.psel <= 0;
      vif.penable <= 0;
      vif.pwdata <= 0;
    end
  join_none
endtask : reset_signals

`endif // APB_MASTER_DRIVER_SV
