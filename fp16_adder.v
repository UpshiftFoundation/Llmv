module fp16_adder (
    input  [15:0] a,
    input  [15:0] b,
    output [15:0] sum
);
    wire sign_a, sign_b, sign_r;
    wire [4:0] exp_a, exp_b, exp_r;

// Extracting sign, exponent, and mantissa
    wire sign_a = a[15];
    wire [4:0] exponent_a = a[14:10];
    wire [10:0] mantissa_a = {1'b1, a[9:0]}; // Implicit leading 1 for normalized numbers

    wire sign_b = b[15];
    wire [4:0] exponent_b = b[14:10];
    wire [10:0] mantissa_b = {1'b1, b[9:0]}; // Implicit leading 1 for normalized numbers

    // Aligning the exponents
    wire [4:0] exponent_diff = (exponent_a > exponent_b) ? (exponent_a - exponent_b) : (exponent_b - exponent_a);
    wire [10:0] mantissa_a_shifted = (exponent_a > exponent_b) ? mantissa_a : (mantissa_a >> exponent_diff);
    wire [10:0] mantissa_b_shifted = (exponent_b > exponent_a) ? mantissa_b : (mantissa_b >> exponent_diff);

    wire [4:0] exponent_final = (exponent_a > exponent_b) ? exponent_a : exponent_b;

    // Adding/Subtracting the mantissas
    wire [11:0] mantissa_sum = (sign_a == sign_b) ? (mantissa_a_shifted + mantissa_b_shifted) : (mantissa_a_shifted - mantissa_b_shifted);

    // Normalization of the result
    wire [4:0] exponent_normalized;
    wire [10:0] mantissa_normalized;

    if (mantissa_sum[11] == 1) begin
        mantissa_normalized = mantissa_sum[11:1];
        exponent_normalized = exponent_final + 1;
    end else begin
        mantissa_normalized = mantissa_sum[10:0];
        exponent_normalized = exponent_final;
    end

    // Rounding (not implemented for simplicity)

    // Constructing the result
    assign result = {sign_a, exponent_normalized, mantissa_normalized[9:0]};
endmodule