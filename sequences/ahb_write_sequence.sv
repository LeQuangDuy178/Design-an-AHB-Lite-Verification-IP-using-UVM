class ahb_write_sequence extends uvm_sequence #(ahb_transaction);
  `uvm_object_utils(ahb_write_sequence)

  function new(string name="ahb_write_sequence");
    super.new(name);

  endfunction

  virtual task body();
    for(int i=0; i<=4;i=i+4) begin

      //#100ns;
      req = ahb_transaction::type_id::create("req");

      start_item(req);
      req.randomize() with {
        addr == ;
        xact_type == ahb_transaction::WRITE;
        burst_type == ahb_transaction::SINGLE;
        xfer_size == ahb_transaction::SIZE_32BIT;
      };

      `uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
      finish_item(req);

      get_response(rsp);

      //#100ns;
      `uvm_info(get_type_name(), $sformatf("Recevied rsp from driver: \n %s", rsp.sprint()), UVM_LOW);

    end

    //#100ns;
    //`uvm_info(get_type_name(), $sformatf ("Recevied rsp to driver: \n %s", rsp.sprint()), UVM_LOW);

  endtask

endclass