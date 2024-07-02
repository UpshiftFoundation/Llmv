module matmul
#(
    parameter n = 128,
    parameter d = 128
)
(
    input clk,
    input rst,
    input [31:0] x_in [0:d-1],
    input [31:0] w_in [0:(d*n)-1],
    output [31:0] xout [0:d-1]
);

reg [31:0] val [0:d-1]; // figure out how to initialize this 
integer i;
integer j;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        for (i=0;i<d;i=i+1) begin
            xout[i] <= 0;
        end
    end
    for (i=0; i<d; i=i+1) begin 
        val[i] <= 0;
        for (j=0; j<n; j=j+1) begin
            val[i] <= val[i] + w_in[i*n+j] * x_in[j];
        end
        xout[i] <= val[i];
    end  
end

endmodule
