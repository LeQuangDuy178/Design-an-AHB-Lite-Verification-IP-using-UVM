class ahb_combine_test extends ahb_base_test;
  `uvm_component_utils(ahb_combine_test)

  ahb_write_sequence write_seq; // Act as write API
  ahb_read_sequence read_seq; // Act as read API

  function new(string name="ahb_combine_test", uvm_component parent);
    super.new(name, parent);

  endfunction: new

  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this);   


    write_seq = ahb_write_sequence::type_id::create("write_seq");
    write_seq.start(ahb_env.ahb_agt.sequencer);

    read_seq = ahb_read_sequence::type_id::create("read_seq");
    read_seq.start(ahb_env.ahb_agt.sequencer);

    #1us;

    phase.drop_objection(this);

  endtask

endclass: ahb_combine_test