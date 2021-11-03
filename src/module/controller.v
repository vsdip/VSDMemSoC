module controller (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    output [9:0] OUT,
    input CLK,
    input reset,

    output mem_wr,
    output [7:0] mem_addr,
    input init_en,
    input [7:0] init_addr,
    input [31:0] imem_data
);

    wire [7:0]  imem_addr;

    assign mem_wr   = init_en ? 1'b0 : 1'b1;
    assign mem_addr = init_en ? init_addr : imem_addr;

    rvmyth core (
        .OUT(OUT),
        .CLK(CLK),
        .reset(reset),

        .imem_addr(imem_addr),
        .imem_data(imem_data)
    );

endmodule