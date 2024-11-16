class ahb_environment extends uvm_env;
  `uvm_component_utils(ahb_environment)

  ahb_agent ahb_agt;
  ahb_scoreboard ahb_sco;

  // Virtual interface variable
  virtual ahb_if ahb_vif;

  local string msg = "uart_vip";

  function new(string name="ahb_environment", uvm_component parent);
    super.new(name, parent);

  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info({msg, "build_phase"}, $sformatf("Entered..."), UVM_HIGH)

    /* Get virtual interface from uvm_test_top via uvm_config_db
    * Return "uvm_test_top.ahb_env.ahb_vif" */

    if (!uvm_config_db #(virtual ahb_if)::get(this, "", "ahb_vif", ahb_vif))
      uvm_fatal(get_type_name(), "Failed to get ahb_vif from uvm_config_db!")

    ahb_agt = ahb_agent::type_id::create("ahb_agt", this); // Same as config_db
    ahb_sco = ahb_scoreboard::type_id::create("ahb_sco", this);

    /* Set virtual interface to ahb_agt via uvm_config_db
    * Return "uvm_test_top.ahb_env.ahb_agt.ahb_vif" */
    uvm_config_db #(virtual ahb_if)::set(this, "ahb_agt", "ahb_vif", ahb_vif);

    build_phase `uvm_info("build_phase", "Exiting...", UVM_HIGH)

  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info("connect_phase", "Entered...", UVM_HIGH)

    /* Connect   
    ahb_agent to ahb_scoreboard
    * Indeed, connect TLM analysis port of ahb_monitor
    * To TLM analysis export of ahb_scoreboard through ahb_agt
    * Link hierachy of ahb_sco and monitor through ahb_agt
    * connect() method is built-in method of uvm component

    * Implement port = export
    * Implement port execute something inside called method

    * "port hierarchy".connect("export hierarchy")
    */

    ahb_agt.monitor.mon_item_observed_port.connect(ahb_sco.sco_item_collected_export);
    `uvm_info("ahb_env", "Connecting agent and scoreboard", UVM_LOW)

    `uvm_info("connect_phase", "Enteredd...", UVM_HIGH)
  endfunction: connect_phase

endclass: ahb_environment