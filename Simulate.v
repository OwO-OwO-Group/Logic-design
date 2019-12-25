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

      $display("test1");
      #10 coin = 10; // coin 10, total 10 dollars tea
      #10 coin = 5; // coin 5, total 15 dollars tea | coke
      #10 coin = 1; // coin 1, total 16 dollars tea | coke
      #10 coin = 10; // coin 10, total 26 dollars tea | coke | coffee | milk

      #10 coin = 0;
      #10 drink_choose = coffee; // 3 = coffee
      //coffee out
      #10 drink_choose = 0; // exchange 6 dollars

      #10 $display("cancel test");
      #10 coin = 10; // coin 10, total 10 dollars tea
      #10 coin = 5; // coin 5, total 15 dollars tea | coke
      #10 coin = 1; // coin 1, total 16 dollars tea | coke
      #10 coin = 10; // coin 10, total 26 dollars tea | coke | coffee | milk
      #10
      coin = 0;
      cancel = 1; // exchange 26 dollars

      #10
      $display("put some money");
      cancel = 0;
      #10 coin = 10; // coin 10
      #10 coin = 10; // coin 20
      #10 coin = 0; // coin 20
      #10 coin = 10; // coin 30

      #10 coin = 0;
      #10 drink_choose = tea; // 1 = tea

      // tea out
      #10 drink_choose = 0; // exchange 30 - 10 = 20 dollars
      #10 cancel = 0;

      #10 $display("finish");
      $finish;
    end
endmodule
