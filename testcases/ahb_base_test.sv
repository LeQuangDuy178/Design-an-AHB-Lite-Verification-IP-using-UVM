class ahb_base_test extends uvm_test;
  `uvm_component_utils(ahb_base_test)

  ahb_environment ahb_env;

  // Virtual interface variable
  virtual ahb_if ahb_vif;

  function new(string name="ahb_base_test", uvm_component parent);
    super.new(name, parent);

  endfunction: new

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("build_phase", "Entered...", UVM_HIGH)

    /* Get virtual interface from testbench uvm_test_top via uvm_config_db
    * ahb_base_test or even ahb_write_test will have hierarchy "uvm_test_top"

    * Since in "uvm_test" or even "ahb_write_test" their obj are type_id::create("uvm_test_top", this)
    * This to maintain the test name stability and ease of access to config_db

    * Return "uvm_test_top.ahb_vif" */
    if (!uvm_config_db #(virtual ahb_if)::get(this, "", "ahb_vif", ahb_vif))
      uvm_fatal(get_type_name(), "Failed to get ahb_vif from uvm_config_db!");

    ahb_env = ahb_environment::type_id::create("ahb_env", this);

    /* Set virtual interface to ahb_env via uv_config_db, name test
    * Return "uvm_test_top.ahb_env.ahb_vif"

    * "this" return the hierarchical link to "uvm_test_top"
    * Which is "uvm_test_top."*/

    uvm_config_db #(virtual ahb_if)::set(this, "ahb_env", "ahb_vif", ahb_vif);

    `uvm_info("build_phase", "Exiting...", UVM_HIGH)

  endfunction: build_phase  
  
  virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info("start_of_simulation_phase", "Entered...", UVM_HIGH)
    uvm_top.print_topology();
    `uvm_info("start_of_simulation_phase", "Exiting...", UVM_HIGH)
  endfunction: start_of_simulation_phase

endclass: ahb_base_test