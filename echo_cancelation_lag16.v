//4 sampling clks 250 operation clks (125 cycles)


`timescale 1us/1us
module echo_cancelation(
rst,
sampling_cycle_counter,
clk_operation,
enable_sampling,
enable,
signal_receive,
signal_send, 
para_0, 
para_1, 
para_2,
para_3,
para_4,
para_5,
para_6,
para_7,
para_8,
para_9,
para_10,
para_11,
para_12,
para_13,
para_14,
para_15,
	signal_without_echo,
	signal_without_echo_exp,
	ready
);

input [63:0] signal_send,signal_receive;
input [12:0] sampling_cycle_counter;
input clk_operation,rst,enable,enable_sampling;
input [63:0] para_0,para_1,para_2,para_3,para_4,para_5,para_6,para_7,para_8,para_9,para_10,para_11,para_12,para_13,para_14,para_15;
output reg ready;
output reg [63:0] signal_without_echo;
output reg [10:0] signal_without_echo_exp;

reg enable_internal;
reg enable_U0,enable_U1,enable_U2,enable_U3,enable_U4,enable_U5,enable_U6;
reg [1:0]rmode_U0,rmode_U1,rmode_U2,rmode_U3,rmode_U4,rmode_U5,rmode_U6;
reg [2:0]fpu_op_U0,fpu_op_U1,fpu_op_U2,fpu_op_U3,fpu_op_U4,fpu_op_U5,fpu_op_U6;
reg [63:0]opa_U0,opa_U1,opa_U2,opa_U3,opa_U4,opa_U5,opa_U6;
reg [63:0]opb_U0,opb_U1,opb_U2,opb_U3,opb_U4,opb_U5,opb_U6;
wire [63:0]out_U0,out_U1,out_U2,out_U3,out_U4,out_U5,out_U6;
wire ready_U0,ready_U1,ready_U2,ready_U3,ready_U4,ready_U5,ready_U6;
wire underflow;
wire overflow;
wire inexact;
wire exception;
wire invalid;  
reg [2:0] count_sampling;
reg [3:0] count_operation;
reg [63:0] lag_0,lag_1,lag_2,lag_3,lag_4,lag_5,lag_6,lag_7,lag_8,lag_9,lag_10,lag_11,lag_12,lag_13,lag_14,lag_15;
reg [63:0] signal_receive_align,signal_lag_approx;

reg [63:0] lp0,lp1,lp2,lp3,lp4,lp5,lp6;				//count_operation == 0
reg [63:0] lp7,lp8,lp9,lp10,lp11,lp12,lp13;			//count_operation == 1
reg [63:0] lp0_1,lp2_3,lp4_5,lp6_7,lp8_9,lp14,lp15;		//count_operation == 2
reg [63:0] lp10_11,lp12_13,lp14_15,lp0_to_3,lp4_to_7;		//count_operation == 3
reg [63:0] lp8_to_11,lp12_to_15,lp0_to_7;			//count_operation == 4
reg [63:0] lp8_to_15,sig_lp0_to_7;				//count_operation == 5



always @(posedge clk_operation) begin
	if (rst) begin 
		count_sampling <= 0;
		enable_internal <= 0;
		signal_without_echo <= 0;
	end

	if (enable) begin
		enable_internal <= 1;
		ready <= 0;
	end
end

//the sampling and alignment. 
always @(posedge clk_operation) begin
	if (sampling_cycle_counter == 0) begin
		if (~rst) begin	
		if (enable_sampling) begin
			case (count_sampling)
			0: begin
				lag_0 <= signal_send;
				count_sampling <= 1;
				signal_receive_align <= signal_receive; //signa alignment;
			end
			1: begin
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 2;
				signal_receive_align <= signal_receive;
			end
			2: begin
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 3;
				signal_receive_align <= signal_receive;
			end
			3: begin
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 4;
				signal_receive_align <= signal_receive;
			end
			4: begin
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 5;
				signal_receive_align <= signal_receive; 
			end
			5: begin
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 6;
				signal_receive_align <= signal_receive; 
			end
			6: begin
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 7;
				signal_receive_align <= signal_receive; 
			end
			7: begin
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 8;
				signal_receive_align <= signal_receive; 
			end
			8: begin
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 9;
				signal_receive_align <= signal_receive; 
			end
			9: begin
				lag_9 <= lag_8;
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 10;
				signal_receive_align <= signal_receive;
			end
			10: begin
				lag_10 <= lag_9;
				lag_9 <= lag_8;
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 11;
				signal_receive_align <= signal_receive;
			end
			11: begin
				lag_11 <= lag_12;
				lag_10 <= lag_9;
				lag_9 <= lag_8;
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 12;
				signal_receive_align <= signal_receive;
			end
			12: begin
				lag_12 <= lag_11;
				lag_11 <= lag_12;
				lag_10 <= lag_9;
				lag_9 <= lag_8;
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 13;
				signal_receive_align <= signal_receive; 
			end
			13: begin
				lag_13 <= lag_12;
				lag_12 <= lag_11;
				lag_11 <= lag_12;
				lag_10 <= lag_9;
				lag_9 <= lag_8;
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 14;
				signal_receive_align <= signal_receive; 
			end
			14: begin
				lag_14 <= lag_13;
				lag_13 <= lag_12;
				lag_12 <= lag_11;
				lag_11 <= lag_12;
				lag_10 <= lag_9;
				lag_9 <= lag_8;
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_sampling <= 15;
				signal_receive_align <= signal_receive;
			end
			15: begin
				lag_15 <= lag_14;
				lag_14 <= lag_13;
				lag_13 <= lag_12;
				lag_12 <= lag_11;
				lag_11 <= lag_12;
				lag_10 <= lag_9;
				lag_9 <= lag_8;
				lag_8 <= lag_7;
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal_send;
				count_operation <= 0;
				signal_receive_align <= signal_receive;
/*$display(
"##lag_3: %b", lag_3,
"##lag_2: %b", lag_2,
"##lag_1: %b", lag_1,
"##lag_0: %b", lag_0,
"##signal_align: %b", signal_align
);*/
			end	
			default:;	
			endcase
		end
		end
	end
end

always @(posedge clk_operation) begin
	if (~rst) begin	
	if (enable_internal) begin 
		case (count_operation)
		0: begin
			opa_U0 <= lag_0;
			opb_U0 <= para_0;
			fpu_op_U0 <= 3'b010; //out = lp0
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lag_1;
			opb_U1 <= para_1;
			fpu_op_U1 <= 3'b010; //out = lp1
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lag_2;
			opb_U2 <= para_2;		
			fpu_op_U2 <= 3'b010; //out = lp2
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lag_3;
			opb_U3 <= para_3;
			fpu_op_U3 <= 3'b010; //out = lp3
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lag_4;
			opb_U4 <= para_4;
			fpu_op_U4 <= 3'b010; //out = lp4
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_5;
			opb_U5 <= para_5;
			fpu_op_U5 <= 3'b010; //out = lp5
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_6;
			opb_U6 <= para_6;
			fpu_op_U6 <= 3'b010; //out = lp5
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6 == 1) begin
				lp0 <= out_U0;				
				lp1 <= out_U1;
				lp2 <= out_U2;
				lp3 <= out_U3;
				lp4 <= out_U4;
				lp5 <= out_U5;
				lp6 <= out_U6;
				count_operation <= 1;

			end
		end
		1: begin
			opa_U0 <= lag_7;
			opb_U0 <= para_7;
			fpu_op_U0 <= 3'b010; //out = lp7
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lag_8;
			opb_U1 <= para_8;
			fpu_op_U1 <= 3'b010; //out = lp8
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lag_9;
			opb_U2 <= para_9;		
			fpu_op_U2 <= 3'b010; //out = lp9
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lag_10;
			opb_U3 <= para_10;
			fpu_op_U3 <= 3'b010; //out = lp10
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lag_11;
			opb_U4 <= para_11;
			fpu_op_U4 <= 3'b010; //out = lp11
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_12;
			opb_U5 <= para_12;
			fpu_op_U5 <= 3'b010; //out = lp12
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_13;
			opb_U6 <= para_13;
			fpu_op_U6 <= 3'b010; //out = lp13
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6 == 1) begin
				lp7 <= out_U0;				
				lp8 <= out_U1;
				lp9 <= out_U2;
				lp10 <= out_U3;
				lp11 <= out_U4;
				lp12 <= out_U5;
				lp13 <= out_U6;
				count_operation <= 2;

			end
		end
		2: begin
			opa_U0 <= lp0;
			opb_U0 <= lp1;
			fpu_op_U0 <= 3'b000; //out = lp0+lp1
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lp2;
			opb_U1 <= lp3;
			fpu_op_U1 <= 3'b000; //out = lp2+lp3
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lp4;
			opb_U2 <= lp5;		
			fpu_op_U2 <= 3'b000; //out = lp4+lp5
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lp6;
			opb_U3 <= lp7;
			fpu_op_U3 <= 3'b000; //out = lp6+lp7
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lp8;
			opb_U4 <= lp9;
			fpu_op_U4 <= 3'b000; //out = lp8+lp9
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_14;
			opb_U5 <= para_14;
			fpu_op_U5 <= 3'b010; //out = lp14
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_15;
			opb_U6 <= para_15;
			fpu_op_U6 <= 3'b010; //out = lp15
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6 == 1) begin
				lp0_1 <= out_U0;				
				lp2_3 <= out_U1;
				lp4_5 <= out_U2;
				lp6_7 <= out_U3;
				lp8_9 <= out_U4;
				lp14 <= out_U5;
				lp15 <= out_U6;
				count_operation <= 3;

			end
		end
		3: begin
			opa_U0 <= lp10;
			opb_U0 <= lp11;
			fpu_op_U0 <= 3'b000; //out = lp10+lp11
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lp12;
			opb_U1 <= lp13;
			fpu_op_U1 <= 3'b000; //out = lp12+lp13
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lp14;
			opb_U2 <= lp15;		
			fpu_op_U2 <= 3'b000; //out = lp14+lp15
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lp0_1;
			opb_U3 <= lp2_3;
			fpu_op_U3 <= 3'b000; //out = lp0+..+lp3
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lp4_5;
			opb_U4 <= lp6_7;
			fpu_op_U4 <= 3'b000; //out = lp4+..+lp7
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4 == 1) begin
				lp10_11 <= out_U0;				
				lp12_13 <= out_U1;
				lp14_15 <= out_U2;
				lp0_to_3 <= out_U3;
				lp4_to_7 <= out_U4;
				count_operation <= 4;
			end
		end
		4: begin
			opa_U0 <= lp8_9;
			opb_U0 <= lp10_11;
			fpu_op_U0 <= 3'b000; //out = lp8+..+lp11
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lp12_13;
			opb_U1 <= lp14_15;
			fpu_op_U1 <= 3'b000; //out = lp12+..+lp15
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lp0_to_3;
			opb_U2 <= lp4_to_7;		
			fpu_op_U2 <= 3'b000; //out = lp0+..+lp7
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2 == 1) begin
				lp8_to_11 <= out_U0;				
				lp12_to_15 <= out_U1;
				lp0_to_7 <= out_U2;
				count_operation <= 5;
			end
		end
		5: begin
			opa_U0 <= lp8_to_11;
			opb_U0 <= lp12_to_15;
			fpu_op_U0 <= 3'b000; //out = lp8+..+lp15
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= signal_receive_align;
			opb_U1 <= lp0_to_7;
			fpu_op_U1 <= 3'b001; //out = signal_receive_align - (lp0+..+lp7)
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1 == 1) begin
				lp8_to_15 <= out_U0;				
				sig_lp0_to_7 <= out_U1;
				count_operation <= 6;
			end
		end
		6: begin
			opa_U0 <= sig_lp0_to_7;
			opb_U0 <= lp8_to_15;
			fpu_op_U0 <= 3'b001; //out = signal_receive_align - (lp0+..+lp15)
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			#4;
			enable_U0 <= 1'b0;
			
			#60;

			if (ready_U0 == 1) begin
				count_operation <= 7;	
				signal_without_echo <= out_U0;
				signal_without_echo_exp <= out_U0[62:52] - 1023;
				enable_internal <= 0;
				ready <= 1;
			end
		end
		7: begin
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
		end
		default:;
		endcase
	end
	end
end	

// fpu modules *7
fpu U0 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U0),
	.rmode(rmode_U0),
	.fpu_op(fpu_op_U0),
	.opa(opa_U0),
	.opb(opb_U0),
		.out(out_U0),
		.ready(ready_U0),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));

fpu U1 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U1),
	.rmode(rmode_U1),
	.fpu_op(fpu_op_U1),
	.opa(opa_U1),
	.opb(opb_U1),
		.out(out_U1),
		.ready(ready_U1),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));

fpu U2 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U2),
	.rmode(rmode_U2),
	.fpu_op(fpu_op_U2),
	.opa(opa_U2),
	.opb(opb_U2),
		.out(out_U2),
		.ready(ready_U2),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));

fpu U3 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U3),
	.rmode(rmode_U3),
	.fpu_op(fpu_op_U3),
	.opa(opa_U3),
	.opb(opb_U3),
		.out(out_U3),
		.ready(ready_U3),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));

fpu U4 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U4),
	.rmode(rmode_U4),
	.fpu_op(fpu_op_U4),
	.opa(opa_U4),
	.opb(opb_U4),
		.out(out_U4),
		.ready(ready_U4),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));

fpu U5 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U5),
	.rmode(rmode_U5),
	.fpu_op(fpu_op_U5),
	.opa(opa_U5),
	.opb(opb_U5),
		.out(out_U5),
		.ready(ready_U5),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));

fpu U6 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U6),
	.rmode(rmode_U6),
	.fpu_op(fpu_op_U6),
	.opa(opa_U6),
	.opb(opb_U6),
		.out(out_U6),
		.ready(ready_U6),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));



//fpu_op (operation code, 3 bits, 000 = add, 001 = subtract,010 = multiply, 011 = divide, others are not used)
endmodule // echo_cancelation

