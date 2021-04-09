`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 11:30:41 AM
// Design Name: 
// Module Name: EX_pipe_stage
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


module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    wire [31:0] mux1_out;
    wire [31:0] mux2_out;
    wire [31:0] mux3_out;
    wire [3:0] alu_control;
    // Write your code here
    mux4 #(.mux_width(32)) mux1
    (
     .a(reg1),
     .b(mem_wb_write_back_result),
     .c(ex_mem_alu_result),
     .sel(Forward_A),
     .y(mux1_out)
    );
    
    mux4 #(.mux_width(32)) mux2
    (
     .a(reg2),
     .b(mem_wb_write_back_result),
     .c(ex_mem_alu_result),
     .sel(Forward_B),
     .y(mux2_out)
    );
    assign alu_in2_out = mux2_out;
    
    mux2 #(.mux_width(32)) mux3
    (
     .a(mux2_out),
     .b(id_ex_imm_value),
     .sel(id_ex_alu_src),
     .y(mux3_out)
    );
    
    ALUControl alu_control_unit(
    .ALUOp(id_ex_alu_op), 
    .Function(id_ex_instr[5:0]),
    .ALU_Control(alu_control)); 
    
    ALU alu
    (
    .a(mux1_out),  
    .b(mux3_out), 
    .alu_control(alu_control),
    .alu_result(alu_result)
    );
    
 
        
       
endmodule
