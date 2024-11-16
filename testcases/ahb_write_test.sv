class ahb_write_test extends ahb_base_test;
  `uvm_component_utils(ahb_write_test)

  ahb_write_sequence write_seq;

  function new(string name="ahb_write_test", uvm_component parent);
    super.new(name, parent);

  endfunction: new

  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    
    write_seq = ahb_write_sequence::type_id::create("write_seq");
    write_seq.start(ahb_env.ahb_agt.sequencer);

    // Delay simulation time
    #1us;

    phase.drop_objection(this);

  endtask

endclass: ahb_write_test