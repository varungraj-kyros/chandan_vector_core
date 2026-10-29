module stalling (
    input clk,
    input reset,

    // -----------------------------
    // From issue / decode control
    // -----------------------------

    input  ISSUE_REQ,

    input  is_vec_load,
    input  is_vec_store,
    input  is_mul,
    input  is_div,

    // -----------------------------
    // From execution units
    // -----------------------------
    input  mem_done,
    input  mul_16_done_0, mul_16_done_1, mul_16_done_2, mul_16_done_3, mul_32_done_0, mul_32_done_1, mul_64_done_0, mul_64_done_1,
		   div_16_done_0, div_16_done_1, div_16_done_2, div_16_done_3, div_32_done_0, div_32_done_1, div_64_done_0, div_64_done_1,

    // -----------------------------
    // To decode / issue control
    // -----------------------------
    output busy,

    // -----------------------------
    // To execution units
    // -----------------------------
    output reg  start_mem,
    output reg  start_mul,
    output reg  start_div
);

    // --------------------------------------------------
    // Busy flags for long-latency units
    // --------------------------------------------------
    reg mem_busy;
    reg mul_busy_16, mul_busy_32, mul_busy_64;
    reg div_busy_16_0, div_busy_16_1, div_busy_16_2, div_busy_16_3, div_busy_32_0, div_busy_32_1,div_busy_64_0, div_busy_64_1;

    assign busy = mem_busy || mul_busy_16 || mul_busy_32 || mul_busy_64 || div_busy_16_0 || div_busy_16_1 ||div_busy_16_2 ||div_busy_16_3 || div_busy_32_0 || div_busy_32_1 || div_busy_64_0 || div_busy_64_1;

    // --------------------------------------------------
    // Long-latency control FSM (simple, in-order)
    // --------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) 
        begin
            mem_busy    <= 1'b0;
            mul_busy_16 <= 1'b0;
	        mul_busy_32 <= 1'b0;
	        mul_busy_64 <= 1'b0;
	        div_busy_16_0 <= 1'b0;
            div_busy_16_1 <= 1'b0;
div_busy_16_2 <= 1'b0;
div_busy_16_3 <= 1'b0;
	        div_busy_32_0 <= 1'b0;
            div_busy_32_1 <= 1'b0;
	        div_busy_64_0 <= 1'b0;
            div_busy_64_1 <= 1'b0;

            start_mem <= 1'b0;
            start_mul <= 1'b0;
            start_div <= 1'b0;
        end 
        else 
        begin
            // Default: start pulses are 1-cycle wide
            start_mem <= 1'b0;
            start_mul <= 1'b0;
            start_div <= 1'b0;

            // --------------------------------------------------
            // START operations (only if nothing is busy)
            // --------------------------------------------------
            if (ISSUE_REQ && !busy) begin

                // LSU (load / store)
                if (is_vec_load || is_vec_store) 
                begin
                    mem_busy  <= 1'b1;
                    start_mem <= 1'b1;
                end

                // MUL
                else if (is_mul) 
                begin
                    mul_busy_16 <= 1'b1;
			        mul_busy_32 <= 1'b1;
			        mul_busy_64 <= 1'b1;

                    start_mul   <= 1'b1;
                end

                // DIV
                else if (is_div) begin
                    div_busy_16_0 <= 1'b1;
                    div_busy_16_1 <= 1'b1;
div_busy_16_2 <= 1'b1;
div_busy_16_3 <= 1'b1;

		        	div_busy_32_0 <= 1'b1;
                    div_busy_32_1 <= 1'b1;
div_busy_64_0 <= 1'b1;

			        div_busy_64_1 <= 1'b1;
                    start_div   <= 1'b1;
                end
            end

            // --------------------------------------------------
            // CLEAR busy flags
            // --------------------------------------------------
            if (mem_done) begin
                mem_busy <= 1'b0;
            end

            if (mul_16_done_0 || mul_16_done_1 || mul_16_done_2 || mul_16_done_3) 
		    begin
                mul_busy_16 <= 1'b0;
            end
	    	if (mul_32_done_0 || mul_32_done_1)
            begin
            mul_busy_32 <= 1'b0;
            end

            if (mul_64_done_0 || mul_64_done_1)
            begin
            mul_busy_64 <= 1'b0;
            end

		    if (div_16_done_0 )//|| div_16_done_1 || div_16_done_2 || div_16_done_3) 
		    begin
		    div_busy_16_0<=1'b0;
		    end

             if (div_16_done_1 )//|| div_16_done_1 || div_16_done_2 || div_16_done_3) 
		    begin
		    div_busy_16_1<=1'b0;
		    end

             if (div_16_done_2 )//|| div_16_done_1 || div_16_done_2 || div_16_done_3) 
		    begin
		    div_busy_16_2<=1'b0;
		    end

             if (div_16_done_3 )//|| div_16_done_1 || div_16_done_2 || div_16_done_3) 
		    begin
		    div_busy_16_3<=1'b0;
		    end


            if (div_32_done_0)// || div_32_done_1 )
            begin
            div_busy_32_0<=1'b0;
            end

            if (div_32_done_1)// || div_32_done_1 )
            begin
            div_busy_32_1<=1'b0;
            end


            if (div_64_done_0)// || div_64_done_1 )
            begin
            div_busy_64_0<=1'b0;
            end

            if (div_64_done_1)// || div_64_done_1 )
            begin
            div_busy_64_1<=1'b0;
            end


        end
    end
endmodule


