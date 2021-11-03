module vsdmemsoc (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    output [9:0] OUT,
    input CLK,
    input reset,
    input init_en,
    input [7:0] init_addr,
    input [31:0] init_data
);

    wire        mem_wr;
    wire [7:0]  mem_addr;
    
    wire [31:0] imem_data;

    controller cntlr (
`ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V supply
        .vssd1(vssd1),	// User area 1 digital ground
`endif
        .OUT(OUT),
        .CLK(CLK),
        .reset(reset),

        .mem_wr(mem_wr),
        .mem_addr(mem_addr),
        .init_en(init_en),
        .init_addr(init_addr),
        .imem_data(imem_data)
    );

    sram_32_256_sky130A mem (
`ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V supply
        .vssd1(vssd1),	// User area 1 digital ground
`endif
        .clk0(CLK),
        .csb0(1'b0),
        .web0(mem_wr),
        .addr0(mem_addr),
        .din0(init_data),
        .dout0(imem_data)
    );
    
endmodule