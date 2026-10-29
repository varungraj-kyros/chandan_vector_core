module pc_unit( input clk,
    input reset,
    input stall_IFID,
    input [9:0] pc_in,
    output reg [9:0] pc_out);

always@(posedge clk or posedge reset)
begin
    if(reset)
        pc_out<=10'h0;
    else if (!stall_IFID)
        pc_out<=pc_in;
   end
endmodule




