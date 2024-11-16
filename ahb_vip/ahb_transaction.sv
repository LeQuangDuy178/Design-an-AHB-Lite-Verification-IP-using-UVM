class ahb_transaction extends uvm_sequence_item;
  typedef enum bit {
    WRITE = 1
    ,READ = 0
  } xact_type_enum;

  typedef enum bit [2:0] {

    SIZE_8BIT = 3'b000
    ,SIZE_16BIT = 3'b001
    ,SIZE_32BIT = 3'b010
    ,SIZE_64BIT = 3'b011
    ,SIZE_128BIT = 3'b100
    ,SIZE_256BIT = 3'b101
    ,SIZE_512BIT = 3'b110
    ,SIZE_1024BIT = 3'b111
  } xfer_size_enum;

  typedef enum bit [2:0] {

    SINGLE = 3'b000
    ,INCR = 3'b001
    ,WRAP4 = 3'b010
    ,INCR4 = 3'b011
    ,WRAP8 = 3'b100
    ,INCR8 = 3'b101
    ,WRAP16 = 3'b110
    ,INCR16 = 3'b111
  } burst_type_enum;   


  rand bit [AHB_ADDR_WIDTH-1:0] addr;
  rand bit [AHB_DATA_WIDTH-1:0] data;

  rand xact_type_enum xact_type;
  rand xfer_size_enum xfer_size;

  rand burst_type_enum burst_type;
  rand bit [3:0] prot;
  rand bit lock;

  `uvm_object_utils_begin (ahb_transaction)
    `uvm_field_enum (xact_type_enum, xact_type, UVM_ALL_ON | UVM_HEX)
    `uvm_field_enum (xfer_size_enum, xfer_size, UVM_ALL_ON | UVM_HEX)
    `uvm_field_enum (burst_type_enum, burst_type, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int  (addr, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int  (data, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int  (prot, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int  (lock, UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end

  function new(string name="ahb_transaction");
    super.new(name);
  endfunction: new

endclass: ahb_transaction