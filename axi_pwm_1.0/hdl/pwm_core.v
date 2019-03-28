`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:    
// 
// Create Date: 03/01/2019 10:55:20 AM
// Design Name: 
// Module Name: pwm_core
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
//////////////////////////////  ////////////////////////////////////////////////////

module pwm_core(
    input rst_n,
    input clk,
    input en,
    input [31:0] period,
    input [31:0] pulse_width,
    output reg pwm
);

reg [31:0] counter = 32'd0;

always @ (posedge clk)
begin
    if (rst_n == 1'b0 || en == 1'b0)
        counter <= 32'd0;
    else
        if (counter == period)
            counter <= 32'd0;
        else
            counter <= counter + 1'b1;
end     

always @ (posedge clk)
begin
    if (en == 1'b0 || rst_n == 1'b0)
        pwm <= 1'b0;
    else
        pwm <= (counter < pulse_width) ? 1'b1 : 1'b0;
end

endmodule
