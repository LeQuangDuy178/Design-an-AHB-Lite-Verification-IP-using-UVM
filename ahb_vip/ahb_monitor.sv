class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  // Virtual interface of ahb monitor
  virtual ahb_if ahb_vif;

  /*
  bit xact_type_temp;
  bit [2:0] xfer_size_temp;
  bit [2:0] burst_type_temp; */

  // Transaction to be sent to scoreboard via analysis port
  ahb_transaction trans;

  /*
  * UVM analysis port of monitor passing to analysis export of scoreboard
  *
  */

  uvm_analysis_port #(ahb_transaction) mon_item_observed_port;

  function new(string name="ahb_monitor", uvm_component parent);
    super.new(name, parent);

    // New obj for analysis port
    // No type_id property in built-in port -> no factory style registing
    mon_item_observed_port = new("item_observed_port", this);

  endfunction: new

  virtual function void build_phase(uvm_phase phase);

  super.build_phase(phase);

  // New obj for analysis port
  // No type_id::create() method in built-in port -> no factory style registing
  //mon_item_observed_port = new("mon_item_observed_port", this);

  // New obj for transaction item
  // uvm_object extended -> no phase -> no "this"
  trans = ahb_transaction::type_id::create("observed_trans");

  /* Received virrual interface via uvm_config_db
  * Get ahb_vif with root hierarchy "ahb_vif"

  * And name of vif in ahb monitor -> ahb vif
  * Get vif in "this" component -> ahb monitor

  * Return root hierarchy "uvm_test_top.ahb_env.ahb_agt.monitor.ahb_vif"
  * Get the ahb_vif from the same hierarchical name as the set from ahb_agt

  */
  if (!uvm_config_db#(virtual ahb_if)::get(this, "", "ahb_vif", ahb_vif))
    uvm_fatal(get_type_name(), "Failed to get ahb_vif from uvm_config_db!")

endfunction: build_phase

virtual task run_phase (uvm_phase phase);

  `uvm_info("run_phase", "Entered...", UVM_HIGH)

  forever begin

    /* Perform capturing interface from DUT signal
    * Translate from pin-level activity to transaction level
    * Send to scoreboard via analysis port/export
    * For comparison/data integrity/functional coverage
    * no pin-level signal activity driving in this component
    */

    wait (ahb_vif.HRESETn == 1'b1);
    //`uvm_info("Check", "Time", UVM_LOW)

    /* Start detect new posedge HCLK for next capturing
    * Whenever HEADYOUT is deasserted (before wait state (not = 0))
    * Loop while HREADYOUT = 0 escape loop after = 1 for a while (loop execution)
    * When HREADYOUT = 0 escape loop after = 1 and detect new HCLK
    * Try 1 time first then search for the behavior of HREADYOUT
    * Search for HCLK whenever HTRANS not = 2'h2, start capturing at escaped time
    * Escape loop when HTRANS not = 2'h2, start capturing at escaped time
    * HTRANS = 2'h2 -> Next phase is data phase, exiting address phase
    * Need to capture at the end of address phase */

    do begin 
      @(posedge ahb_vif.HCLK); // 1st: Address phase
      // uvm_info("Check", "Time", UVM_LOW)
      //@(negedge ahb_vif.HCLK);
    end while(!(ahb_vif.HTRANS === 2'h2));
    
    //#1ns; // Slight delay to enable capture correct data
    `uvm_info("Check", "Time", UVM_LOW) // 130ns -> data = 0

    trans.addr = ahb_vif.HADDR; // Trans obj not created yet
    trans.lock = ahb_vif.HMASTLOCK;

    trans.prot = ahb_vif.HPROT;
    //`uvm_info("Check", $sformatf("addr %h", trans.addr), UVM_LOW)

    /* Pin-level behavior ahb_vif.HBURST need to be casted to type enum
    * Before assign to trans property, same as HSIZE and HWRITE

    * Avoid explicit cast */
    /*

    xact_type_temp = ahb_vif.HWRITE;
    xfer_size_temp = ahb_vif.HSIZE;

    burst_type_temp = ahb_vif.HBURST;*/

    $cast(trans.burst_type, ahb_vif.HBURST);
    $cast(trans.xfer_size, ahb_vif.HSIZE);

    $cast(trans.xact_type, ahb_vif.HWRITE);

    @(posedge ahb_vif.HREADYOUT); // 2nd: Data phase (with wait states)
    if (trans.xact_type == ahb_transaction::WRITE) begin

    //#1ns;
    trans.data = ahb_vif.HWDATA;

    end
    else if (trans.xact_type == ahb_transaction::READ) begin

    //@(posedge ahb_vif.HREADYOUT);
    //#1ns;

    trans.data = ahb_vif.HRDATA;
    // Normally HRDATA is captured after HREADYOUT + 1 more HCLK cycle

    end

  //end

  `uvm_info(get_type_name(), $sformatf("Observed transaction: \n %s", trans.sprint()), UVM_HIGH)

    /* Send transaction to scoreboard
    * Call write() method from scoreboard with analysis port of monitor
    *
    */
    mon_item_observed_port.write(trans);

  end
  
    `uvm_info("run_phase", "Exited...", UVM_HIGH)

  endtask : run_phase

endclass : ahb_monitor