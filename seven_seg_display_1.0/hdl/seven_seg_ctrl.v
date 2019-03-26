`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2019 10:14:23 AM
// Design Name: 
// Module Name: seven_seg_ctrl
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


module seven_seg_ctrl # (
    parameter integer C_NUM_DIGITS = 4,
    parameter integer C_CLK_FREQ = 100000000,
    parameter integer C_SCAN_FREQ = 1000,
    parameter C_CATHODE_POLARITY = "ACTIVE_LOW",
    parameter C_ANODE_POLARITY = "ACTIVE_LOW"
) (
    input clk,
    input rst_n,
    input mode,
    input en,
    input [C_NUM_DIGITS*8-1:0] digits,
    output reg dp, 
    output reg [6:0] cathode, 
    output reg [3:0] anode
);

// Clock divider
localparam integer C_CLK_DIV = C_CLK_FREQ / (C_SCAN_FREQ * C_NUM_DIGITS * 2);

reg [31:0] counter = 'd0;
reg ssg_clk = 1'b0;

always @ (posedge clk)
begin
    if (rst_n == 1'b0)
        counter <= 'd0;
    else
        counter <= (counter == C_CLK_DIV) ? 'd0 : counter + 1'b1;
end

always @ (posedge clk)
    if(counter == C_CLK_DIV)
        ssg_clk <= ~ssg_clk;
    else
        ssg_clk <= ssg_clk;

// Scan through 7-seg dispay using shift registers
reg [C_NUM_DIGITS*8-1 : 0] digit_i = 'd0;
reg [C_NUM_DIGITS-1 : 0] anode_i = 'd1;

always @ (posedge ssg_clk)
begin
    if(rst_n == 1'b0 || en == 1'b0)
        digit_i <= digits;
    else
    begin
        if(anode_i == {1'b1, {C_NUM_DIGITS-1{1'b0}}})
            digit_i <= digits;
        else
            digit_i <= {digit_i[7:0], digit_i[C_NUM_DIGITS*8-1:8]};
    end
end

// Note: anode_i is active high.
always @ (posedge ssg_clk)
begin
    if(rst_n == 1'b0 || en == 1'b0)
        anode_i <= 'd1;
    else
        anode_i <= {anode_i[C_NUM_DIGITS-2:0], anode_i[C_NUM_DIGITS-1]};
end

// Note: cathode is always active low.
reg [6:0] digit_cathode_i;

always @ (digit_i)
begin
    case(digit_i[3:0])
        4'd0:
            digit_cathode_i = 7'b1000000;
        4'd1:                   
            digit_cathode_i = 7'b1111001;    
        4'd2:                   
            digit_cathode_i = 7'b0100100;    
        4'd3:                   
            digit_cathode_i = 7'b0110000;
        4'd4:                   
            digit_cathode_i = 7'b0011001;
        4'd5:               
            digit_cathode_i = 7'b0010010;
        4'd6:               
            digit_cathode_i = 7'b0000010;
        4'd7:               
            digit_cathode_i = 7'b1111000;
        4'd8:               
            digit_cathode_i = 7'b0000000;
        4'd9:               
            digit_cathode_i = 7'b0010000;
        4'd10:      // A          
            digit_cathode_i = 7'b0001000;
        4'd11:      // b     
            digit_cathode_i = 7'b0000011;
        4'd12:      // C     
            digit_cathode_i = 7'b1000110;
        4'd13:      // d     
            digit_cathode_i = 7'b0100001;
        4'd14:      // E      
            digit_cathode_i = 7'b0000110; 
        4'd15:      // F     
            digit_cathode_i = 7'b0001110;        
        default:
            digit_cathode_i = 7'b1000000;
        endcase
end

// Register and drive output
always @ (posedge ssg_clk)
begin
    if (rst_n == 1'b0 || en == 1'b0)
    begin
        if(C_ANODE_POLARITY == "ACTIVE_LOW")
            anode <= {C_NUM_DIGITS{1'b1}};
        else
            anode <= {C_NUM_DIGITS{1'b0}};
    end
    else
    begin
        if(C_ANODE_POLARITY == "ACTIVE_HIGH")
            anode <= anode_i;
        else
            anode <= ~anode_i;
    end
end

always @ (posedge ssg_clk)
begin
    if (rst_n == 1'b0 || en == 1'b0)
        if(C_CATHODE_POLARITY == "ACTIVE_LOW")
            cathode <= {7{1'b1}};
        else
            cathode <= {7{1'b0}};
    else
    begin
        if(C_CATHODE_POLARITY == "ACTIVE_LOW")
        begin
            if (mode == 1'b1)
                cathode <= digit_i[6:0];
            else
                cathode <= digit_cathode_i;
        end
        else
        begin
            if (mode == 1'b1)
                cathode <= ~digit_i[6:0];
            else
                cathode <= ~digit_cathode_i;
        end 
    end
end

// DP
always @ (posedge ssg_clk)
begin
    if (rst_n == 1'b0 || en == 1'b0)
    begin
        if(C_CATHODE_POLARITY == "ACTIVE_LOW")
            dp <= 1'b1;
        else
            dp <= 1'b0;
    end
    else
    begin
        if(C_CATHODE_POLARITY == "ACTIVE_LOW")
            dp <= digit_i[7];
        else
            dp <= ~digit_i[7];
    end
end

endmodule
