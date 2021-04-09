`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 07:28:46 AM
// Design Name: 
// Module Name: pipe_reg_en
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

module pipe_reg_en #(parameter WIDTH = 8)(
    input clk, reset,
    input en, flush,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
    );
    
    always @(posedge clk or posedge reset)  
    begin   
        if(reset)   
            q <= 0; 
        else if (flush) 
            q <= 0;
        else if (en)
            q <= d;  
    end  
endmodule