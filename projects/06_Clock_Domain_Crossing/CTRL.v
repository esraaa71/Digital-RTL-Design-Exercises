module ctrl_ip (
    input  wire clk,
    input  wire rst_n,
    output reg        start_pulse,
    output reg        cmd_valid,
    output reg [7:0]  cmd_data,
    input  wire       cmd_ready,
    input  wire       done_pulse
);

    // -------------------------------------------------
    // State encoding (Verilog style)
    // -------------------------------------------------
    localparam STATE_IDLE      = 2'b00;
    localparam STATE_SEND_CMD  = 2'b01;
    localparam STATE_WAIT_DONE = 2'b10;

    reg [1:0] state;

    // -------------------------------------------------
    // Sequential FSM
    // -------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= STATE_IDLE;
            start_pulse <= 1'b0;
            cmd_valid   <= 1'b0;
            cmd_data    <= 8'h00;
        end else begin
            // Default deassert for pulse
            start_pulse <= 1'b0;

            case (state)

                // -------------------------------------
                // IDLE: send command
                // -------------------------------------
                STATE_IDLE: begin
                    cmd_data  <= 8'hA5;
                    cmd_valid <= 1'b1;

                    if (cmd_ready)
                        state <= STATE_SEND_CMD;
                end

                // -------------------------------------
                // SEND_CMD: generate start pulse
                // -------------------------------------
                STATE_SEND_CMD: begin
                    start_pulse <= 1'b1;
                    state       <= STATE_WAIT_DONE;
                end

                // -------------------------------------
                // WAIT_DONE: wait for worker
                // -------------------------------------
                STATE_WAIT_DONE: begin
                    if (done_pulse) begin
                    	cmd_valid   <= 1'b0;
                        state <= STATE_IDLE;
                    end 
                end

                // -------------------------------------
                // Safety default
                // -------------------------------------
                default: begin
                    state <= STATE_IDLE;
                end
            endcase
        end
    end
endmodule
