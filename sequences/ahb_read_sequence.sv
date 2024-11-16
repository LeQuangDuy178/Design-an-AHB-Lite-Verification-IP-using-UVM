class ahb_read_sequence extends uvm_sequence #(ahb_transaction);
  `uvm_object_utils(ahb_read_sequence)

  function new(string name="ahb_read_sequence");
    super.new(name);

  endfunction

  virtual task body();
    for(int i=0; i<=4;i=i+4) begin

      req = ahb_transaction::type_id::create("req");
      start_item(req);

      req.randomize() with {
        addr == ;
        xact_type == ahb_transaction::READ;
        burst_type == ahb_transaction::SINGLE;
        xfer_size == ahb_transaction::SIZE_32BIT;
      };

      `uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
      finish_item(req);

      get_response(rsp);
      //#100ns;

      `uvm_info(get_type_name(), $sformatf("Recevied rsp from driver: \n %s", rsp.sprint()), UVM_LOW);
      //#100ns;
      //`uvm_info(get_type_name(), $sformatf("Recevied rsp to driver: \n %s", rsp.sprint()), UVM_LOW);

    end

  endtask

endclass