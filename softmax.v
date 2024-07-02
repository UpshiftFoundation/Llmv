module softmax (
    input clk,
    input rst_n,
    input [31:0] x_in[0:SIZE-1],
    output reg [31:0] x_out[0:SIZE-1]
);
    parameter SIZE = 128;

    // Internal registers
    reg [31:0] max_val;
    reg [31:0] sum;
    reg [31:0] exp_val[0:SIZE-1];
    integer i;

    // State machine states
    typedef enum reg [1:0] {
        IDLE,
        FIND_MAX,
        COMPUTE_EXP,
        NORMALIZE
    } state_t;
    state_t state, next_state;

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = FIND_MAX;
            FIND_MAX: next_state = COMPUTE_EXP;
            COMPUTE_EXP: next_state = NORMALIZE;
            NORMALIZE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output and intermediate computations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            max_val <= 0;
            sum <= 0;
            for (i = 0; i < SIZE; i = i + 1) begin
                x_out[i] <= 0;
                exp_val[i] <= 0;
            end
        end else begin
            case (state)
                FIND_MAX: begin
                    max_val <= x_in[0];
                    for (i = 1; i < SIZE; i = i + 1) begin
                        if (x_in[i] > max_val) begin
                            max_val <= x_in[i];
                        end
                    end
                end
                COMPUTE_EXP: begin
                    sum <= 0;
                    for (i = 0; i < SIZE; i = i + 1) begin
                        exp_val[i] <= expf(x_in[i] - max_val); // Requires floating-point exp function
                        sum <= sum + exp_val[i];
                    end
                end
                NORMALIZE: begin
                    for (i = 0; i < SIZE; i = i + 1) begin
                        x_out[i] <= exp_val[i] / sum; // Requires floating-point division
                    end
                end
            endcase
        end
    end
endmodule