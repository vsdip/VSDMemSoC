//_\TLV_version 1d: tl-x.org, generated by SandPiper(TM) 1.11-2021/01/28-beta
`include "sp_verilog.vh" //_\SV

	//Description: It is a 4-stage pipelined core using RISC-V ISA
	//It can be found in MakerChip.com at : http://makerchip.com/sandbox/01wfphYy2/0qjh8jy

	// This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   // Included URL: "https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/c1719d5b338896577b79ee76c2f443ca2a76e14f/tlv_lib/risc-v_shell_lib.tlv"// Included URL: "https://raw.githubusercontent.com/stevehoover/warp-v_includes/2d6d36baa4d2bc62321f982f78c8fe1456641a43/risc-v_defs.tlv"
   // m4_sv_get_url(['...'])
   // E.g. m4_sv_get_url(m4_swerv_repo['testbench/hex/data.hex'])
   //m4_define(['m4_RISCV_SRAM_repo'], ['['https://raw.githubusercontent.com/MufuteeVC/RISC-V_Core_External_SRAM_IMem/main/']'])
   
   //https://raw.githubusercontent.com/MufuteeVC/RISC-V_Core_External_SRAM_IMem/d54df7cbe4c5acaeb04656f8433c58c8a8d6b83b/testbench/bin/data.bin
   // Downloaded "https://raw.githubusercontent.com/MufuteeVC/RISC-V_Core_External_SRAM_IMem/d54df7cbe4c5acaeb04656f8433c58c8a8d6b83b/testbench/bin/data.bin"
   //https://raw.githubusercontent.com/MufuteeVC/RISC-V_Core_External_SRAM_IMem/d54df7cbe4c5acaeb04656f8433c58c8a8d6b83b/testbench/bin/data.bin
//_\SV ==?
   `include "clk_gate.v"
   //`include "sram_2_16_sky130A.v"  // From: "https://raw.githubusercontent.com/MufuteeVC/RISC-V_Core_External_SRAM_IMem/main/sram_2_16_sky130A.v"
   module top(input wire clk, input wire reset, output wire passed, output wire failed);
   // readmem here
   // E.g. $readmemh("sv_url_inc/data.hex",     imemory.mem);

   //reg [32-1:0]  init_mem [0:16-1];
   //integer     i;

   //initial begin
      //$readmemb("data.bin", imemory.mem);
      //for (i = 0; i < 16-1; i = i + 1)
	//imemory.mem[i] = init_mem[i];
   //end

   //initial
      //begin
      //$readmemb("data.bin", imemory.mem);
      //end                
//\SV_plus                      ",  "(R) ADD r14,r10,r0                      ",  "(I) ADDI r12,r10,1010                   ",  "(R) ADD r13,r10,r0                      ",  "(R) ADD r14,r13,r14                     ",  "(I) ADDI r13,r13,1                      ",  "(B) BLT r13,r12,1111111111000           ",  "(R) ADD r10,r14,r0                      ",  "(S) SW r0,r10,100                       ",  "(I) LW r17,r0,100                       ",  "END                                     "};
            
`include "1_gen.v"
generate //_\TLV
   //$passed = *passed ;
   
   //_|cpu
      //_@0
         assign CPU_reset_a0 = reset;
         //$inv_reset = ! $reset;
         
         assign CPU_pc_a0[31:0] = CPU_reset_a1 ? 0 : 
                     CPU_valid_taken_br_a3 ? CPU_br_tgt_pc_a3 : 
                     CPU_valid_load_a3 ? CPU_incr_pc_a3 : 
                     (CPU_valid_jump_a3 && CPU_is_jal_a3) ? CPU_br_tgt_pc_a3 : 
                     (CPU_valid_jump_a3 && CPU_is_jalr_a3) ? CPU_jalr_tgt_pc_a3 : 
                     CPU_incr_pc_a1; //Program Counter
         
         //$start = $reset ? 0 : ( $reset ^ >>1$reset ) ;
         //$valid = $reset ? 0 : $start ? $start : >>3$valid ;
         
         //?$inv_reset
         assign CPU_imem_rd_en_a0 = !CPU_reset_a0;
         //wire CPU_imem_rd_addr_a0[31:0];
         assign CPU_imem_rd_addr_a0[M4_IMEM_INDEX_CNT-1:0] = CPU_pc_a0[M4_IMEM_INDEX_CNT+1:2];
            
      //_@1
         //?$inv_reset
         assign CPU_instr_a1[31:0] = CPU_imem_rd_data_a1;
         assign CPU_incr_pc_a1[31:0] = CPU_pc_a1 + 32'd4 ;
         
         //Decode
         //Instruction Type
         assign CPU_is_i_instr_a1 = CPU_instr_a1[6:2] == 5'b00000 ||
                       CPU_instr_a1[6:2] == 5'b00001 ||
                       CPU_instr_a1[6:2] == 5'b00100 ||
                       CPU_instr_a1[6:2] == 5'b00110 ||
                       CPU_instr_a1[6:2] == 5'b11001;
         assign CPU_is_r_instr_a1 = CPU_instr_a1[6:2] == 5'b01011 ||
                       CPU_instr_a1[6:2] == 5'b10100 ||
                       CPU_instr_a1[6:2] == 5'b01100 ||
                       CPU_instr_a1[6:2] == 5'b01101;                       
         assign CPU_is_b_instr_a1 = CPU_instr_a1[6:2] == 5'b11000;
         assign CPU_is_u_instr_a1 = CPU_instr_a1[6:2] == 5'b00101 ||
                       CPU_instr_a1[6:2] == 5'b01101;
         assign CPU_is_s_instr_a1 = CPU_instr_a1[6:2] == 5'b01000 ||
                       CPU_instr_a1[6:2] == 5'b01001;
         assign CPU_is_j_instr_a1 = CPU_instr_a1[6:2] == 5'b11011;
      
         assign CPU_imm_a1[31:0] = CPU_is_i_instr_a1 ? {{21{CPU_instr_a1[31]}}, CPU_instr_a1[30:20]} :
                      CPU_is_s_instr_a1 ? {{21{CPU_instr_a1[31]}}, CPU_instr_a1[30:25], CPU_instr_a1[11:7]} :
                      CPU_is_b_instr_a1 ? {{20{CPU_instr_a1[31]}}, CPU_instr_a1[7], CPU_instr_a1[30:25], CPU_instr_a1[11:8],1'b0} :
                      CPU_is_u_instr_a1 ? {CPU_instr_a1[31:12], 12'h000} :
                      CPU_is_j_instr_a1 ? {{12{CPU_instr_a1[31]}}, CPU_instr_a1[19:12], CPU_instr_a1[20], CPU_instr_a1[30:21], 1'b0} : 32'h0 ;
         
         assign CPU_opcode_a1[6:0] = CPU_instr_a1[6:0];
         
         assign CPU_funct3_valid_a1 = CPU_is_r_instr_a1 || CPU_is_i_instr_a1 || CPU_is_s_instr_a1 || CPU_is_b_instr_a1 ;
         assign CPU_funct7_valid_a1 = CPU_is_r_instr_a1 ;
         assign CPU_rs1_valid_a1 = CPU_is_r_instr_a1 || CPU_is_i_instr_a1 || CPU_is_s_instr_a1 || CPU_is_b_instr_a1 ;
         assign CPU_rs2_valid_a1 = CPU_is_r_instr_a1 || CPU_is_s_instr_a1 || CPU_is_b_instr_a1 ;
         assign CPU_rd_valid_a1 = CPU_is_r_instr_a1 || CPU_is_i_instr_a1 || CPU_is_u_instr_a1 || CPU_is_j_instr_a1 ;
         
         //_?$funct3_valid
            assign CPU_funct3_a1[2:0] = CPU_instr_a1[14:12] ;
         
         //_?$funct7_valid
            assign CPU_funct7_a1[6:0] = CPU_instr_a1[31:25] ;
         
         //_?$rs1_valid
            assign CPU_rs1_a1[4:0] = CPU_instr_a1[19:15] ;
         
         //_?$rs2_valid
            assign CPU_rs2_a1[4:0] = CPU_instr_a1[24:20] ;
         
         //_?$rd_valid
            assign CPU_rd_a1[4:0] = CPU_instr_a1[11:7] ;
            
         //Individual Instr Decode
         assign CPU_dec_bits_a1[10:0] = { CPU_funct7_a1[5], CPU_funct3_a1, CPU_opcode_a1 } ;
         
         assign CPU_is_lui_a1 = CPU_dec_bits_a1[6:0] == 7'b0110111;
         assign CPU_is_auipc_a1 = CPU_dec_bits_a1[6:0] == 7'b0010111;
         assign CPU_is_jal_a1 = CPU_dec_bits_a1[6:0] == 7'b1101111;
         assign CPU_is_jalr_a1 = CPU_dec_bits_a1[9:0] == 10'b000_1100111;
         
         //Branch Instructions
         assign CPU_is_beq_a1 = CPU_dec_bits_a1[9:0] == 10'b000_1100011;
         assign CPU_is_bne_a1 = CPU_dec_bits_a1[9:0] == 10'b001_1100011;
         assign CPU_is_blt_a1 = CPU_dec_bits_a1[9:0] == 10'b100_1100011;
         assign CPU_is_bge_a1 = CPU_dec_bits_a1[9:0] == 10'b101_1100011;
         assign CPU_is_bltu_a1 = CPU_dec_bits_a1[9:0] == 10'b110_1100011;
         assign CPU_is_bgeu_a1 = CPU_dec_bits_a1[9:0] == 10'b111_1100011;
         
         //Load == ? -> ==; not yet x -> 0
         assign CPU_is_lb_a1    = CPU_dec_bits_a1[9:0] == 10'b000_0000011 ;
         assign CPU_is_lh_a1    = CPU_dec_bits_a1[9:0] == 10'b001_0000011 ;
         assign CPU_is_lw_a1    = CPU_dec_bits_a1[9:0] == 10'b010_0000011 ;
         assign CPU_is_lbu_a1   = CPU_dec_bits_a1[9:0] == 10'b100_0000011 ;
         assign CPU_is_lhu_a1   = CPU_dec_bits_a1[9:0] == 10'b101_0000011 ;
         
         //Store == ? -> ==; not yet x -> 0
         assign CPU_is_sb_a1    = CPU_dec_bits_a1[9:0] == 10'b000_0100011 ;
         assign CPU_is_sh_a1    = CPU_dec_bits_a1[9:0] == 10'b001_0100011 ;
         assign CPU_is_sw_a1    = CPU_dec_bits_a1[9:0] == 10'b010_0100011 ;
         
         assign CPU_is_addi_a1  = CPU_dec_bits_a1[9:0] == 10'b000_0010011 ;
         assign CPU_is_slti_a1  = CPU_dec_bits_a1[9:0] == 10'b010_0010011 ;
         assign CPU_is_sltiu_a1 = CPU_dec_bits_a1[9:0] == 10'b011_0010011 ;
         assign CPU_is_xori_a1  = CPU_dec_bits_a1[9:0] == 10'b100_0010011 ;
         assign CPU_is_ori_a1   = CPU_dec_bits_a1[9:0] == 10'b110_0010011 ;
         assign CPU_is_andi_a1  = CPU_dec_bits_a1[9:0] == 10'b111_0010011 ;
         assign CPU_is_slli_a1  = CPU_dec_bits_a1 == 11'b0_001_0010011 ;
         assign CPU_is_srli_a1  = CPU_dec_bits_a1 == 11'b0_101_0010011 ;
         assign CPU_is_srai_a1  = CPU_dec_bits_a1 == 11'b1_101_0010011 ;
         
         assign CPU_is_add_a1   = CPU_dec_bits_a1 == 11'b0_000_0110011 ;
         assign CPU_is_sub_a1   = CPU_dec_bits_a1 == 11'b1_000_0110011 ;
         assign CPU_is_sll_a1   = CPU_dec_bits_a1 == 11'b0_001_0110011 ;
         assign CPU_is_slt_a1   = CPU_dec_bits_a1 == 11'b0_010_0110011 ;
         assign CPU_is_sltu_a1  = CPU_dec_bits_a1 == 11'b0_011_0110011 ;
         assign CPU_is_xor_a1   = CPU_dec_bits_a1 == 11'b0_100_0110011 ;
         assign CPU_is_srl_a1   = CPU_dec_bits_a1 == 11'b0_101_0110011 ;
         assign CPU_is_sra_a1   = CPU_dec_bits_a1 == 11'b1_101_0110011 ;
         assign CPU_is_or_a1    = CPU_dec_bits_a1 == 11'b0_110_0110011 ;
         assign CPU_is_and_a1   = CPU_dec_bits_a1 == 11'b0_111_0110011 ;
         
         `BOGUS_USE(CPU_is_lui_a1 CPU_is_auipc_a1 CPU_is_jal_a1 CPU_is_jalr_a1 CPU_is_beq_a1 CPU_is_bne_a1 CPU_is_blt_a1 CPU_is_bge_a1 CPU_is_bltu_a1 CPU_is_bgeu_a1 CPU_is_lb_a1 CPU_is_lh_a1 CPU_is_lw_a1 CPU_is_lbu_a1 CPU_is_lhu_a1 CPU_is_sb_a1 CPU_is_sh_a1 CPU_is_sw_a1 CPU_is_addi_a1 CPU_is_slti_a1 CPU_is_sltiu_a1 CPU_is_xori_a1 CPU_is_ori_a1 CPU_is_andi_a1 CPU_is_slli_a1 CPU_is_srli_a1 CPU_is_srai_a1 CPU_is_add_a1 CPU_is_sub_a1 CPU_is_sll_a1 CPU_is_slt_a1 CPU_is_sltu_a1 CPU_is_xor_a1 CPU_is_srl_a1 CPU_is_sra_a1 CPU_is_or_a1 CPU_is_and_a1)
         
      //_@2
         //Read Reg File
         assign CPU_rf_rd_en1_a2 = CPU_rs1_valid_a2 ;
         //_?$rs1_valid
            assign CPU_rf_rd_index1_a2[4:0] = CPU_rs1_a2 ;
            
         assign CPU_src1_value_a2[31:0] = (CPU_rf_wr_en_a3 && (CPU_rd_a3 == CPU_rs1_a2)) ? CPU_result_a3 : CPU_rf_rd_data1_a2 ; //output 1
         
         assign CPU_rf_rd_en2_a2 = CPU_rs2_valid_a2 ;
         //_?$rs2_valid
            assign CPU_rf_rd_index2_a2[4:0] = CPU_rs2_a2 ;
            
         assign CPU_src2_value_a2[31:0] = (CPU_rf_wr_en_a3 && (CPU_rd_a3 == CPU_rs2_a2)) ? CPU_result_a3 : CPU_rf_rd_data2_a2 ; //output 2
         
         assign CPU_br_tgt_pc_a2[31:0] = CPU_pc_a2 + CPU_imm_a2 ;
         
      //_@3 
         assign CPU_sltu_rslt_a3 = CPU_src1_value_a3 < CPU_src2_value_a3 ;
         assign CPU_sltiu_rslt_a3 = CPU_src1_value_a3 < CPU_imm_a3 ;
         
         assign CPU_result_a3[31:0] = 
                 CPU_is_andi_a3 ? CPU_src1_value_a3 & CPU_imm_a3 :
                 CPU_is_ori_a3 ? CPU_src1_value_a3 | CPU_imm_a3 :
                 CPU_is_xori_a3 ? CPU_src1_value_a3 ^ CPU_imm_a3 :
                 CPU_is_addi_a3 ? CPU_src1_value_a3 + CPU_imm_a3 :
                 CPU_is_slli_a3 ? CPU_src1_value_a3 << CPU_imm_a3 :
                 CPU_is_srli_a3 ? CPU_src1_value_a3 >> CPU_imm_a3 :
                 CPU_is_and_a3 ? CPU_src1_value_a3 & CPU_src2_value_a3 :
                 CPU_is_or_a3 ? CPU_src1_value_a3 | CPU_src2_value_a3 :
                 CPU_is_xor_a3 ? CPU_src1_value_a3 ^ CPU_src2_value_a3 :
                 CPU_is_add_a3 ? CPU_src1_value_a3 + CPU_src2_value_a3 :
                 CPU_is_sub_a3 ? CPU_src1_value_a3 - CPU_src2_value_a3 :
                 CPU_is_sll_a3 ? CPU_src1_value_a3 << CPU_src2_value_a3 :
                 CPU_is_srl_a3 ? CPU_src1_value_a3 >> CPU_src2_value_a3 :
                 CPU_is_sltu_a3 ? CPU_sltu_rslt_a3 :
                 CPU_is_sltiu_a3 ? CPU_sltiu_rslt_a3 :
                 CPU_is_lui_a3 ? { CPU_imm_a3[31:12], 12'b0 } :
                 CPU_is_auipc_a3 ? CPU_pc_a3 + CPU_imm_a3 :
                 CPU_is_jal_a3 ? CPU_pc_a3 + 32'd4 :
                 CPU_is_jalr_a3 ? CPU_pc_a3 + 32'd4 :
                 CPU_is_srai_a3 ? { {32{CPU_src1_value_a3[31]}}, CPU_src1_value_a3 } >> CPU_imm_a3[4:0] :
                 CPU_is_slt_a3 ? (CPU_src1_value_a3[31] == CPU_src2_value_a3[31]) ? CPU_sltu_rslt_a3 : {31'b0, CPU_src1_value_a3[31]} :
                 CPU_is_slti_a3 ? (CPU_src1_value_a3[31] == CPU_imm_a3) ? CPU_sltiu_rslt_a3 : {31'b0, CPU_src1_value_a3[31]} :
                 CPU_is_sra_a3 ? { {32{CPU_src1_value_a3[31]}}, CPU_src1_value_a3 } >> CPU_src2_value_a3[4:0] :
                 32'bx;
         
         
         //Write Reg File
         //$rf_wr_en = $rd_valid && ($rd[4:0] != 5'b00000) && $valid;
         assign CPU_rf_wr_en_a3 = (CPU_rd_valid_a3 && (CPU_rd_a3[4:0] != 5'b00000) && CPU_valid_a3) || CPU_valid_load_a5;
         assign CPU_rf_wr_index_a3[4:0] = !(CPU_valid_load_a5) ? CPU_rd_a3 : CPU_rd_a5;
         assign CPU_rf_wr_data_a3[31:0] = !(CPU_valid_load_a5) ? CPU_result_a3 : CPU_ld_data_a5 ;
         
         //$value[31:0] = $rf_wr_data ;
         //$rf_wr_data[31:0] = $value ;
         //Branching
         assign CPU_taken_br_a3 = CPU_is_beq_a3 ? (CPU_src1_value_a3 == CPU_src2_value_a3) :
                     CPU_is_bne_a3 ? (CPU_src1_value_a3 != CPU_src2_value_a3) :
                     CPU_is_blt_a3 ? (CPU_src1_value_a3 < CPU_src2_value_a3) ^ (CPU_src1_value_a3[31] != CPU_src2_value_a3[31]) :
                     CPU_is_bge_a3 ? (CPU_src1_value_a3 >= CPU_src2_value_a3) ^ (CPU_src1_value_a3[31] != CPU_src2_value_a3[31]) :
                     CPU_is_bltu_a3 ? (CPU_src1_value_a3 < CPU_src2_value_a3) :
                     CPU_is_bgeu_a3 ? (CPU_src1_value_a3 >= CPU_src2_value_a3) : 1'b0 ;
         
         assign CPU_valid_taken_br_a3 = CPU_valid_a3 && CPU_taken_br_a3 ;
         
         assign CPU_valid_a3 = !( CPU_valid_taken_br_a4 || CPU_valid_taken_br_a5 || CPU_valid_load_a4 || CPU_valid_load_a5) ;
         
         assign CPU_is_load_a3 = CPU_is_lb_a3 || CPU_is_lh_a3 || CPU_is_lw_a3 || CPU_is_lbu_a3 || CPU_is_lhu_a3 ;
         //$is_store = $is_sb || $is_sh || $is_sw ;
         assign CPU_valid_load_a3 = CPU_valid_a3 && CPU_is_load_a3;
         
         assign CPU_is_jump_a3 = CPU_is_jal_a3 || CPU_is_jalr_a3 ;
         assign CPU_valid_jump_a3 = CPU_valid_a3 && CPU_is_jump_a3;
         assign CPU_jalr_tgt_pc_a3 = CPU_src1_value_a3 + CPU_imm_a3 ;
         
         
         
      //_@4
         //DMEM
         assign CPU_dmem_wr_en_a4 = CPU_is_s_instr_a4 && CPU_valid_a4 ;
         assign CPU_dmem_addr_a4[3:0] = CPU_result_a4[5:2] ;
         assign CPU_dmem_wr_data_a4[31:0] = CPU_src2_value_a4 ;
         assign CPU_dmem_rd_en_a4 = CPU_is_load_a4 ;
         //$dmem_rd_index[5:0] = ;
         
      //_@5
         assign CPU_ld_data_a5[31:0] = CPU_dmem_rd_data_a5 ;
         
      

      // YOUR CODE HERE
      // ...

      // Note: Because of the magic we are using for visualisation, if visualisation is enabled below,
      //       be sure to avoid having unassigned signals (which you might be using for random inputs)
      //       other than those specifically expected in the labs. You'll get strange errors for these.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   //*passed = *cyc_cnt > 40;
   assign failed = 1'b0;
   assign passed = CPU_Xreg_value_a5[17] == (1+2+3+4+5+6+7+8+9);
   
   // Macro instantiations for:
   //  o instruction memory
   //  o register file
   //  o data memory
   //  o CPU visualization
   //_|cpu 
      // /tmp
      //   @1
      //      $imem_rd_addr[3:0] = 4'b0;
      //      $imem_rd_en = 1'b0;
      //      `BOGUS_USE($imem_rd_data)
      //   m4+imem(@1)    // Args: (read stage)
      
      //_@1
         `BOGUS_USE(CPU_imem_rd_en_a1)
         /*SV_plus*/ //clk0,csb0,web0,addr0,din0,dout0
            sram_32_1024_sky130A imemory(
               32'b0, //clk //din0
               CPU_imem_rd_data_a1[31:0] , //csb0 //dout0
               CPU_imem_rd_addr_a0 , //web0 //addr0
               //4'b0011,
               1'b0, //addr0 //csb0
               1'b1, //din0 //web0
               clk && !reset); //dout0 //clk

            /*sram_32_1024_sky130A imemory(
               clk && !reset, //clk //din0
               1'b0, //csb0 //dout0
               1'b1, //web0 //addr0
               //4'b0011,
               CPU_imem_rd_addr_a0, //addr0 //csb0
               32'b0, //din0 //web0
               CPU_imem_rd_data_a1[31:0]); //dout0 //clk
               //$readmemb("sv_url_inc/data.bin", imemory.mem);
               */
      
      
      //_\source /raw.githubusercontent.com/stevehoover/RISCVMYTHWorkshop/c1719d5b338896577b79ee76c2f443ca2a76e14f/tlvlib/riscvshelllib.tlv 33   // Instantiated from 4.tlv, 286 as: m4+rf(@2, @3)
         // Reg File
         //_@3
            for (xreg = 0; xreg <= 31; xreg=xreg+1) begin : L1_CPU_Xreg //_/xreg

               // For $wr.
               wire L1_wr_a3;
               reg  L1_wr_a4;

               assign L1_wr_a3 = CPU_rf_wr_en_a3 && (CPU_rf_wr_index_a3 != 5'b0) && (CPU_rf_wr_index_a3 == xreg);
               assign CPU_Xreg_value_a3[xreg][31:0] = CPU_reset_a3 ?   xreg           :
                              L1_wr_a3        ?   CPU_rf_wr_data_a3 :
                                             CPU_Xreg_value_a4[xreg][31:0];
            end
         //_@2
            //_?$rf_rd_en1
               assign CPU_rf_rd_data1_a2[31:0] = CPU_Xreg_value_a4[CPU_rf_rd_index1_a2];
            //_?$rf_rd_en2
               assign CPU_rf_rd_data2_a2[31:0] = CPU_Xreg_value_a4[CPU_rf_rd_index2_a2];
            `BOGUS_USE(CPU_rf_rd_data1_a2 CPU_rf_rd_data2_a2) 
      //_\end_source  // Args: (read stage, write stage) - if equal, no register bypass is required
      //_\source /raw.githubusercontent.com/stevehoover/RISCVMYTHWorkshop/c1719d5b338896577b79ee76c2f443ca2a76e14f/tlvlib/riscvshelllib.tlv 50   // Instantiated from 4.tlv, 287 as: m4+dmem(@4)
         // Data Memory
         //_@4
            for (dmem = 0; dmem <= 15; dmem=dmem+1) begin : L1_CPU_Dmem //_/dmem

               // For $wr.
               wire L1_wr_a4;

               assign L1_wr_a4 = CPU_dmem_wr_en_a4 && (CPU_dmem_addr_a4 == dmem);
               assign CPU_Dmem_value_a4[dmem][31:0] = CPU_reset_a4 ?   dmem :
                              L1_wr_a4        ?   CPU_dmem_wr_data_a4 :
                                             CPU_Dmem_value_a5[dmem][31:0];
                                        
            end
            //_?$dmem_rd_en
               assign CPU_dmem_rd_data_a4[31:0] = CPU_Dmem_value_a5[CPU_dmem_addr_a4];
            `BOGUS_USE(CPU_dmem_rd_data_a4)
      //_\end_source    // Args: (read/write stage)
   
      for (imem = 0; imem <= 9; imem=imem+1) begin : L1_CPU_Imem //_/imem

         // For $instr.
         wire [31:0] L1_instr_a1;

         //_@1
            assign L1_instr_a1[31:0] = 32'b0;
      end
   //_\source /raw.githubusercontent.com/stevehoover/RISCVMYTHWorkshop/c1719d5b338896577b79ee76c2f443ca2a76e14f/tlvlib/riscvshelllib.tlv 63   // Instantiated from 4.tlv, 292 as: m4+cpu_viz(@4)
      
      //_|cpu
         // for pulling default viz signals into CPU
         // and then back into viz
         //_@0
            assign {CPU_dummy_a0[0:0], CPU_is_csrrc_a0, CPU_is_csrrci_a0, CPU_is_csrrs_a0, CPU_is_csrrsi_a0, CPU_is_csrrw_a0, CPU_is_csrrwi_a0, CPU_is_store_a0} = {CPUVIZ_Defaults_dummy_a0, CPUVIZ_Defaults_is_csrrc_a0, CPUVIZ_Defaults_is_csrrci_a0, CPUVIZ_Defaults_is_csrrs_a0, CPUVIZ_Defaults_is_csrrsi_a0, CPUVIZ_Defaults_is_csrrw_a0, CPUVIZ_Defaults_is_csrrwi_a0, CPUVIZ_Defaults_is_store_a0};
            `BOGUS_USE(CPU_dummy_a0)
            for (xreg = 0; xreg <= 31; xreg=xreg+1) begin : L1b_CPU_Xreg //_/xreg

               // For $dummy.
               wire [0:0] L1_dummy_a0;
               reg  [0:0] L1_dummy_a1,
                          L1_dummy_a2,
                          L1_dummy_a3,
                          L1_dummy_a4;

               assign {L1_dummy_a0[0:0]} = {L1_CPUVIZ_Defaults_Xreg[xreg].L1_dummy_a0};
            end
            for (dmem = 0; dmem <= 15; dmem=dmem+1) begin : L1b_CPU_Dmem //_/dmem

               // For $dummy.
               wire [0:0] L1_dummy_a0;
               reg  [0:0] L1_dummy_a1,
                          L1_dummy_a2,
                          L1_dummy_a3,
                          L1_dummy_a4;

               assign {L1_dummy_a0[0:0]} = {L1_CPUVIZ_Defaults_Dmem[dmem].L1_dummy_a0};
            end
      // String representations of the instructions for debug.
      /*SV_plus*/
         //logic [40*8-1:0] instr_strs [0:0];
         //assign instr_strs = '{ "END                                     "};
      //_|cpuviz
         //_@1
            for (imem = 0; imem <= -1; imem=imem+1) begin : L1_CPUVIZ_Imem //_/imem

               // For $instr.
               wire [31:0] L1_instr_a1;

               // For $instr_str.
               wire [40*8-1:0] L1_instr_str_a1;
  // TODO: Cleanly report non-integer ranges.
               assign L1_instr_a1[31:0] = L1_CPU_Imem[imem].L1_instr_a1;
               //assign L1_instr_str_a1[40*8-1:0] = instr_strs[imem];
               
            end
   
   
         //_@0
            //_/defaults
               //assign {CPUVIZ_Defaults_is_lui_a0, CPUVIZ_Defaults_is_auipc_a0, CPUVIZ_Defaults_is_jal_a0, CPUVIZ_Defaults_is_jalr_a0, CPUVIZ_Defaults_is_beq_a0, CPUVIZ_Defaults_is_bne_a0, CPUVIZ_Defaults_is_blt_a0, CPUVIZ_Defaults_is_bge_a0, CPUVIZ_Defaults_is_bltu_a0, CPUVIZ_Defaults_is_bgeu_a0, CPUVIZ_Defaults_is_lb_a0, CPUVIZ_Defaults_is_lh_a0, CPUVIZ_Defaults_is_lw_a0, CPUVIZ_Defaults_is_lbu_a0, CPUVIZ_Defaults_is_lhu_a0, CPUVIZ_Defaults_is_sb_a0, CPUVIZ_Defaults_is_sh_a0, CPUVIZ_Defaults_is_sw_a0} = '0;
               //assign {CPUVIZ_Defaults_is_addi_a0, CPUVIZ_Defaults_is_slti_a0, CPUVIZ_Defaults_is_sltiu_a0, CPUVIZ_Defaults_is_xori_a0, CPUVIZ_Defaults_is_ori_a0, CPUVIZ_Defaults_is_andi_a0, CPUVIZ_Defaults_is_slli_a0, CPUVIZ_Defaults_is_srli_a0, CPUVIZ_Defaults_is_srai_a0, CPUVIZ_Defaults_is_add_a0, CPUVIZ_Defaults_is_sub_a0, CPUVIZ_Defaults_is_sll_a0, CPUVIZ_Defaults_is_slt_a0, CPUVIZ_Defaults_is_sltu_a0, CPUVIZ_Defaults_is_xor_a0} = '0;
               //assign {CPUVIZ_Defaults_is_srl_a0, CPUVIZ_Defaults_is_sra_a0, CPUVIZ_Defaults_is_or_a0, CPUVIZ_Defaults_is_and_a0, CPUVIZ_Defaults_is_csrrw_a0, CPUVIZ_Defaults_is_csrrs_a0, CPUVIZ_Defaults_is_csrrc_a0, CPUVIZ_Defaults_is_csrrwi_a0, CPUVIZ_Defaults_is_csrrsi_a0, CPUVIZ_Defaults_is_csrrci_a0} = '0;
               //assign {CPUVIZ_Defaults_is_load_a0, CPUVIZ_Defaults_is_store_a0} = '0;
   
               assign CPUVIZ_Defaults_valid_a0               = 1'b1;
               assign CPUVIZ_Defaults_rd_a0[4:0]             = 5'b0;
               assign CPUVIZ_Defaults_rs1_a0[4:0]            = 5'b0;
               assign CPUVIZ_Defaults_rs2_a0[4:0]            = 5'b0;
               assign CPUVIZ_Defaults_src1_value_a0[31:0]    = 32'b0;
               assign CPUVIZ_Defaults_src2_value_a0[31:0]    = 32'b0;
   
               assign CPUVIZ_Defaults_result_a0[31:0]        = 32'b0;
               assign CPUVIZ_Defaults_pc_a0[31:0]            = 32'b0;
               assign CPUVIZ_Defaults_imm_a0[31:0]           = 32'b0;
   
               assign CPUVIZ_Defaults_is_s_instr_a0          = 1'b0;
   
               assign CPUVIZ_Defaults_rd_valid_a0            = 1'b0;
               assign CPUVIZ_Defaults_rs1_valid_a0           = 1'b0;
               assign CPUVIZ_Defaults_rs2_valid_a0           = 1'b0;
               assign CPUVIZ_Defaults_rf_wr_en_a0            = 1'b0;
               assign CPUVIZ_Defaults_rf_wr_index_a0[4:0]    = 5'b0;
               assign CPUVIZ_Defaults_rf_wr_data_a0[31:0]    = 32'b0;
               assign CPUVIZ_Defaults_rf_rd_en1_a0           = 1'b0;
               assign CPUVIZ_Defaults_rf_rd_en2_a0           = 1'b0;
               assign CPUVIZ_Defaults_rf_rd_index1_a0[4:0]   = 5'b0;
               assign CPUVIZ_Defaults_rf_rd_index2_a0[4:0]   = 5'b0;
   
               assign CPUVIZ_Defaults_ld_data_a0[31:0]       = 32'b0;
               assign CPUVIZ_Defaults_imem_rd_en_a0          = 1'b0;
               //assign CPUVIZ_Defaults_imem_rd_addr_a0[M4_IMEM_INDEX_CNT-1:0] = {M4_IMEM_INDEX_CNT{1'b0}};
               
               for (xreg = 0; xreg <= 31; xreg=xreg+1) begin : L1_CPUVIZ_Defaults_Xreg //_/xreg

                  // For $dummy.
                  wire [0:0] L1_dummy_a0;

                  // For $value.
                  wire [31:0] L1_value_a0;

                  // For $wr.
                  wire L1_wr_a0;

                  assign L1_value_a0[31:0]      = 32'b0;
                  assign L1_wr_a0               = 1'b0;
                  `BOGUS_USE(L1_value_a0 L1_wr_a0)
                  assign L1_dummy_a0[0:0]       = 1'b0;
               end
               for (dmem = 0; dmem <= 15; dmem=dmem+1) begin : L1_CPUVIZ_Defaults_Dmem //_/dmem

                  // For $dummy.
                  wire [0:0] L1_dummy_a0;

                  // For $value.
                  wire [31:0] L1_value_a0;

                  // For $wr.
                  wire L1_wr_a0;

                  //assign L1_value_a0[31:0]      = 32'0;
                  assign L1_wr_a0               = 1'b0;
                  `BOGUS_USE(L1_value_a0 L1_wr_a0) 
                  assign L1_dummy_a0[0:0]       = 1'b0;
               end
               `BOGUS_USE(CPUVIZ_Defaults_is_lui_a0 CPUVIZ_Defaults_is_auipc_a0 CPUVIZ_Defaults_is_jal_a0 CPUVIZ_Defaults_is_jalr_a0 CPUVIZ_Defaults_is_beq_a0 CPUVIZ_Defaults_is_bne_a0 CPUVIZ_Defaults_is_blt_a0 CPUVIZ_Defaults_is_bge_a0 CPUVIZ_Defaults_is_bltu_a0 CPUVIZ_Defaults_is_bgeu_a0 CPUVIZ_Defaults_is_lb_a0 CPUVIZ_Defaults_is_lh_a0 CPUVIZ_Defaults_is_lw_a0 CPUVIZ_Defaults_is_lbu_a0 CPUVIZ_Defaults_is_lhu_a0 CPUVIZ_Defaults_is_sb_a0 CPUVIZ_Defaults_is_sh_a0 CPUVIZ_Defaults_is_sw_a0)
               `BOGUS_USE(CPUVIZ_Defaults_is_addi_a0 CPUVIZ_Defaults_is_slti_a0 CPUVIZ_Defaults_is_sltiu_a0 CPUVIZ_Defaults_is_xori_a0 CPUVIZ_Defaults_is_ori_a0 CPUVIZ_Defaults_is_andi_a0 CPUVIZ_Defaults_is_slli_a0 CPUVIZ_Defaults_is_srli_a0 CPUVIZ_Defaults_is_srai_a0 CPUVIZ_Defaults_is_add_a0 CPUVIZ_Defaults_is_sub_a0 CPUVIZ_Defaults_is_sll_a0 CPUVIZ_Defaults_is_slt_a0 CPUVIZ_Defaults_is_sltu_a0 CPUVIZ_Defaults_is_xor_a0)
               `BOGUS_USE(CPUVIZ_Defaults_is_srl_a0 CPUVIZ_Defaults_is_sra_a0 CPUVIZ_Defaults_is_or_a0 CPUVIZ_Defaults_is_and_a0 CPUVIZ_Defaults_is_csrrw_a0 CPUVIZ_Defaults_is_csrrs_a0 CPUVIZ_Defaults_is_csrrc_a0 CPUVIZ_Defaults_is_csrrwi_a0 CPUVIZ_Defaults_is_csrrsi_a0 CPUVIZ_Defaults_is_csrrci_a0)
               `BOGUS_USE(CPUVIZ_Defaults_is_load_a0 CPUVIZ_Defaults_is_store_a0)
               `BOGUS_USE(CPUVIZ_Defaults_valid_a0 CPUVIZ_Defaults_rd_a0 CPUVIZ_Defaults_rs1_a0 CPUVIZ_Defaults_rs2_a0 CPUVIZ_Defaults_src1_value_a0 CPUVIZ_Defaults_src2_value_a0 CPUVIZ_Defaults_result_a0 CPUVIZ_Defaults_pc_a0 CPUVIZ_Defaults_imm_a0)
               `BOGUS_USE(CPUVIZ_Defaults_is_s_instr_a0 CPUVIZ_Defaults_rd_valid_a0 CPUVIZ_Defaults_rs1_valid_a0 CPUVIZ_Defaults_rs2_valid_a0)
               `BOGUS_USE(CPUVIZ_Defaults_rf_wr_en_a0 CPUVIZ_Defaults_rf_wr_index_a0 CPUVIZ_Defaults_rf_wr_data_a0 CPUVIZ_Defaults_rf_rd_en1_a0 CPUVIZ_Defaults_rf_rd_en2_a0 CPUVIZ_Defaults_rf_rd_index1_a0 CPUVIZ_Defaults_rf_rd_index2_a0 CPUVIZ_Defaults_ld_data_a0)
               `BOGUS_USE(CPUVIZ_Defaults_imem_rd_en_a0 CPUVIZ_Defaults_imem_rd_addr_a0)
               
               assign CPUVIZ_Defaults_dummy_a0[0:0]          = 1'b0;
         //_@4
            assign {CPUVIZ_imm_a4[31:0], CPUVIZ_is_add_a4, CPUVIZ_is_addi_a4, CPUVIZ_is_and_a4, CPUVIZ_is_andi_a4, CPUVIZ_is_auipc_a4, CPUVIZ_is_beq_a4, CPUVIZ_is_bge_a4, CPUVIZ_is_bgeu_a4, CPUVIZ_is_blt_a4, CPUVIZ_is_bltu_a4, CPUVIZ_is_bne_a4, CPUVIZ_is_csrrc_a4, CPUVIZ_is_csrrci_a4, CPUVIZ_is_csrrs_a4, CPUVIZ_is_csrrsi_a4, CPUVIZ_is_csrrw_a4, CPUVIZ_is_csrrwi_a4, CPUVIZ_is_jal_a4, CPUVIZ_is_jalr_a4, CPUVIZ_is_lb_a4, CPUVIZ_is_lbu_a4, CPUVIZ_is_lh_a4, CPUVIZ_is_lhu_a4, CPUVIZ_is_load_a4, CPUVIZ_is_lui_a4, CPUVIZ_is_lw_a4, CPUVIZ_is_or_a4, CPUVIZ_is_ori_a4, CPUVIZ_is_sb_a4, CPUVIZ_is_sh_a4, CPUVIZ_is_sll_a4, CPUVIZ_is_slli_a4, CPUVIZ_is_slt_a4, CPUVIZ_is_slti_a4, CPUVIZ_is_sltiu_a4, CPUVIZ_is_sltu_a4, CPUVIZ_is_sra_a4, CPUVIZ_is_srai_a4, CPUVIZ_is_srl_a4, CPUVIZ_is_srli_a4, CPUVIZ_is_store_a4, CPUVIZ_is_sub_a4, CPUVIZ_is_sw_a4, CPUVIZ_is_xor_a4, CPUVIZ_is_xori_a4, CPUVIZ_pc_a4[31:0], CPUVIZ_rd_a4[4:0], CPUVIZ_rd_valid_a4, CPUVIZ_result_a4[31:0], CPUVIZ_rs1_a4[4:0], CPUVIZ_rs1_valid_a4, CPUVIZ_rs2_a4[4:0], CPUVIZ_rs2_valid_a4, CPUVIZ_src1_value_a4[31:0], CPUVIZ_src2_value_a4[31:0], CPUVIZ_valid_a4} = {CPU_imm_a4, CPU_is_add_a4, CPU_is_addi_a4, CPU_is_and_a4, CPU_is_andi_a4, CPU_is_auipc_a4, CPU_is_beq_a4, CPU_is_bge_a4, CPU_is_bgeu_a4, CPU_is_blt_a4, CPU_is_bltu_a4, CPU_is_bne_a4, CPU_is_csrrc_a4, CPU_is_csrrci_a4, CPU_is_csrrs_a4, CPU_is_csrrsi_a4, CPU_is_csrrw_a4, CPU_is_csrrwi_a4, CPU_is_jal_a4, CPU_is_jalr_a4, CPU_is_lb_a4, CPU_is_lbu_a4, CPU_is_lh_a4, CPU_is_lhu_a4, CPU_is_load_a4, CPU_is_lui_a4, CPU_is_lw_a4, CPU_is_or_a4, CPU_is_ori_a4, CPU_is_sb_a4, CPU_is_sh_a4, CPU_is_sll_a4, CPU_is_slli_a4, CPU_is_slt_a4, CPU_is_slti_a4, CPU_is_sltiu_a4, CPU_is_sltu_a4, CPU_is_sra_a4, CPU_is_srai_a4, CPU_is_srl_a4, CPU_is_srli_a4, CPU_is_store_a4, CPU_is_sub_a4, CPU_is_sw_a4, CPU_is_xor_a4, CPU_is_xori_a4, CPU_pc_a4, CPU_rd_a4, CPU_rd_valid_a4, CPU_result_a4, CPU_rs1_a4, CPU_rs1_valid_a4, CPU_rs2_a4, CPU_rs2_valid_a4, CPU_src1_value_a4, CPU_src2_value_a4, CPU_valid_a4};
            
            for (xreg = 0; xreg <= 31; xreg=xreg+1) begin : L1_CPUVIZ_Xreg //_/xreg

               // For $dummy.
               wire [0:0] L1_dummy_a4;

               // For $value.
               wire [31:0] L1_value_a4;
               reg  [31:0] L1_value_a5;

               // For $wr.
               wire L1_wr_a4;

               assign {L1_dummy_a4[0:0], L1_value_a4[31:0], L1_wr_a4} = {L1b_CPU_Xreg[xreg].L1_dummy_a4, CPU_Xreg_value_a4[xreg], L1_CPU_Xreg[xreg].L1_wr_a4};
               `BOGUS_USE(L1_dummy_a4)
            end
            
            for (dmem = 0; dmem <= 15; dmem=dmem+1) begin : L1_CPUVIZ_Dmem //_/dmem

               // For $dummy.
               wire [0:0] L1_dummy_a4;

               // For $value.
               wire [31:0] L1_value_a4;
               reg  [31:0] L1_value_a5;

               // For $wr.
               wire L1_wr_a4;

               assign {L1_dummy_a4[0:0], L1_value_a4[31:0], L1_wr_a4} = {L1b_CPU_Dmem[dmem].L1_dummy_a4, CPU_Dmem_value_a4[dmem], L1_CPU_Dmem[dmem].L1_wr_a4};
               `BOGUS_USE(L1_dummy_a4)
            end
   
            // m4_mnemonic_expr is build for WARP-V signal names, which are slightly different. Correct them.
            
            assign CPUVIZ_mnemonic_a4[10*8-1:0] = CPUVIZ_is_lui_a4 ? "LUI       " : CPUVIZ_is_auipc_a4 ? "AUIPC     " : CPUVIZ_is_jal_a4 ? "JAL       " : CPUVIZ_is_jalr_a4 ? "JALR      " : CPUVIZ_is_beq_a4 ? "BEQ       " : CPUVIZ_is_bne_a4 ? "BNE       " : CPUVIZ_is_blt_a4 ? "BLT       " : CPUVIZ_is_bge_a4 ? "BGE       " : CPUVIZ_is_bltu_a4 ? "BLTU      " : CPUVIZ_is_bgeu_a4 ? "BGEU      " : CPUVIZ_is_lb_a4 ? "LB        " : CPUVIZ_is_lh_a4 ? "LH        " : CPUVIZ_is_lw_a4 ? "LW        " : CPUVIZ_is_lbu_a4 ? "LBU       " : CPUVIZ_is_lhu_a4 ? "LHU       " : CPUVIZ_is_sb_a4 ? "SB        " : CPUVIZ_is_sh_a4 ? "SH        " : CPUVIZ_is_sw_a4 ? "SW        " : CPUVIZ_is_addi_a4 ? "ADDI      " : CPUVIZ_is_slti_a4 ? "SLTI      " : CPUVIZ_is_sltiu_a4 ? "SLTIU     " : CPUVIZ_is_xori_a4 ? "XORI      " : CPUVIZ_is_ori_a4 ? "ORI       " : CPUVIZ_is_andi_a4 ? "ANDI      " : CPUVIZ_is_slli_a4 ? "SLLI      " : CPUVIZ_is_srli_a4 ? "SRLI      " : CPUVIZ_is_srai_a4 ? "SRAI      " : CPUVIZ_is_add_a4 ? "ADD       " : CPUVIZ_is_sub_a4 ? "SUB       " : CPUVIZ_is_sll_a4 ? "SLL       " : CPUVIZ_is_slt_a4 ? "SLT       " : CPUVIZ_is_sltu_a4 ? "SLTU      " : CPUVIZ_is_xor_a4 ? "XOR       " : CPUVIZ_is_srl_a4 ? "SRL       " : CPUVIZ_is_sra_a4 ? "SRA       " : CPUVIZ_is_or_a4 ? "OR        " : CPUVIZ_is_and_a4 ? "AND       " : CPUVIZ_is_csrrw_a4 ? "CSRRW     " : CPUVIZ_is_csrrs_a4 ? "CSRRS     " : CPUVIZ_is_csrrc_a4 ? "CSRRC     " : CPUVIZ_is_csrrwi_a4 ? "CSRRWI    " : CPUVIZ_is_csrrsi_a4 ? "CSRRSI    " : CPUVIZ_is_csrrci_a4 ? "CSRRCI    " :  CPUVIZ_is_load_a4 ? "LOAD      " : CPUVIZ_is_store_a4 ? "STORE     " : "ILLEGAL   ";
            
            //
            // Register file
            //
            for (xreg = 0; xreg <= 31; xreg=xreg+1) begin : L1b_CPUVIZ_Xreg //_/xreg           
               
            end
            //
            // DMem
            //
            for (dmem = 0; dmem <= 15; dmem=dmem+1) begin : L1b_CPUVIZ_Dmem //_/dmem
               
            end
      
   //_\end_source    // For visualisation, argument should be at least equal to the last stage of CPU logic
endgenerate
                       // @4 would work for all labs
//_\SV
   endmodule
