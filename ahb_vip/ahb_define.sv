`ifndef GUARD_AHB_DEFINE_SV
`define GUARD_AHB_DEFINE_SV

    `ifndef FORK_GUARD_BEGIN
    `define FORK_GUARD_BEGIN fork begin
    `endif

    `ifndef FORK_GUARD_END
    `define FORK_GUARD_END fork end
    `endif

    `ifndef AHB_ADDR_WIDTH
    `define AHB_ADDR_WIDTH 10
    `endif

    `ifndef AHB_DATA_WIDTH
    `define AHB_DATA_WIDTH 32
    `endif

`endif