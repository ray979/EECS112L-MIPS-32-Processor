`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 10:37:51 AM
// Design Name: 
// Module Name: ID_pipe_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_pipe_stage(
    input  clk, reset,
    input  [9:0] pc_plus4,
    input  [31:0] instr,
    input  mem_wb_reg_write,
    input  [4:0] mem_wb_write_reg_addr,
    input  [31:0] mem_wb_write_back_data,
    input  Data_Hazard,
    input  Control_Hazard,
    output [31:0] reg1, reg2,
    output [31:0] imm_value,
    output [9:0] branch_address,
    output [9:0] jump_address,
    output branch_taken,
    output [4:0] destination_reg, 
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,  
    output mem_write,
    output alu_src,
    output reg_write,
    output jump
    );
    
    wire eq_test;
    wire reg_dst;
    wire branch;
    wire [1:0] w_alu_op; 
    wire w_mem_to_reg, w_mem_read, w_mem_write, w_alu_src, w_reg_write;
    wire [31:0] imm_value_shifted;
    // write your code here 
    register_file reg_file(
    .clk(clk), 
    .reset(reset),  
    .reg_write_en(mem_wb_reg_write),  
    .reg_write_dest(mem_wb_write_reg_addr),  
    .reg_write_data(mem_wb_write_back_data),
    .reg_read_addr_1(instr[25:21]), 
    .reg_read_addr_2(instr[20:16]),  
    .reg_read_data_1(reg1),  
    .reg_read_data_2(reg2) 
    );
    

    assign eq_test = (( reg1 ^ reg2 )==32'd0) ? 1'b1: 1'b0;
    
    
    control control_unit(
    .reset(reset),
    .opcode(instr[31:26]),  
    .reg_dst(reg_dst), 
    .mem_to_reg(w_mem_to_reg), 
    .alu_op(w_alu_op),  
    .mem_read(w_mem_read), 
    .mem_write(w_mem_write), 
    .alu_src(w_alu_src), 
    .reg_write(w_reg_write), 
    .branch(branch),
    .jump(jump) 
    );
    

    mux2 #(.mux_width(1)) h_mux1
    (
     .a(w_mem_to_reg),
     .b(1'b0),
     .sel(~Data_Hazard | Control_Hazard),
     .y(mem_to_reg)
    );
    
    mux2 #(.mux_width(1)) h_mux2
    (
     .a(w_mem_read),
     .b(1'b0),
     .sel(~Data_Hazard | Control_Hazard),
     .y(mem_read)
    );
    
    mux2 #(.mux_width(1)) h_mux3
    (
     .a(w_mem_write),
     .b(1'b0),
     .sel(~Data_Hazard| Control_Hazard),
     .y(mem_write)
    );
    
    mux2 #(.mux_width(1)) h_mux4
    (
     .a(w_alu_src),
     .b(1'b0),
     .sel(~Data_Hazard | Control_Hazard),
     .y(alu_src)
    );
    
    mux2 #(.mux_width(1)) h_mux5
    (
     .a(w_reg_write),
     .b(1'b0),
     .sel(~Data_Hazard | Control_Hazard),
     .y(reg_write)
    );
    
    mux2 #(.mux_width(2)) h_mux6
    (
     .a(w_alu_op),
     .b(2'b00),
     .sel(~Data_Hazard | Control_Hazard),
     .y(alu_op)
    );
 
    
    assign branch_taken = eq_test & branch;
    assign jump_address = {instr[25:0],2'b00};
    
    sign_extend sign_ex_inst (
        .sign_ex_in(instr[15:0]),
        .sign_ex_out(imm_value));
        
 
    assign imm_value_shifted = imm_value<<2;
    assign branch_address = imm_value_shifted[9:0] + pc_plus4;
    
    mux2 #(.mux_width(5)) reg_dst_mux
    (
     .a(instr[20:16]),
     .b(instr[15:11]),
     .sel(reg_dst),
     .y(destination_reg)
    );
    
    // Remember that we test if the branch is taken or not in the decode stage. 	
       
endmodule
