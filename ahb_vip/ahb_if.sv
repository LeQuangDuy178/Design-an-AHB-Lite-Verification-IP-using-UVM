interface ahb_if();

    logic                                     HCLK;
    logic                                     HRESETn;
    logic['AHB_ADDR_WIDTH-1:0]                HADDR;
    logic[2:0]                                HBURST;
    logic                                     HMASTLOCK;
    logic [3:0]                               HPROT;
    logic [2:0]                               HSIZE;
    logic[1:0]                                HTRANS;
    logic [AHB_DATA_WIDTH-1:0]                HWDATA;
    logic                                     HWRITE;
    logic[ AHB_DATA_WIDTH-1:0]                HRDATA;
    logic                                     HREADYOUT;
    logic                                     HRESP;
    logic                                     HSEL;

endinterface