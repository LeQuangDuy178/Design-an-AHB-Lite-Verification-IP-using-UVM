package env_pkg;

    import uvm_pkg::*;
    import ahb_pkg::*;

    `include "ahb_scoreboard.sv"
    `include "ahb_environment.sv"

    //`include "ahb_scoreboard.sv"

    // Since ahb_environment instantiate ahb_scoreboard as an object
    // Then we need to include and compile ahb_scoreboard.sv first

endpackage