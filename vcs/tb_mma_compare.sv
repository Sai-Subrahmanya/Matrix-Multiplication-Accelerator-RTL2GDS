`timescale 1ns/1ps
`default_nettype none

module tb_mma_compare;

    ////////////////////////////////////////////////////////////////////////////
    // DUT ports
    ////////////////////////////////////////////////////////////////////////////

    logic        Clock;
    logic        Reset;
    logic        Start;
    logic [35:0] MatrixA;
    logic [35:0] MatrixB;
    wire  [71:0] MatrixC;
    wire         Done;

    ////////////////////////////////////////////////////////////////////////////
    // DUT instance
    ////////////////////////////////////////////////////////////////////////////

    mma dut (
        .Clock   (Clock),
        .Reset   (Reset),
        .Start   (Start),
        .MatrixA (MatrixA),
        .MatrixB (MatrixB),
        .MatrixC (MatrixC),
        .Done    (Done)
    );

    ////////////////////////////////////////////////////////////////////////////
    // Clock generation
    ////////////////////////////////////////////////////////////////////////////

    initial begin
        Clock = 1'b0;
        forever #5 Clock = ~Clock;
    end

    ////////////////////////////////////////////////////////////////////////////
    // Helper functions
    ////////////////////////////////////////////////////////////////////////////

    function automatic [35:0] pack_matrix_3x3(
        input [3:0] m0,
        input [3:0] m1,
        input [3:0] m2,
        input [3:0] m3,
        input [3:0] m4,
        input [3:0] m5,
        input [3:0] m6,
        input [3:0] m7,
        input [3:0] m8
    );
        begin
            pack_matrix_3x3 = {
                m0, m1, m2,
                m3, m4, m5,
                m6, m7, m8
            };
        end
    endfunction

    function automatic [3:0] get_elem(
        input [35:0] matrix,
        input int index
    );
        begin
            case (index)
                0: get_elem = matrix[35:32];
                1: get_elem = matrix[31:28];
                2: get_elem = matrix[27:24];
                3: get_elem = matrix[23:20];
                4: get_elem = matrix[19:16];
                5: get_elem = matrix[15:12];
                6: get_elem = matrix[11:8];
                7: get_elem = matrix[7:4];
                8: get_elem = matrix[3:0];
                default: get_elem = 4'd0;
            endcase
        end
    endfunction

    function automatic [7:0] dot_product_trunc8(
        input [35:0] A,
        input [35:0] B,
        input int row,
        input int col
    );
        int a_index0;
        int a_index1;
        int a_index2;
        int b_index0;
        int b_index1;
        int b_index2;
        int full_sum;
        begin
            a_index0 = row * 3 + 0;
            a_index1 = row * 3 + 1;
            a_index2 = row * 3 + 2;

            b_index0 = 0 * 3 + col;
            b_index1 = 1 * 3 + col;
            b_index2 = 2 * 3 + col;

            full_sum =
                (get_elem(A, a_index0) * get_elem(B, b_index0)) +
                (get_elem(A, a_index1) * get_elem(B, b_index1)) +
                (get_elem(A, a_index2) * get_elem(B, b_index2));

            // RTL stores each output element in only 8 bits.
            // Therefore expected value is the lower 8 bits of the true sum.
            dot_product_trunc8 = full_sum[7:0];
        end
    endfunction

    function automatic [71:0] expected_matrix_c(
        input [35:0] A,
        input [35:0] B
    );
        reg [7:0] c0;
        reg [7:0] c1;
        reg [7:0] c2;
        reg [7:0] c3;
        reg [7:0] c4;
        reg [7:0] c5;
        reg [7:0] c6;
        reg [7:0] c7;
        reg [7:0] c8;
        begin
            c0 = dot_product_trunc8(A, B, 0, 0);
            c1 = dot_product_trunc8(A, B, 0, 1);
            c2 = dot_product_trunc8(A, B, 0, 2);

            c3 = dot_product_trunc8(A, B, 1, 0);
            c4 = dot_product_trunc8(A, B, 1, 1);
            c5 = dot_product_trunc8(A, B, 1, 2);

            c6 = dot_product_trunc8(A, B, 2, 0);
            c7 = dot_product_trunc8(A, B, 2, 1);
            c8 = dot_product_trunc8(A, B, 2, 2);

            expected_matrix_c = {
                c0, c1, c2,
                c3, c4, c5,
                c6, c7, c8
            };
        end
    endfunction

    ////////////////////////////////////////////////////////////////////////////
    // Helper tasks
    ////////////////////////////////////////////////////////////////////////////

    task automatic wait_clks(input int n);
        int i;
        begin
            for (i = 0; i < n; i++) begin
                @(posedge Clock);
            end
            #1;
        end
    endtask

    task automatic check_result(
        input [71:0] expected_c,
        input        expected_done,
        input string test_name
    );
        begin
            if ((MatrixC !== expected_c) || (Done !== expected_done)) begin
                $display("ERROR: %s", test_name);
                $display("       MatrixC actual   = %h", MatrixC);
                $display("       MatrixC expected = %h", expected_c);
                $display("       Done actual      = %b", Done);
                $display("       Done expected    = %b", expected_done);
                $display("       time             = %0t", $time);
                $fatal;
            end else begin
                $display("PASS : %-55s MatrixC=%h Done=%b time=%0t",
                         test_name, MatrixC, Done, $time);
            end
        end
    endtask

    task automatic apply_reset;
        begin
            @(negedge Clock);
            Reset   = 1'b1;
            Start   = 1'b0;
            MatrixA = 36'd0;
            MatrixB = 36'd0;

            wait_clks(3);

            check_result(72'd0, 1'b0, "reset clears MatrixC and Done");

            @(negedge Clock);
            Reset = 1'b0;

            wait_clks(1);
        end
    endtask

    task automatic run_mma_case(
        input [35:0] A,
        input [35:0] B,
        input string test_name
    );
        reg [71:0] expected_c;
        begin
            expected_c = expected_matrix_c(A, B);

            @(negedge Clock);
            MatrixA = A;
            MatrixB = B;
            Start   = 1'b1;

            // Results are registered at next positive clock edge.
            wait_clks(1);

            check_result(expected_c, 1'b1, test_name);

            @(negedge Clock);
            Start = 1'b0;

            wait_clks(1);

            // MatrixC should hold previous result, Done should drop.
            check_result(expected_c, 1'b0, {test_name, " : Done drops when Start=0"});
        end
    endtask

    ////////////////////////////////////////////////////////////////////////////
    // Main test sequence
    ////////////////////////////////////////////////////////////////////////////

    initial begin
        ////////////////////////////////////////////////////////////////////////////
        // DVE waveform dump
        ////////////////////////////////////////////////////////////////////////////

        $vcdplusfile("mma_compare.vpd");
        $vcdpluson(0, tb_mma_compare);

        $display("============================================================");
        $display("MMA self-checking testbench started");
        $display("============================================================");

        Reset   = 1'b0;
        Start   = 1'b0;
        MatrixA = 36'd0;
        MatrixB = 36'd0;

        ////////////////////////////////////////////////////////////////////////////
        // TEST 1: Reset
        ////////////////////////////////////////////////////////////////////////////

        apply_reset();

        ////////////////////////////////////////////////////////////////////////////
        // TEST 2: Zero matrices
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd0, 4'd0, 4'd0,
                4'd0, 4'd0, 4'd0,
                4'd0, 4'd0, 4'd0
            ),
            pack_matrix_3x3(
                4'd0, 4'd0, 4'd0,
                4'd0, 4'd0, 4'd0,
                4'd0, 4'd0, 4'd0
            ),
            "zero matrix multiplied by zero matrix"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 3: A multiplied by identity
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd1, 4'd2, 4'd3,
                4'd4, 4'd5, 4'd6,
                4'd7, 4'd8, 4'd9
            ),
            pack_matrix_3x3(
                4'd1, 4'd0, 4'd0,
                4'd0, 4'd1, 4'd0,
                4'd0, 4'd0, 4'd1
            ),
            "A multiplied by identity"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 4: Identity multiplied by B
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd1, 4'd0, 4'd0,
                4'd0, 4'd1, 4'd0,
                4'd0, 4'd0, 4'd1
            ),
            pack_matrix_3x3(
                4'd9, 4'd8, 4'd7,
                4'd6, 4'd5, 4'd4,
                4'd3, 4'd2, 4'd1
            ),
            "identity multiplied by B"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 5: General small values
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd1, 4'd2, 4'd3,
                4'd4, 4'd5, 4'd6,
                4'd7, 4'd8, 4'd9
            ),
            pack_matrix_3x3(
                4'd9, 4'd8, 4'd7,
                4'd6, 4'd5, 4'd4,
                4'd3, 4'd2, 4'd1
            ),
            "general 3x3 multiplication small values"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 6: Diagonal matrices
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd2, 4'd0, 4'd0,
                4'd0, 4'd3, 4'd0,
                4'd0, 4'd0, 4'd4
            ),
            pack_matrix_3x3(
                4'd5, 4'd0, 4'd0,
                4'd0, 4'd6, 4'd0,
                4'd0, 4'd0, 4'd7
            ),
            "diagonal matrix multiplication"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 7: Sparse matrices
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd0, 4'd0, 4'd5,
                4'd0, 4'd7, 4'd0,
                4'd9, 4'd0, 4'd0
            ),
            pack_matrix_3x3(
                4'd0, 4'd2, 4'd0,
                4'd3, 4'd0, 4'd0,
                4'd0, 4'd0, 4'd4
            ),
            "sparse matrix multiplication"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 8: All ones
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd1, 4'd1, 4'd1,
                4'd1, 4'd1, 4'd1,
                4'd1, 4'd1, 4'd1
            ),
            pack_matrix_3x3(
                4'd1, 4'd1, 4'd1,
                4'd1, 4'd1, 4'd1,
                4'd1, 4'd1, 4'd1
            ),
            "all ones"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 9: Max values with expected 8-bit truncation
        //
        // True dot product = 15*15 + 15*15 + 15*15 = 675 decimal.
        // 675 = 0x2A3, lower 8 bits = 0xA3.
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd15, 4'd15, 4'd15,
                4'd15, 4'd15, 4'd15,
                4'd15, 4'd15, 4'd15
            ),
            pack_matrix_3x3(
                4'd15, 4'd15, 4'd15,
                4'd15, 4'd15, 4'd15,
                4'd15, 4'd15, 4'd15
            ),
            "max values with expected 8-bit truncation"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 10: Mixed high values
        ////////////////////////////////////////////////////////////////////////////

        run_mma_case(
            pack_matrix_3x3(
                4'd15, 4'd0,  4'd1,
                4'd2,  4'd14, 4'd3,
                4'd4,  4'd5,  4'd13
            ),
            pack_matrix_3x3(
                4'd12, 4'd11, 4'd10,
                4'd9,  4'd8,  4'd7,
                4'd6,  4'd5,  4'd4
            ),
            "mixed high values"
        );

        ////////////////////////////////////////////////////////////////////////////
        // TEST 11: Start low behavior
        ////////////////////////////////////////////////////////////////////////////

        @(negedge Clock);
        Start   = 1'b0;
        MatrixA = pack_matrix_3x3(
            4'd3, 4'd3, 4'd3,
            4'd3, 4'd3, 4'd3,
            4'd3, 4'd3, 4'd3
        );
        MatrixB = pack_matrix_3x3(
            4'd2, 4'd2, 4'd2,
            4'd2, 4'd2, 4'd2,
            4'd2, 4'd2, 4'd2
        );

        wait_clks(1);

        if (Done !== 1'b0) begin
            $display("ERROR: Done should remain 0 when Start=0");
            $fatal;
        end else begin
            $display("PASS : Start low keeps Done=0");
        end

        ////////////////////////////////////////////////////////////////////////////
        // TEST 12: Reset after computation
        ////////////////////////////////////////////////////////////////////////////

        @(negedge Clock);
        Reset = 1'b1;
        Start = 1'b0;

        wait_clks(2);

        check_result(72'd0, 1'b0, "reset after computation clears outputs");

        @(negedge Clock);
        Reset = 1'b0;

        ////////////////////////////////////////////////////////////////////////////
        // End
        ////////////////////////////////////////////////////////////////////////////

        $display("============================================================");
        $display("ALL MMA TESTS PASSED");
        $display("============================================================");

        $finish;
    end

endmodule

`default_nettype wire
