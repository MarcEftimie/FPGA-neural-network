`timescale 1ns/1ps
`default_nettype none

module sigmoid_function (clk_i, en, we, reset_i, addr, di, dout);
input wire clk_i;
input wire en;
input wire we;
input wire reset_i;
input wire [9:0] addr; 
input wire [15:0] di;
output logic [15:0] dout;
logic [15:0] ram [0:1023];
initial begin
    $readmemb("./mem/sigmoid.mem", ram);
end
always @(posedge clk_i)
    begin
        if (en) 
        begin
            if (we) 
                ram[addr] <= di;
            if (reset_i) 
                dout <= 0;
            else
                dout <= ram[addr];
        end
    end
endmodule
