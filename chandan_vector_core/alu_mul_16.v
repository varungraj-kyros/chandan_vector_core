module mul_16_logic #(
parameter N = 8,
parameter WIDTH = 16 
)(
input      clk,
input      reset,
input      start_mul,
input      [N-1:0] M_in,
input      [N-1:0] Q_in,


output reg [WIDTH-1:0] product,
output reg mul_done
);


// ================= Registers =================
reg [N-1:0] A;
reg [N-1:0] Q;
reg Q0;

reg [7:0] count; // fixed counter width


// 2's complement 
wire [N-1:0] M;
wire [N-1:0] negM;
wire [N-1:0] twoM;
wire [N-1:0] neg2M;


assign M = M_in;
assign negM = (~M_in) + 8'b1; // -M using 2's complement
assign twoM = {M_in[N-2:0], 1'b0}; // 2M via shift-left
assign neg2M = (~twoM) + 8'b1; // -2M


// ================= FSM =================
parameter IDLE = 2'b00;
parameter EXEC = 2'b01;
parameter SHIFT = 2'b10;
parameter DONE = 2'b11;


reg [1:0] state;


// ================= Sequential logic =================
always @(posedge clk or posedge reset) 
begin
    if (reset) 
        begin
            state <= IDLE;
            A <= {N{1'b0}};
            Q <= {N{1'b0}};
            Q0 <= 1'b0;
            count <= 8'd0;
            product <= {WIDTH{1'b0}}; 
            mul_done <= 1'b0;

        end 
        else 
        begin
            case (state)


            // -------- IDLE --------
            IDLE: 
        begin
            mul_done <= 1'b0;
                if (start_mul) 
                begin
                A <= {N{1'b0}};
                Q <= Q_in;
                Q0 <= 1'b0;
                count <={1'b0, N[7:1]};// (N >> 1); // allowed constant shift
                state <= EXEC;
                end
        end


            // -------- EXEC --------
            EXEC: 
        begin
            case ({Q[1:0], Q0})


            3'b000,
            3'b111: A <= A;


            3'b101,
            3'b110: A <= A + negM;


            3'b001,
            3'b010: A <= A + M;


            3'b100: A <= A + neg2M;


            3'b011: A <= A + twoM;


            //default: A <= A;
        endcase


        state <= SHIFT;
        end


            // -------- SHIFT --------
            SHIFT: 
        begin
        // arithmetic shift right 
        A <= {A[N-1], A[N-1], A[N-1:2]};
        Q <= {A[1:0], Q[N-1:2]};
        Q0 <= Q[1];


        if (count == 8'd1)
        state <= DONE;
        else
        begin
        count <= count - 8'd1;
        state <= EXEC;
        end
        end


            // -------- DONE --------
            DONE: 
        begin
        product <= {A, Q};
        mul_done <= 1'b1;

        state <= IDLE;
        end



        endcase
        end
end

endmodule

