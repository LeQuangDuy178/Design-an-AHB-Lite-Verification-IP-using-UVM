class ahb_read_test extends ahb_base_test;
  `uvm_component_utils(ahb_read_test)

  ahb_read_sequence read_seq;

  function new(string name="ahb_read_test", uvm_component parent);
    super.new(name, parent);

  endfunction: new

  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this);   


    read_seq = ahb_read_sequence::type_id::create("read_seq");
    read_seq.start(ahb_env.ahb_agt.sequencer);

    #1ns;

    phase.drop_objection(this);

  endtask

endclass: ahb_read_test