class ahb_driver extends uvm_driver #(ahb_transaction);
  `uvm_component_utils(ahb_driver)

  // Virtual interface variable
  virtual ahb_if ahb_vif;

  bit [AHB_ADDR_WIDTH-1:0] rdata; // Temp property

  function new(string name="ahb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);   


    /** Applying the virtual interface received through the config   
 db
    * Return "uvm_test_top.ahb_env.ahb_agt.driver.ahb_vif"
    *
    * "this" return hierarchical link from uvm test top to this class
    * Which is "uvm_test_top.ahb_env.ahb_agt.driver." */

    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "ahb_vif", ahb_vif))
      `uvm_fatal(get_type_name(), $sformatf("Failed to get from uvm_config_db. Please check!"))
  endfunction : build_phase

  /** User can use ahb_vif to control real interface like systemverilog part */
virtual task run_phase (uvm_phase phase);

//super.run_phase (phase);

`uvm_info("run_phase", "Entered...", UVM_HIGH)

/* Driver task run_phase
* Receive req from sequence via sequencer

* Base on req receive (req.xact type), perform AHB read/write transfer
* Transfer complete -> send back rsp to sequence (return data also if read)

*/
forever begin

  // At driver TLM port, get request item from sequence
  seq_item_port.get(req);

  // Drive DUT base on transfer xact_type
  if (req.xact_type == ahb_transaction::WRITE) begin

    // Drive DUT
    // 1st: Address phase
    wait (ahb_vif.HRESETn == 1'b1);

    @(posedge ahb_vif.HCLK); #1ns; // More delay for catching signal
    ahb_vif.HADDR = req.addr;

    ahb_vif.HBURST = req.burst_type;
    ahb_vif.HMASTLOCK = req.lock;

    ahb_vif.HPROT = req.prot;
    ahb_vif.HSIZE = req.xfer_size;

    ahb_vif.HTRANS = 2'h2; // HTRANS = 2'h2 -> Initialize transfer in Non-sequential mode
    //ahb_vif.HWDATA = 10'h000; // Actually no driving hwdata this phase

    ahb_vif.HWRITE = req.xact_type;

    // 2nd: Data phase
    // Single transfer: Deassert addr and trans in Data phase

    @(posedge ahb_vif.HCLK); #1ns;
    ahb_vif.HADDR = 10'h000;

    ahb_vif.HBURST = 3'h0;
    ahb_vif.HMASTLOCK = 1'b0;

    ahb_vif.HPROT = 4'h0;
    ahb_vif.HSIZE = 3'h0;
    ahb_vif.HTRANS = 2'h0;

    ahb_vif.HWDATA = req.data; // 32-bit Word
    `uvm_info("ahb_driver", $sformatf("Check HWDATA: 'h%0h", req.data), UVM_LOW)

    ahb_vif.HWRITE = 1'b0;

    // Until HREADYOUT is asserted, HWDATA will be accessed by DUT
    wait (ahb_vif.HREADYOUT == 1'b1);

    //repeat (1) @(posedge ahb_vif.HCLK); // Ending transfer
    //ahb_vif.HWDATA = 32'h0;

  end

  // READ transfer
  else if (req.xact_type == ahb_transaction::READ) begin

    // Drive DUT
    // 1st: Address phase
    wait (ahb_vif.HRESETn == 1'b1);

    @(posedge ahb_vif.HCLK); #1ns; // Also wait for 1 more HCLK tick
    ahb_vif.HADDR = req.addr;

    ahb_vif.HBURST = req.burst_type;
    ahb_vif.HMASTLOCK = req.lock;

    ahb_vif.HPROT = req.prot;
    ahb_vif.HSIZE = req.xfer_size;

    ahb_vif.HTRANS = 2'h2;
    //ahb_vif.HWDATA = xxxx;

    ahb_vif.HWRITE = req.xact_type;

    // 2nd: Data phase
    @(posedge ahb_vif.HCLK); #1ns;

    ahb_vif.HADDR = 10'h000;
    ahb_vif.HBURST = 3'h0;
    ahb_vif.HMASTLOCK = 1'b0;
    ahb_vif.HTRANS = 2'h0;

    ahb_vif.HPROT = 4'h0;
    ahb_vif.HSIZE = 3'h0;

    // Wait for HREADYOUT as wait states, assign HRDATA to rsp
    wait (ahb_vif.HREADYOUT == 1'b1);
    rdata = ahb_vif.HRDATA;

    `uvm_info("ahb_driver", $sformatf("Check HRDATA: 'h%0h", rdata), UVM_LOW);
    //repeat (1) @(posedge ahb_vif.HCLK);

  end

  // Cloning req to rsp
  $cast(rsp, req.clone());

    if (rsp.xact_type == ahb_transaction::READ) begin
    rsp.data = rdata; // Also assign read data
    `uvm_info("ahb_driver", $sformatf("Check rsp HRDATA: 'h%0h", rsp.data), UVM_LOW)
    end

    // Set id info for rsp same as req for FIFO check at sequencer
    rsp.set_id_info(req); // set_id_info() from uvm_sequence_item

    // Put back response item to sequence through TLM export of sequencer
    seq_item_port.put(rsp);

  end

    `uvm_info("run_phase", "Exited...", UVM_HIGH)

  endtask : run_phase

endclass : ahb_driver