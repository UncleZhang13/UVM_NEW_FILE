
`ifndef APB_MASTER_MONITOR_SV
`define APB_MASTER_MONITOR_SV

function apb_master_monitor::new(string name, uvm_component parent=null);
  super.new(name, parent);
  item_collected_port = new("item_collected_port",this);
  trans_collected = new();
endfunction:new

// build
function void apb_master_monitor::build();
   super.build();
endfunction : build  

task apb_master_monitor::monitor_transactions();

   forever begin
 
      // Extract data from interface into transaction
      collect_transfer();

      // Check transaction
      if (checks_enable)
 	 perform_transfer_checks();

      // Update coverage
      if (coverage_enable)
 	 perform_transfer_coverage();

      // Publish to subscribers
      item_collected_port.write(trans_collected);

   end
endtask // monitor_transactions
   

task apb_master_monitor::run();
  fork
    monitor_transactions();
  join_none
endtask // run
  
  
task apb_master_monitor::collect_transfer();

  void'(this.begin_tr(trans_collected));
  // USER: Extract data and fill ata in apb_transfer trans_collected

  // Advance clock
  @(vif.cb_mon);
  if(vif.cb_slv.psel === 1'b1 &&  vif.cb_slv.penable === 1'b0) begin
    t = apb_transfer::type_id::create("t");
    case(vif.cb_slv.pwrite)
      1'b1: begin
        @(vif.cb_mon);
        t.addr = vif.cb_mon.paddr;
        t.data = vif.cb_mon.pwdata;
        t.trans_kind = WRITE;
      end
      1'b0: begin
        @(vif.cb_mon);
        addr = vif.cb_mon.paddr;
        t.data = vif.cb_mon.pwdata;
        t.trans_kind = READ;
      end
      default: `uvm_error(get_type_name(), "ERROR pwrite signal value")
    endcase
    item_collected_port.write(t);
  end

  // Wait for some start event..., indicate start of transaction
  // void'(this.begin_tr(trans_collected));


  // Wait for some start event..., indicate end of transaction
  // this.end_tr(trans_collected);


endtask // collect_transfer_start_phase


// perform_transfer_checks
function void apb_master_monitor::perform_transfer_checks();

 // USER: do some checks on the transfer here

endfunction : perform_transfer_checks

// perform_transfer_coverage
function void apb_master_monitor::perform_transfer_coverage();

 // USER: coverage implementation
  -> apb_master_cov_transaction;	

endfunction : perform_transfer_coverage

`endif // APB_MASTER_MONITOR_SV

