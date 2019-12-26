`timescale 1ns/1ns
module Simulate();
    reg clk, reset;
    reg [31:0] coin;
    reg [2:0] drink_choose;
    reg cancel;

    wire [31:0] change, total_coin;

    parameter no_choose = 3'b000;
    parameter tea = 3'b001;
    parameter coke = 3'b010;
    parameter coffee = 3'b011;
    parameter milk = 3'b100;

    FSM FSM(clk, reset, coin, drink_choose, change, total_coin, cancel);

    always #5 clk = ~clk;
    initial
    begin
      $dumpfile("wave.vcd");
      $dumpvars;
      $display("reset");
      clk = 1;
      reset = 1;
      coin = 0;
      drink_choose = 0;
      cancel = 0;

      #10 reset = 0;
      if (change !== 0) $display("no change");
      if (total_coin !== 0) $display("total_coin must be 0");

      $display("A-3");
      #10 coin = 10; // coin 10, total 10 dollars tea
      #10 coin = 1; // coin 1, total 11 dollars tea
      #10 coin = 5; // coin 5, total 16 dollars tea | coke
      #10 cancel = 1; // exchange 16 dollars

      #10 cancel = 0;
      #10 coin = 5; // coin 5, total 5 dollars
      #10 coin = 5; // coin 5, total 10 dollars tea
      #10 coin = 1; // coin 1, total 11 dollars tea
      #10 coin = 1; // coin 1, total 12 dollars tea
      #10 coin = 10; // coin 10, total 22 dollars tea | coke | coffee
      #10 coin = 0;
      #10 drink_choose = milk; // not enough money
      #10 coin = 10; // coin 10, total 32 dollars tea | coke | coffee | milk
      #10 coin = 0;
      #10 drink_choose = tea; // tea out
      // exchange 22 dollars

      #10 coin = 1; // coin 1, total 1 dollars
      #10 coin = 1; // coin 1, total 2 dollars
      #10 coin = 10; // coin 10, total 12 dollars tea
      #10 coin = 0;
      #10 drink_choose = tea; // tea out
      // exchange 2 dollars

      #10 $display("finish");
      $finish;
    end
endmodule
