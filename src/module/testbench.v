`timescale 1ns / 1ps
`ifdef PRE_SYNTH_SIM
   `include "vsdmemsoc.v"
   `include "controller.v"
   `include "rvmyth.v"
   `include "sram_32_256_sky130A.v"
   `include "clk_gate.v"
`elsif POST_SYNTH_SIM
   `include "vsdmemsoc.synth.v"
   `include "primitives.v"
   `include "sram_32_256_sky130A.v"
   `include "sky130_fd_sc_hd.v"
`endif

module vsdmemsoc_tb;
	// Inputs
	reg CLK, reset;
	reg init_en;
	reg [7:0] init_addr;
	reg [31:0] init_data;

	// Outputs
	wire [9:0] OUT;

	// Other Signals
	integer i;
	wire [31:0] ROM = 
		i == 32'h0 ? {12'b1, 5'd0, 3'b000, 5'd9, 7'b0010011} :
		i == 32'h1 ? {12'b101011, 5'd0, 3'b000, 5'd10, 7'b0010011} :
		i == 32'h2 ? {12'b0, 5'd0, 3'b000, 5'd11, 7'b0010011} :
		i == 32'h3 ? {12'b0, 5'd0, 3'b000, 5'd17, 7'b0010011} :
		i == 32'h4 ? {7'b0000000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'h5 ? {12'b1, 5'd11, 3'b000, 5'd11, 7'b0010011} :
		i == 32'h6 ? {1'b1, 6'b111111, 5'd10, 5'd11, 3'b001, 4'b1100, 1'b1, 7'b1100011} :
		i == 32'h7 ? {7'b0000000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'h8 ? {7'b0100000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'h9 ? {7'b0100000, 5'd9, 5'd11, 3'b000, 5'd11, 7'b0110011} :
		i == 32'hA ? {1'b1, 6'b111111, 5'd9, 5'd11, 3'b001, 4'b1100, 1'b1, 7'b1100011} :
		i == 32'hB ? {7'b0100000, 5'd11, 5'd17, 3'b000, 5'd17, 7'b0110011} :
		i == 32'hC ? {1'b1, 6'b111111, 5'd0, 5'd0, 3'b000, 4'b0000, 1'b1, 7'b1100011} :
	                 32'd0 ;

    // Instantiate the Unit Under Test (UUT)
	vsdmemsoc uut (
		.OUT(OUT),
		.CLK(CLK),
		.reset(reset),
		.init_en(init_en),
		.init_addr(init_addr),
		.init_data(init_data)
	);

	always @(posedge CLK) begin
		if (i < 32'd16) begin
			i <= i + 32'd1;

			reset <= 1'b1;
			init_en <= 1'b1;
			init_addr <= i;
			init_data <= ROM;
		end
		else if (i < 32'd20) begin
			i <= i + 32'd1;
			init_en <= 1'b0;
		end
		else begin
			reset <= 1'b0;
		end
	end

	initial begin
`ifdef PRE_SYNTH_SIM
    	$dumpfile("pre_synth_sim.vcd");
`elsif POST_SYNTH_SIM
    	$dumpfile("post_synth_sim.vcd");
`endif
    	$dumpvars(0, vsdmemsoc_tb);

		i = 0;
        CLK = 0;
		reset = 0;

        #5000 $finish;
    end
    
	always #5 CLK = ~CLK;

endmodule
