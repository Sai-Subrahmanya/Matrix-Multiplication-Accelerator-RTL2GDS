`timescale 1ns/1ps
`default_nettype none

module mma (
    input  wire        Clock,
    input  wire        Reset,
    input  wire        Start,
    input  wire [35:0] MatrixA,
    input  wire [35:0] MatrixB,
    output reg  [71:0] MatrixC,
    output reg         Done
);

    // Matrix A elements
    wire [3:0] a0 = MatrixA[35:32];
    wire [3:0] a1 = MatrixA[31:28];
    wire [3:0] a2 = MatrixA[27:24];
    wire [3:0] a3 = MatrixA[23:20];
    wire [3:0] a4 = MatrixA[19:16];
    wire [3:0] a5 = MatrixA[15:12];
    wire [3:0] a6 = MatrixA[11:8];
    wire [3:0] a7 = MatrixA[7:4];
    wire [3:0] a8 = MatrixA[3:0];

    // Matrix B elements
    wire [3:0] b0 = MatrixB[35:32];
    wire [3:0] b1 = MatrixB[31:28];
    wire [3:0] b2 = MatrixB[27:24];
    wire [3:0] b3 = MatrixB[23:20];
    wire [3:0] b4 = MatrixB[19:16];
    wire [3:0] b5 = MatrixB[15:12];
    wire [3:0] b6 = MatrixB[11:8];
    wire [3:0] b7 = MatrixB[7:4];
    wire [3:0] b8 = MatrixB[3:0];

    always @(posedge Clock) begin
        if (Reset) begin
            MatrixC <= 72'd0;
            Done    <= 1'b0;
        end else if (Start) begin
            MatrixC[71:64] <= (a0 * b0) + (a1 * b3) + (a2 * b6); // C0
            MatrixC[63:56] <= (a0 * b1) + (a1 * b4) + (a2 * b7); // C1
            MatrixC[55:48] <= (a0 * b2) + (a1 * b5) + (a2 * b8); // C2

            MatrixC[47:40] <= (a3 * b0) + (a4 * b3) + (a5 * b6); // C3
            MatrixC[39:32] <= (a3 * b1) + (a4 * b4) + (a5 * b7); // C4
            MatrixC[31:24] <= (a3 * b2) + (a4 * b5) + (a5 * b8); // C5

            MatrixC[23:16] <= (a6 * b0) + (a7 * b3) + (a8 * b6); // C6
            MatrixC[15:8]  <= (a6 * b1) + (a7 * b4) + (a8 * b7); // C7
            MatrixC[7:0]   <= (a6 * b2) + (a7 * b5) + (a8 * b8); // C8

            Done <= 1'b1;
        end else begin
            Done <= 1'b0;
        end
    end

endmodule

`default_nettype wire
