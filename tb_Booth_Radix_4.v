`timescale 1ns / 1ps

module tb_simple;

    reg clk;
    reg reset;
    reg [7:0] A, B;
    wire signed [15:0] RESULT;
    reg signed [15:0] expected;
    integer i, j, errors;

    datapath dut (
	    .clk(clk), 
	    .A(A), 
	    .B(B), 
	    .RESULT(RESULT));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 0;
        errors = 0;
        A = 0;
        B = 0;
        @(negedge clk);

        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                A = i;
                B = j;

                @(posedge clk);
                #1;

                expected = $signed(A) * $signed(B);

                if (RESULT !== expected) begin
                    errors = errors + 1;
                    if (errors <= 1
                    )
                        $display("FAIL: %0d x %0d expected %0d got %0d", $signed(A), $signed(B), expected, RESULT);
                end

                @(negedge clk);
            end
        end

        if (errors == 0)
            $display("PASS: all 65536 tests correct");
        else
            $display("FAIL: %0d errors", errors);

        $finish;
    end

endmodule


