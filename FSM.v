`timescale 1ns/1ns
module FSM(clk, coin, drink_choose, change, total_coin);
    // coin 投入的零錢, drink_choose 輸入要選擇的飲料
	// change 找零, total_coin 顯示目前總共投入多少零錢
	
    input clk, coin, drink_choose;
    output change, total_coin;
	
    reg total_coin, change;
    reg [1:0] curr_state;
    reg [1:0] next_state;

    parameter S0 = 2'b00; // input coin
    parameter S1 = 2'b01; // $display drink that you can buy
    parameter S2 = 2'b10; // buy drink
    parameter S3 = 2'b11; // change
	
	
	
endmodule