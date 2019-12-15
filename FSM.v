`timescale 1ns/1ns
module FSM(clk, reset, coin, drink_choose, change, total_coin);
    // coin 投入的零錢, drink_choose 輸入要選擇的飲料
    // change 找零, total_coin 顯示目前總共投入多少零錢
    
    input clk, reset;
    input [31:0] coin;
    input [1:0] drink_choose;
    output [31:0] change, total_coin;
    
    reg [31:0] total_coin, change;
    reg [1:0] curr_state, next_state;
    reg [1:0] drink_pass; // 把選擇傳到下一個state

    parameter S0 = 2'b00; // input coin
    parameter S1 = 2'b01; // $display drink that you can buy
    parameter S2 = 2'b10; // buy drink
    parameter S3 = 2'b11; // change
    
    // drink
    parameter tea = 2'b00;
    parameter coke = 2'b01;
    parameter coffee = 2'b10;
    parameter milk = 2'b11;
    
    // state register
    always@(posedge clk) 
        if (reset)  
            curr_state <= S0; 
        else      
            curr_state <= next_state; 
    
    // next state logic
    always@(*)
        case (curr_state)
            S0: begin
                total_coin <= total_coin + coin; // 投錢
                // $display("%d", total_coin) ??
                if (total_coin >= 10) // 高於最低金額
                    next_state = S1;  // 進入S1
                else                  // 金額不足
                    next_state = S0;  // 繼續投錢
            end // S0 end
            
            S1: begin
                $display("money : %d\n", total_coin); // 顯示目前金額
                // 顯示目前能買那些    
                if (total_coin >= 25)
                    $display("tea, coke, coffee, milk\n");
                else if (total_coin >= 20)
                    $display("tea, coke, coffee\n");
                else if (total_coin >= 15)
                    $display("tea, coke\n");
                else if (total_coin >= 10)
                    $display("tea\n");
                    
                // 選擇drink or 繼續投錢
                if (coin != 0) begin
                    drink_pass <= drink_choose;
                    next_state = S2; // 給飲料
                end  // if end
                else // 繼續投錢
                    next_state = S0;
            end // S1 end
        endcase
    
endmodule
