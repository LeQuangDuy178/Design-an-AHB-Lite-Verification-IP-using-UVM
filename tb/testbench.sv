module testbench;
    import uvm_pkg::*;
    import test_pkg::*;

    ahb_if ahb_vif();

    uart_top u_dut(.HCLK(ahb_vif.HCLK),
                    .HRESETN(ahb_vif.HRESETn),
                    .HADDR(ahb_vif.HADDR),
                    .HBURST (ahb_vif.HBURST),
                    .HTRANS (ahb_vif.HTRANS),
                    .HSIZE(ahb_vif.HSIZE),
                    .HPROT (ahb_vif.HPROT),
                    .HWRITE(ahb_vif.HWRITE),
                    .HWDATA(ahb_vif.HWDATA),
                    .HSEL(ahb_vif.HSEL),
                    .HREADYOUT (ahb_vif.HREADYOUT),
                    .HRDATA(ahb_vif.HRDATA),
                    .HRESP(ahb_vif.HRESP));

    assign ahb_vif.HSEL = 1'b1;

    initial begin
      ahb_vif.HRESETn = 0;
      #100ns ahb_vif.HRESETn = 1;
    end
    
    // 50 MHz
    initial begin
        ahb_vif.HCLK = 0;
        forever begin
          #10ns;
          ahb_vif.HCLK = ~ahb_vif.HCLK;
        end
    end

  initial begin
    /** Set virtual interface to driver for control, learn detail in next session */
    /*
    * Set virtual interface ahb_vif of uvm_test_top hierarchy ("testbench.sv")
    * To uvm_config_db library (Root hierarchical name is "*")
    * Get virtual interface from config_db with "ahb_vif" root hierarchical name
    * The last argument is the name of virtual interface of each component
    * Every component inside test_top (top-down) can access ahb_vif
    * In their class description (including monitor and driver)
    * Null return nothing. "uvm_test_top" "ahb_vif" hierarchical name
    * Declare top root hierachy is "uvm_test_top", not "testbench"
    * As every test class object is created with name "uvm_test_top"
    * Return "uvm_test_top.ahb_vif"
    */
    uvm_config_db#(virtual ahb_if)::set(null, "uvm_test_top", "ahb_vif", ahb_vif);

    /** Start the UVM test */
    run_test();

  end
  
endmodule
