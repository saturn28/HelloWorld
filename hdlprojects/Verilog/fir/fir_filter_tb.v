/*******************************************************************************
* fir_fiter_tb.v
* Jeff Crockett
* A program to test the concept of the icarus free simulator
* 7/3/2015
*******************************************************************************/
`timescale 100ps/100ps
module fir_filter_tb;
    reg             clk;
    reg             reset_n;
    wire  signed          [15:0]  x;
    reg             valid;
//    reg     [7:0]   ctr;
    reg     [4:0]   ctr;
    wire    [15:0]  d_out;
    
    //Make the clock
    initial begin
        clk <= 1'b0;
        forever #100 clk <= ~clk;
    end
    
    //Set the simulation vectors
    initial begin
        reset_n = 0;
//        x = 16'b0;
        valid = 1'b0;
        #1000 reset_n = 1;
 //       datain[1:0] = 2'b10;
        valid = 1'b1;
        #1000000;
        $stop;
    end
//    always @ (posedge clk or negedge reset_n)
//        if (~reset_n) begin            
//            ctr <= 8'b0;
//        end
//        else begin
//            ctr <= ctr + 1;
//        end
//    assign x = (ctr == 1) ? 16'h7fff:16'h0;
    always @ (posedge clk or negedge reset_n)
        if (~reset_n) begin
            ctr <=  5'b0;
        end
        else begin
            ctr <= ctr + 1;
        end
    assign x = (ctr[4] == 1) ? 16'h0001:16'hFFFF;
    fir_filter fir_filter (
        .d_out      (d_out),
        .x          (x),
        .clk        (clk),
        .reset_n    (reset_n),
        .valid      (valid)
    );

    initial
     $monitor("At time = %t, reset_n = %h, clk = %h, x = %d, d_out = %d\n",
          $time, reset_n, clk, x, d_out);
endmodule
