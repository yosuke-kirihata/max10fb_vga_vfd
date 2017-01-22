`timescale 1ns / 1ps

module vga_out_tb(
    );
    
    reg OSC48M;
    reg RST;
    //wire VSYNCX;
    wire HSYNCX;
	 wire DCLK;
	 //wire DE
    wire [3:0] RED;
    wire [3:0] GREEN;
    wire [3:0] BLUE;

    parameter   OSC48M_PERIOD   = 20834;    // ps

    vga_out vga_out_0(OSC48M, RST, VSYNCX, HSYNCX, DCLK, /*DE,*/ RED, GREEN, BLUE);

    //clock
    initial begin
        OSC48M = 1'b0;
    end

    always #(OSC48M_PERIOD/2) begin
        OSC48M  <= ~OSC48M;
    end

    //reset
    initial begin
        RST = 1;
        repeat(20) @(negedge OSC48M);
        RST = 0;
    end

endmodule