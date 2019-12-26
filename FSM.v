`timescale 1ns/1ns
module FSM(clk, reset, coin, drink_choose, change, total_coin, cancel);
    // coin 投入的零錢, drink_choose 輸入要選擇的飲料
    // change 找零, total_coin 顯示目前總共投入多少零錢
    
    input clk, reset, cancel;
    input [31:0] coin;
    input [2:0] drink_choose;
    output [31:0] change, total_coin;
    
    reg [31:0] total_coin, change;
    reg [1:0] state;
    reg [2:0] drink_pass; // 把選擇傳到下一個state

    parameter S0 = 2'b00; // input coin
    parameter S1 = 2'b01; // $display drink that you can buy
    parameter S2 = 2'b10; // buy drink
    parameter S3 = 2'b11; // change
    
    // drink
    parameter no_choose = 3'b000;
    parameter tea = 3'b001;
    parameter coke = 3'b010;
    parameter coffee = 3'b011;
    parameter milk = 3'b100;
    
    // state register
    always @(posedge reset) begin
        if (reset) begin
            state <= S0;
            total_coin <= 0;
            change <= 0;
        end
    end

    // next state logic
    always @(clk or coin or drink_choose)
        case (state)
            S0: begin
                if (clk == 0) begin
                    total_coin = total_coin + coin; // 投錢
                  $display("coin %d", total_coin); // 顯示目前金額
                end

                if (cancel == 1)
                  state <= S3;
                else if (total_coin >= 10) // 高於最低金額
                    state <= S1;  // 進入S1
                else                  // 金額不足
                    state <= S0;  // 繼續投錢
            end // S0 end
            
            S1: begin
                // 顯示目前能買那些    
                if (total_coin >= 25)
                    $display("tea | coke | coffee | milk");
                else if (total_coin >= 20)
                    $display("tea | coke | coffee");
                else if (total_coin >= 15)
                    $display("tea | coke");
                else if (total_coin >= 10)
                    $display("tea");
                    
                // 選擇drink or 繼續投錢
                if (coin == 0 && drink_choose != no_choose) begin
                    drink_pass <= drink_choose;


                    if ((drink_pass == tea && total_coin >= 10) ||
                        (drink_pass == coke && total_coin >= 15) ||
                        (drink_pass == coffee && total_coin >= 20) ||
                        (drink_pass == milk && total_coin >= 25)
                      )
                      state <= S2; // 給飲料
                    else begin
                      state <= S0;
                      $display("not enough\n");
                    end
                end  // if end
                else // 繼續投錢
                    state <= S0;
            end // S1 end

            S2: begin
              case (drink_pass)
                tea: begin
                  $display("tea out");
                  total_coin = total_coin - 10;
                end

                coke: begin
                  $display("coke out");
                  total_coin = total_coin - 15;
                end

                coffee: begin
                  $display("coffee out");
                  total_coin = total_coin - 20;
                end

                milk: begin
                  $display("milk out");
                  total_coin = total_coin - 25;
                end
              endcase
              state <= S3;
            end

            S3: begin
              $display("exchange %d dollars", total_coin);
              total_coin <= 0;
              state <= S0;
            end
        endcase
    
endmodule
