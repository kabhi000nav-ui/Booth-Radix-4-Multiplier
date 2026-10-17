`timescale 1ns / 1ps

//INPUT REGISTER A
module registerA(
	input clk , 
	input [7:0] A , 
	output reg [8:0] outA
);
	always @ (posedge clk) begin
		outA <= { A , 1'b0 };
	end
endmodule

//INPUT REGISTER B
module registerB(
	input clk , 
	input [7:0] B , 
	output reg [7:0] outB
);
	always @ (posedge clk ) begin
		outB <= B ;
	end
endmodule

module module1 (
    input      [2:0] r0, r1, r2, r3,
    output reg [2:0] d0, d1, d2, d3
);

    localparam ZERO     = 3'b000;   //      0
    localparam PLUS_M   = 3'b001;   //     +1
    localparam PLUS_2M  = 3'b010;   //     +2
    localparam MINUS_2M = 3'b110;   //     -2
    localparam MINUS_M  = 3'b111;   //     -1

    always @(*) begin
        // FINDING D0
        case (r0)
            3'b000:  d0 = ZERO;
            3'b001:  d0 = PLUS_M;
            3'b010:  d0 = PLUS_M;
            3'b011:  d0 = PLUS_2M;
            3'b100:  d0 = MINUS_2M;
            3'b101:  d0 = MINUS_M;
            3'b110:  d0 = MINUS_M;
            3'b111:  d0 = ZERO;
            default: d0 = ZERO;
        endcase

        // FINDING D1
        case (r1)
            3'b000:  d1 = ZERO;
            3'b001:  d1 = PLUS_M;
            3'b010:  d1 = PLUS_M;
            3'b011:  d1 = PLUS_2M;
            3'b100:  d1 = MINUS_2M;
            3'b101:  d1 = MINUS_M;
            3'b110:  d1 = MINUS_M;
            3'b111:  d1 = ZERO;
            default: d1 = ZERO;
        endcase

        // FINDING D2
        case (r2)
            3'b000:  d2 = ZERO;
            3'b001:  d2 = PLUS_M;
            3'b010:  d2 = PLUS_M;
            3'b011:  d2 = PLUS_2M;
            3'b100:  d2 = MINUS_2M;
            3'b101:  d2 = MINUS_M;
            3'b110:  d2 = MINUS_M;
            3'b111:  d2 = ZERO;
            default: d2 = ZERO;
        endcase

        // FINDING D3
        case (r3)
            3'b000:  d3 = ZERO;
            3'b001:  d3 = PLUS_M;
            3'b010:  d3 = PLUS_M;
            3'b011:  d3 = PLUS_2M;
            3'b100:  d3 = MINUS_2M;
            3'b101:  d3 = MINUS_M;
            3'b110:  d3 = MINUS_M;
            3'b111:  d3 = ZERO;
            default: d3 = ZERO;
        endcase
    end
endmodule

//STAGE 1
module stage1(
	input signed [2:0] d0 , d1 , d2 , d3 ,
	input [7:0] outB ,
	output reg signed [9:0] a0 , a1 , a2 , a3
);

	localparam ZERO     = 3'b000;   //  0
	localparam PLUS_M   = 3'b001;   // +1
	localparam PLUS_2M  = 3'b010;   // +2
	localparam MINUS_2M = 3'b110;   // -2
	localparam MINUS_M  = 3'b111;   // -1

	always @ (*) begin

	// FINDING a0
		case(d0)
			ZERO      : a0 = 10'b0 ;
			PLUS_M    : a0 =  {{2{outB[7]}} , outB} ;
			PLUS_2M   : a0 =  {outB[7] , outB , 1'b0} ;
			MINUS_2M  : a0 = -{outB[7] , outB , 1'b0} ;
			MINUS_M   : a0 = -{{2{outB[7]}} , outB} ;
			default   : a0 = 10'b0 ;
		endcase

	// FINDING a1
		case(d1)
			ZERO      : a1 = 10'b0 ;
			PLUS_M    : a1 =  {{2{outB[7]}} , outB} ;
			PLUS_2M   : a1 =  {outB[7] , outB , 1'b0} ;
			MINUS_2M  : a1 = -{outB[7] , outB , 1'b0} ;
			MINUS_M   : a1 = -{{2{outB[7]}} , outB} ;
			default   : a1 = 10'b0 ;
		endcase

	// FINDING a2
		case(d2)
			ZERO      : a2 = 10'b0 ;
			PLUS_M    : a2 =  {{2{outB[7]}} , outB} ;
			PLUS_2M   : a2 =  {outB[7] , outB , 1'b0} ;
			MINUS_2M  : a2 = -{outB[7] , outB , 1'b0} ;
			MINUS_M   : a2 = -{{2{outB[7]}} , outB} ;
			default   : a2 = 10'b0 ;
		endcase

	// FINDING a3
		case(d3)
			ZERO      : a3 = 10'b0 ;
			PLUS_M    : a3 =  {{2{outB[7]}} , outB} ;
			PLUS_2M   : a3 =  {outB[7] , outB , 1'b0} ;
			MINUS_2M  : a3 = -{outB[7] , outB , 1'b0} ;
			MINUS_M   : a3 = -{{2{outB[7]}} , outB} ;
			default   : a3 = 10'b0 ;
		endcase

	end
endmodule

//STAGE 2
module stage2(input signed [9:0] a0 , a1 , a2 , a3 ,
              output signed [15:0] x0 , x1 , x2 , x3);
    
    assign x0 = a0 ;
	assign x1 = a1 << 2 ;
	assign x2 = a2 << 4 ;
	assign x3 = a3 << 6 ;
	
endmodule

//RESULT
module result(input signed[15:0] x0 , x1 , x2 , x3 , 
              output signed [15:0] RESULT);

	assign RESULT = x0 + x1 + x2 + x3;

endmodule

//DATAPATH
module datapath(
	input [7:0] A , B ,
	input clk ,
	output signed [15:0] RESULT
);
//-------------------- REGSISTER -------------------

	wire [8:0] outA ;
	wire [7:0] outB ;
	
//-------------------- STAGE - 1 ----------------------------

	wire [2:0] r0 , r1 , r2 , r3 ;
	wire [2:0] d0 , d1 , d2 , d3 ;

//-------------------- STAGE - 2 -----------------------------

	wire signed [9:0]  a0 , a1 , a2 , a3 ;
	wire signed [15:0] x0 , x1 , x2 , x3 ;

	assign r0 = outA[2:0] ;
	assign r1 = outA[4:2] ;
	assign r2 = outA[6:4] ;
	assign r3 = outA[8:6] ;

	registerA RA (
		.clk(clk) ,
		.A(A) , 
		.outA(outA)
	);

	registerB RB (
		.clk(clk) , 
		.B(B) , 
		.outB(outB)
	);

	module1 M1 (
		.r0(outA[2:0]) , 
		.r1(outA[4:2]) , 
		.r2(outA[6:4]) ,              
		.r3(outA[8:6]) ,
		.d0(d0) , 
		.d1(d1) , 
		.d2(d2) , 
		.d3(d3)
	);

	stage1 S1 (
		.d0(d0) , 
		.d1(d1) , 
		.d2(d2) , 
		.d3(d3) ,
		.outB(outB) ,
		.a0(a0) , 
		.a1(a1) , 
		.a2(a2) , 
		.a3(a3)
	);

	stage2 S2 (
		.a0(a0) , 
		.a1(a1) , 
		.a2(a2) , 
		.a3(a3) ,
		.x0(x0) , 
		.x1(x1) , 
		.x2(x2) , 
		.x3(x3)
	);

	result RES (
		.x0(x0) , 
		.x1(x1) , 
		.x2(x2) , 
		.x3(x3) ,
		.RESULT(RESULT)
	);

endmodule



