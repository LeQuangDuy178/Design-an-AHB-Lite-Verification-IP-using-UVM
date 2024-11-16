class ahb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(ahb_scoreboard)

  /* TLM analysis export to receive transaction from monitor
  * For multiple analysis export from different monitor analysis port

  * Using macro uvm_analysis_impl_decl(name) for declaring analysis port
  * Export is where transaction is extracted to data properties of sequence

  * Import is where transaction is zipped from data properties of sequence
  * Use uvm_analysis_imp built-in class obj port

  */
  uvm_analysis_imp #(ahb_transaction, ahb_scoreboard) sco_item_collected_export;

  function new(string name = "ahb_scoreboard", uvm_component parent);
    super.new(name, parent);

  endfunction: new

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase); 

    // Obj creating for analysis export
    // No type_id::create property in built-in port/export
    sco_item_collected_export = new("sco_item_collected_export", this);

  endfunction: build_phase

  virtual task run_phase (uvm_phase phase);
  endtask: run_phase

  virtual function void check_phase (uvm_phase phase);
  endfunction: check_phase

  virtual function void report_phase(uvm_phase phase);
  endfunction: report_phase

  // Argument should be pin-level-to-transaction translated transaction in
  /** In monitor passed in so that write method implement using that trans
  * Implement data integrity check/compare with ref model/ SFC inside this */
  extern virtual function void write(ahb_transaction trans);

endclass: ahb_scoreboard

function void ahb_scoreboard::write(ahb_transaction trans);

  // Print out observed transaction from monitor
  // sprint() is built-in method of uvm sequence item
  // When item is registered to uvm_field macro

  `uvm_info(get_type_name(), $sformatf("[write] Get packet from AHB: \n %s", trans.sprint()), UVM_HIGH)

endfunction: write