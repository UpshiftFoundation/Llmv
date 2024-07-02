// Should I be using a state machine?
/*
module rmsnorm(
     input clk,
     input rst_n, 
     input [31:0] x_in [0:SIZE-1],
     input [31:0] weight [0:SIZE-1]
     output [31:0] o [0:SIZE-1]
);
    parameter SIZE = 128;

    reg [31:0] ss = 0;
    integer j;


    for (j=0; j<size; j=j+1) begin
        ss += x_in[j] * x_in[j];
    end
    ss /= size; 
    ss += 0.00001;
    ss = 1/ sqrt(ss);
    for (j=0; j<size; j=j+1) begin
        o[j] = weight[j] * (ss * x_in[j]);
    end 



endmodule
*/

/* Karpathy C code for rmsnorm
void rmsnorm(float* o, float* x, float* weight, int size) {
    // calculate sum of squares
    float ss = 0.0f;
    for (int j = 0; j < size; j++) {
        ss += x[j] * x[j];
    }
    ss /= size;
    ss += 1e-5f;
    ss = 1.0f / sqrtf(ss);
    // normalize and scale
    for (int j = 0; j < size; j++) {
        o[j] = weight[j] * (ss * x[j]);
    }
}
*/

// Should I be using a state machine?
module rmsnorm(
     input clk,
     input rst_n, 
     input [31:0] x_in [0:SIZE-1],
     input [31:0] weight [0:SIZE-1]
     output [31:0] o [0:SIZE-1]
);
    parameter SIZE = 128;

    reg [31:0] ss;
    reg [31:0] ss_temp;
    integer j;

    typedef enum reg [1:0] {
        IDLE,
        SUM_OF_SQUARES,
        NORM_SCALE
    } states;
    states state, nextstate;

    // do a 3 process state machine 

    // reset state
    always @ (posedge or posedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= nextstate;
        end
    end

    // Next state 
    always @(*) begin
        case(state)
            IDLE: nextstate = SUM_OF_SQUARES;
            SUM_OF_SQUARES: nextstate = NORM_SCALE;
            NORM_SCALE: nextstate = IDLE;
            default: nextstate = IDLE;
    end

    // Output
    always @(posedge clk or posedge rst_n) begin
        for (j=0; j < SIZE; j = j + 1) begin
            ss[j] <= 0;
            o[j] <= 0;
        end else begin
            case(state)
                SUM_OF_SQUARES: begin
                    ss <= 0;
                    for (int i=0; i<SIZE; i=i+1) begin
                        ss += x_in[i] * x_in[i];
                    end
                    ss <= ss / SIZE;
                    ss <= ss + 1e-5;
                    ss_temp <= sqrt(ss);
                    ss <= ~ss_temp;           
                end
                NORM_SCALE: begin
                    for (int j=0; j<SIZE; j=j+1) begin
                        o[j] = weight[j] * (ss * x_in[j]);
                    end
                end
            endcase
        end

    end

endmodule