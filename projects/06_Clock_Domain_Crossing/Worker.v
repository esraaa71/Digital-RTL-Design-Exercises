module worker_ip (
    input  wire clk,
    input  wire rst_n,
    input  wire       start_pulse,
    input  wire       cmd_valid,
    input  wire [7:0] cmd_data,
    output reg        done_pulse
);
    reg [7:0] counter;
    reg busy;

    always @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
	        busy       <= 0;
	        done_pulse <= 0;
	    end else begin
	        done_pulse <= 0;
	        if (start_pulse && !busy) begin
	            busy    <= 1;
	        end else if (busy) begin
	            if (counter == 0 && !cmd_valid) begin
	                busy       <= 0;
	                done_pulse <= 1;
	            end 
	        end
	    end
	end

	always @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
	        counter    <= 0;
	    end else begin
	        if (cmd_valid) begin
	            counter <= cmd_data; 
	        end else if (busy) begin
	            if (counter != 0) begin
	                counter <= counter - 1;
	            end 
	        end
	    end
	end

endmodule

