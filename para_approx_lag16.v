/**************************************************************************
***                          para approximation                         ***                       
***                            Author :   LAK                           ***  
**************************************************************************/
//4 sampling clks 500 operation clks(250 cycle)


`timescale 1us/1us
module para_approx(
rst,
sampling_cycle_counter,
clk_operation,
enable_sampling,
enable,
signal, 
signal_lag,
gamma,   //default 64'b0 01111111101 0000000000000000000000000000000000000000000000000000; //0.01
mu,	 //default 64'b0 01111111111 0000000000000000000000000000000000000000000000000000; //1
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
	e,
	e_exp,
	normalize_amp_exp,
	ready
);

input [63:0] signal,signal_lag;
input [12:0] sampling_cycle_counter;
input clk_operation,rst,enable,enable_sampling;
input [63:0] gamma;
input [63:0] mu;
output reg [63:0] para_0,para_1,para_2,para_3,para_4,para_5,para_6,para_7,para_8,para_9,para_10,para_11,para_12,para_13,para_14,para_15;
output reg ready;
output reg [10:0] e_exp,normalize_amp_exp;
output reg [63:0] e;

reg enable_internal;
reg enable_U0,enable_U1,enable_U2,enable_U3,enable_U4,enable_U5,enable_U6,enable_U7;
reg [1:0]rmode_U0,rmode_U1,rmode_U2,rmode_U3,rmode_U4,rmode_U5,rmode_U6,rmode_U7;
reg [2:0]fpu_op_U0,fpu_op_U1,fpu_op_U2,fpu_op_U3,fpu_op_U4,fpu_op_U5,fpu_op_U6,fpu_op_U7;
reg [63:0]opa_U0,opa_U1,opa_U2,opa_U3,opa_U4,opa_U5,opa_U6,opa_U7;
reg [63:0]opb_U0,opb_U1,opb_U2,opb_U3,opb_U4,opb_U5,opb_U6,opb_U7;
wire [63:0]out_U0,out_U1,out_U2,out_U3,out_U4,out_U5,out_U6,out_U7;
wire ready_U0,ready_U1,ready_U2,ready_U3,ready_U4,ready_U5,ready_U6,ready_U7;
wire underflow;
wire overflow;
wire inexact;
wire exception;
wire invalid;  

reg [2:0] count_sampling;
reg [3:0] count_operation;
reg [63:0] lag_0,lag_1,lag_2,lag_3,lag_4,lag_5,lag_6,lag_7,lag_8,lag_9,lag_10,lag_11,lag_12,lag_13,lag_14,lag_15;
reg [63:0] signal_lag_align;

reg [63:0] lp0,lp1,lp2,lp3,lp4,lp5,lp6,lp7;										//count_operation == 0
reg [63:0] lp8,lp9,lp10,lp11,lp12,lp13,lp14,lp15; 									//count_operation == 1
reg [63:0] lp0_1,lp2_3,lp4_5,lp6_7,lp8_9,lp10_11,lp12_13,lp14_15;							//count_operation == 2
reg [63:0] lp0_to_3,lp4_to_7,lp8_to_11,lp12_to_15,LL0,LL1,LL2,LL3;   							//count_operation == 3
reg [63:0] lp0_to_7,lp8_to_15,LL4,LL5,LL6,LL7,LL8,LL9;									//count_operation == 4
reg [63:0] lp0_to_15,LL10,LL11,LL12,LL13,LL14,LL15,LL0_1;								//count_operation == 5	
reg [63:0] LL2_3,LL4_5,LL6_7,LL8_9,LL10_11,LL12_13,LL14_15;								//count_operation == 6
reg [63:0] e_mu,LL0_to_3,LL4_to_7,LL8_to_11,LL12_to_15;									//count_operation == 7
reg [63:0] LL0_to_7,LL8_to_15,e_mu_L0,e_mu_L1,e_mu_L2,e_mu_L3,e_mu_L4,e_mu_L5;						//count_operation == 8
reg [63:0] LL0_to_15,e_mu_L6,e_mu_L7,e_mu_L8,e_mu_L9,e_mu_L10,e_mu_L11,e_mu_L12;					//count_operation == 9
reg [63:0] normalize_amp,e_mu_L13,e_mu_L14,e_mu_L15;									//count_operation == 10
reg [63:0] de_e_mu_L0,de_e_mu_L1,de_e_mu_L2,de_e_mu_L3,de_e_mu_L4,de_e_mu_L5,de_e_mu_L6,de_e_mu_L7;			//count_operation == 11
reg [63:0] de_e_mu_L8,de_e_mu_L9,de_e_mu_L10,de_e_mu_L11,de_e_mu_L12,de_e_mu_L13,de_e_mu_L14,de_e_mu_L15;		//count_operation == 12





always @(posedge clk_operation) begin
	if (rst) begin 
		//lag_3 <= 0;
		//lag_2 <= 0;
		//lag_1 <= 0;
		//lag_0 <= 0;	
		para_0 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_1 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_2 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_3 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_4 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_5 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_6 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_7 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_8 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_9 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_10 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_11 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_12 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_13 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_14 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		para_15 <= 64'b0000000000010000000000000000000000000000000000000000000000000000;
		count_sampling <= 0;
		enable_internal <= 0;
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
				lag_0 <= signal;
				count_sampling <= 1;
				signal_lag_align <= signal_lag; //signal_lag alignment;

			end
			1: begin
				lag_1 <= lag_0;
				lag_0 <= signal;
				count_sampling <= 2;
				signal_lag_align <= signal_lag; 
			end
			2: begin
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal;
				count_sampling <= 3;
				signal_lag_align <= signal_lag; 
			end
			3: begin
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal;
				count_sampling <= 4;
				signal_lag_align <= signal_lag; 
			end
			4: begin
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal;
				count_sampling <= 5;
				signal_lag_align <= signal_lag; 
			end
			5: begin
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal;
				count_sampling <= 6;
				signal_lag_align <= signal_lag; 
			end
			6: begin
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal;
				count_sampling <= 7;
				signal_lag_align <= signal_lag; 
			end
			7: begin
				lag_7 <= lag_6;
				lag_6 <= lag_5;
				lag_5 <= lag_4;
				lag_4 <= lag_3;
				lag_3 <= lag_2;
				lag_2 <= lag_1;
				lag_1 <= lag_0;
				lag_0 <= signal;
				count_sampling <= 8;
				signal_lag_align <= signal_lag; 
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
				lag_0 <= signal;
				count_sampling <= 9;
				signal_lag_align <= signal_lag; 
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
				lag_0 <= signal;
				count_sampling <= 10;
				signal_lag_align <= signal_lag; 
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
				lag_0 <= signal;
				count_sampling <= 11;
				signal_lag_align <= signal_lag; 
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
				lag_0 <= signal;
				count_sampling <= 12;
				signal_lag_align <= signal_lag; 
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
				lag_0 <= signal;
				count_sampling <= 13;
				signal_lag_align <= signal_lag; 
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
				lag_0 <= signal;
				count_sampling <= 14;
				signal_lag_align <= signal_lag;
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
				lag_0 <= signal;
				count_sampling <= 15;
				signal_lag_align <= signal_lag; 
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
				lag_0 <= signal;
				count_operation <= 0;
				signal_lag_align <= signal_lag; //we delay samply to align with the lag.
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
			fpu_op_U0 <= 3'b010; //out = lag_0*para_0
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lag_1;
			opb_U1 <= para_1;
			fpu_op_U1 <= 3'b010; //out = lag_1*para_1
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lag_2;
			opb_U2 <= para_2;
			fpu_op_U2 <= 3'b010; //out = lag_2*para_2
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lag_3;
			opb_U3 <= para_3;
			fpu_op_U3 <= 3'b010; //out = lag_3*para_3
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lag_4;
			opb_U4 <= para_4;
			fpu_op_U4 <= 3'b010; //out = lag_4*para_4
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_5;
			opb_U5 <= para_5;
			fpu_op_U5 <= 3'b010; //out = lag_5*para_5
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_6;
			opb_U6 <= para_6;
			fpu_op_U6 <= 3'b010; //out = lag_6*para_6
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= lag_7;
			opb_U7 <= para_7;
			fpu_op_U7 <= 3'b010; //out = lag_7*para_7
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				lp0 <= out_U0;
				lp1 <= out_U1;
				lp2 <= out_U2;
				lp3 <= out_U3;
				lp4 <= out_U4;
				lp5 <= out_U5;
				lp6 <= out_U6;
				lp7 <= out_U7;
				count_operation <= 1;
			end
		end
		1: begin
			opa_U0 <= lag_8;
			opb_U0 <= para_8;
			fpu_op_U0 <= 3'b010; //out = lag_8*para_8
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lag_9;
			opb_U1 <= para_9;
			fpu_op_U1 <= 3'b010; //out = lag_9*para_9
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lag_10;
			opb_U2 <= para_10;
			fpu_op_U2 <= 3'b010; //out = lag_10*para_10
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lag_11;
			opb_U3 <= para_11;
			fpu_op_U3 <= 3'b010; //out = lag_11*para_11
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lag_12;
			opb_U4 <= para_12;
			fpu_op_U4 <= 3'b010; //out = lag_12*para_12
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_13;
			opb_U5 <= para_13;
			fpu_op_U5 <= 3'b010; //out = lag_13*para_13
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_14;
			opb_U6 <= para_14;
			fpu_op_U6 <= 3'b010; //out = lag_14*para_14
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= lag_15;
			opb_U7 <= para_15;
			fpu_op_U7 <= 3'b010; //out = lag_15*para_15
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				lp8 <= out_U0;
				lp9 <= out_U1;
				lp10 <= out_U2;
				lp11 <= out_U3;
				lp12 <= out_U4;
				lp13 <= out_U5;
				lp14 <= out_U6;
				lp15 <= out_U7;
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

			opa_U5 <= lp10;
			opb_U5 <= lp11;
			fpu_op_U5 <= 3'b000; //out = lp10+lp11
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lp12;
			opb_U6 <= lp13;
			fpu_op_U6 <= 3'b000; //out = lp12+lp13
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= lp14;
			opb_U7 <= lp15;
			fpu_op_U7 <= 3'b000; //out = lp14+lp15
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				lp0_1 <= out_U0;
				lp2_3 <= out_U1;
				lp4_5 <= out_U2;
				lp6_7 <= out_U3;
				lp8_9 <= out_U4;
				lp10_11 <= out_U5;
				lp12_13 <= out_U6;
				lp14_15 <= out_U7;
				count_operation <= 3;
			end
		end
		3: begin
			opa_U0 <= lp0_1;
			opb_U0 <= lp2_3;
			fpu_op_U0 <= 3'b000; //out = lp0+..+lp3
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lp4_5;
			opb_U1 <= lp6_7;
			fpu_op_U1 <= 3'b000; //out = lp4+..+lp7
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lp8_9;
			opb_U2 <= lp10_11;
			fpu_op_U2 <= 3'b000; //out = lp8+..+lp11
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lp12_13;
			opb_U3 <= lp14_15;
			fpu_op_U3 <= 3'b000; //out = lp12+..+lp15
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lag_0;
			opb_U4 <= lag_0;
			fpu_op_U4 <= 3'b010; //out = LL0
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_1;
			opb_U5 <= lag_1;
			fpu_op_U5 <= 3'b010; //out = LL1
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_2;
			opb_U6 <= lag_2;
			fpu_op_U6 <= 3'b010; //out = LL2
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= lag_3;
			opb_U7 <= lag_3;
			fpu_op_U7 <= 3'b010; //out = LL3
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				lp0_to_3 <= out_U0;
				lp4_to_7 <= out_U1;
				lp8_to_11 <= out_U2;
				lp12_to_15 <= out_U3;
				LL0 <= out_U4;
				LL1 <= out_U5;
				LL2 <= out_U6;
				LL3 <= out_U7;
				count_operation <= 4;
			end
		end
		4: begin
			opa_U0 <= lp0_to_3;
			opb_U0 <= lp4_to_7;
			fpu_op_U0 <= 3'b000; //out = lp0+..+lp7
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lp8_to_11;
			opb_U1 <= lp12_to_15;
			fpu_op_U1 <= 3'b000; //out = lp8+..+lp15
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lag_4;
			opb_U2 <= lag_4;
			fpu_op_U2 <= 3'b010; //out = LL4
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lag_5;
			opb_U3 <= lag_5;
			fpu_op_U3 <= 3'b010; //out = LL5
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lag_6;
			opb_U4 <= lag_6;
			fpu_op_U4 <= 3'b010; //out = LL6
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_7;
			opb_U5 <= lag_7;
			fpu_op_U5 <= 3'b010; //out = LL7
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_8;
			opb_U6 <= lag_8;
			fpu_op_U6 <= 3'b010; //out = LL8
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= lag_9;
			opb_U7 <= lag_9;
			fpu_op_U7 <= 3'b010; //out = LL9
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				lp0_to_7 <= out_U0;
				lp8_to_15 <= out_U1;
				LL4 <= out_U2;
				LL5 <= out_U3;
				LL6 <= out_U4;
				LL7 <= out_U5;
				LL8 <= out_U6;
				LL9 <= out_U7;
				count_operation <= 5;
			end
		end
		5: begin
			opa_U0 <= lp0_to_7;
			opb_U0 <= lp8_to_15;
			fpu_op_U0 <= 3'b000; //out = lp0+..+lp15
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= lag_10;
			opb_U1 <= lag_10;
			fpu_op_U1 <= 3'b010; //out = LL10
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= lag_11;
			opb_U2 <= lag_11;
			fpu_op_U2 <= 3'b010; //out = LL11
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= lag_12;
			opb_U3 <= lag_12;
			fpu_op_U3 <= 3'b010; //out = LL12
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= lag_13;
			opb_U4 <= lag_13;
			fpu_op_U4 <= 3'b010; //out = LL13
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= lag_14;
			opb_U5 <= lag_14;
			fpu_op_U5 <= 3'b010; //out = LL14
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= lag_15;
			opb_U6 <= lag_15;
			fpu_op_U6 <= 3'b010; //out = LL15
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= LL0;
			opb_U7 <= LL1;
			fpu_op_U7 <= 3'b000; //out = LL0+LL1
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				lp0_to_15 <= out_U0;
				LL10 <= out_U1;
				LL11 <= out_U2;
				LL12 <= out_U3;
				LL13 <= out_U4;
				LL14 <= out_U5;
				LL15 <= out_U6;
				LL0_1 <= out_U7;
				count_operation <= 6;
			end
		end
		6: begin
			opa_U0 <= signal_lag_align;
			opb_U0 <= lp0_to_15;
			fpu_op_U0 <= 3'b001; //out = sig_lp0_15 or e
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= LL2;
			opb_U1 <= LL3;
			fpu_op_U1 <= 3'b000; //out = LL2+LL3
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= LL4;
			opb_U2 <= LL5;
			fpu_op_U2 <= 3'b000; //out = LL4+LL5
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= LL6;
			opb_U3 <= LL7;
			fpu_op_U3 <= 3'b000; //out = LL6+LL7
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= LL8;
			opb_U4 <= LL9;
			fpu_op_U4 <= 3'b010; //out = LL8+LL9
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= LL10;
			opb_U5 <= LL11;
			fpu_op_U5 <= 3'b000; //out = LL10+LL11
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= LL12;
			opb_U6 <= LL13;
			fpu_op_U6 <= 3'b000; //out = LL12+LL13
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= LL14;
			opb_U7 <= LL15;
			fpu_op_U7 <= 3'b000; //out = LL14+LL15
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				e <= out_U0;				
				e_exp <= out_U0[62:52] - 1023;	 //unbias error of prediction
				LL2_3 <= out_U1;
				LL4_5 <= out_U2;
				LL6_7 <= out_U3;
				LL8_9 <= out_U4;
				LL10_11 <= out_U5;
				LL12_13 <= out_U6;
				LL14_15 <= out_U7;
				count_operation <= 7;
			end
		end
		7: begin
			opa_U0 <= mu;
			opb_U0 <= e;
			fpu_op_U0 <= 3'b010; //out = mu_e
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= LL0_1;
			opb_U1 <= LL2_3;
			fpu_op_U1 <= 3'b000; //out = LL0+..+LL3
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= LL4_5;
			opb_U2 <= LL6_7;
			fpu_op_U2 <= 3'b000; //out = LL4+..+LL7
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= LL8_9;
			opb_U3 <= LL10_11;
			fpu_op_U3 <= 3'b000; //out = LL8+..+LL11
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= LL12_13;
			opb_U4 <= LL14_15;
			fpu_op_U4 <= 3'b000; //out = LL12+..+LL15
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
				e_mu <= out_U0;				
				LL0_to_3 <= out_U1;
				LL4_to_7 <= out_U2;
				LL8_to_11 <= out_U3;
				LL12_to_15 <= out_U4;
				count_operation <= 8;
			end
		end
		8: begin
			opa_U0 <= LL0_to_3;
			opb_U0 <= LL4_to_7;
			fpu_op_U0 <= 3'b000; //out = LL0+..+LL7
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= LL8_to_11;
			opb_U1 <= LL12_to_15;
			fpu_op_U1 <= 3'b000; //out = LL8+..+LL15
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= e_mu;
			opb_U2 <= lag_0;
			fpu_op_U2 <= 3'b010; //out = e_mu_L0
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= e_mu;
			opb_U3 <= lag_1;
			fpu_op_U3 <= 3'b010; //out = e_mu_L1
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= e_mu;
			opb_U4 <= lag_2;
			fpu_op_U4 <= 3'b010; //out = e_mu_L2
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= e_mu;
			opb_U5 <= lag_3;
			fpu_op_U5 <= 3'b010; //out = e_mu_L3
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= e_mu;
			opb_U6 <= lag_4;
			fpu_op_U6 <= 3'b010; //out = e_mu_L4
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= e_mu;
			opb_U7 <= lag_5;
			fpu_op_U7 <= 3'b010; //out = e_mu_L5
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				LL0_to_7 <= out_U0;				
				LL8_to_15 <= out_U1;
				e_mu_L0 <= out_U2;
				e_mu_L1 <= out_U3;
				e_mu_L2 <= out_U4;
				e_mu_L3 <= out_U5;
				e_mu_L4 <= out_U6;
				e_mu_L5 <= out_U7;
				count_operation <= 9;
			end
		end
		9: begin
			opa_U0 <= LL0_to_7;
			opb_U0 <= LL8_to_15;
			fpu_op_U0 <= 3'b000; //out = LL0+..+LL15
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= e_mu;
			opb_U1 <= lag_6;
			fpu_op_U1 <= 3'b010; //out = e_mu_L6
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= e_mu;
			opb_U2 <= lag_7;
			fpu_op_U2 <= 3'b010; //out = e_mu_L7
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= e_mu;
			opb_U3 <= lag_8;
			fpu_op_U3 <= 3'b010; //out = e_mu_L8
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= e_mu;
			opb_U4 <= lag_9;
			fpu_op_U4 <= 3'b010; //out = e_mu_L9
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= e_mu;
			opb_U5 <= lag_10;
			fpu_op_U5 <= 3'b010; //out = e_mu_L10
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= e_mu;
			opb_U6 <= lag_11;
			fpu_op_U6 <= 3'b010; //out = e_mu_L11
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= e_mu;
			opb_U7 <= lag_12;
			fpu_op_U7 <= 3'b010; //out = e_mu_L12
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				LL0_to_15 <= out_U0;				
				e_mu_L6 <= out_U1;
				e_mu_L7 <= out_U2;
				e_mu_L8 <= out_U3;
				e_mu_L9 <= out_U4;
				e_mu_L10 <= out_U5;
				e_mu_L11 <= out_U6;
				e_mu_L12 <= out_U7;
				count_operation <= 10;
			end
		end
		9: begin
			opa_U0 <= gamma;
			opb_U0 <= LL0_to_15;
			fpu_op_U0 <= 3'b000; //out = gamma_LL0_15 or (normalize_amp)
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= e_mu;
			opb_U1 <= lag_13;
			fpu_op_U1 <= 3'b010; //out = e_mu_L13
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= e_mu;
			opb_U2 <= lag_14;
			fpu_op_U2 <= 3'b010; //out = e_mu_L14
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= e_mu;
			opb_U3 <= lag_15;
			fpu_op_U3 <= 3'b010; //out = e_mu_L15
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3 == 1) begin
				normalize_amp <= out_U0;		
				normalize_amp_exp <= out_U0[62:52] - 1023;			
				e_mu_L13 <= out_U1;
				e_mu_L14 <= out_U2;
				e_mu_L15 <= out_U3;
				count_operation <= 11;
			end
		end
		11: begin
			opa_U0 <= e_mu_L0;
			opb_U0 <= normalize_amp;
			fpu_op_U0 <= 3'b011; //out = de_e_mu_L0
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= e_mu_L1;
			opb_U1 <= normalize_amp;
			fpu_op_U1 <= 3'b011; //out = de_e_mu_L1
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= e_mu_L2;
			opb_U2 <= normalize_amp;
			fpu_op_U2 <= 3'b011; //out = de_e_mu_L2
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= e_mu_L3;
			opb_U3 <= normalize_amp;
			fpu_op_U3 <= 3'b011; //out = de_e_mu_L3
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= e_mu_L4;
			opb_U4 <= normalize_amp;
			fpu_op_U4 <= 3'b011; //out = de_e_mu_L4
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= e_mu_L5;
			opb_U5 <= normalize_amp;
			fpu_op_U5 <= 3'b011; //out = de_e_mu_L5
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= e_mu_L6;
			opb_U6 <= normalize_amp;
			fpu_op_U6 <= 3'b011; //out = de_e_mu_L6
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= e_mu_L7;
			opb_U7 <= normalize_amp;
			fpu_op_U7 <= 3'b011; //out = de_e_mu_L7
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#160;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				de_e_mu_L0 <= out_U0;				
				de_e_mu_L1 <= out_U1;
				de_e_mu_L2 <= out_U2;
				de_e_mu_L3 <= out_U3;
				de_e_mu_L4 <= out_U4;
				de_e_mu_L5 <= out_U5;
				de_e_mu_L6 <= out_U6;
				de_e_mu_L7 <= out_U7;
				count_operation <= 12;
			end
		end
		12: begin
			opa_U0 <= e_mu_L8;
			opb_U0 <= normalize_amp;
			fpu_op_U0 <= 3'b011; //out = de_e_mu_L8
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= e_mu_L9;
			opb_U1 <= normalize_amp;
			fpu_op_U1 <= 3'b011; //out = de_e_mu_L9
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= e_mu_L10;
			opb_U2 <= normalize_amp;
			fpu_op_U2 <= 3'b011; //out = de_e_mu_L10
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= e_mu_L11;
			opb_U3 <= normalize_amp;
			fpu_op_U3 <= 3'b011; //out = de_e_mu_L11
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= e_mu_L12;
			opb_U4 <= normalize_amp;
			fpu_op_U4 <= 3'b011; //out = de_e_mu_L12
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= e_mu_L13;
			opb_U5 <= normalize_amp;
			fpu_op_U5 <= 3'b011; //out = de_e_mu_L13
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= e_mu_L14;
			opb_U6 <= normalize_amp;
			fpu_op_U6 <= 3'b011; //out = de_e_mu_L14
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= e_mu_L15;
			opb_U7 <= normalize_amp;
			fpu_op_U7 <= 3'b011; //out = de_e_mu_L15
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#160;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				de_e_mu_L8 <= out_U0;				
				de_e_mu_L9 <= out_U1;
				de_e_mu_L10 <= out_U2;
				de_e_mu_L11 <= out_U3;
				de_e_mu_L12 <= out_U4;
				de_e_mu_L13 <= out_U5;
				de_e_mu_L14 <= out_U6;
				de_e_mu_L15 <= out_U7;
				count_operation <= 13;
			end
		end
		13: begin
			opa_U0 <= para_0;
			opb_U0 <= de_e_mu_L0;
			fpu_op_U0 <= 3'b000; //out = NEW_para_0
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= para_1;
			opb_U1 <= de_e_mu_L1;
			fpu_op_U1 <= 3'b000; //out = NEW_para_1
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= para_2;
			opb_U2 <= de_e_mu_L2;
			fpu_op_U2 <= 3'b000; //out = NEW_para_2
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= para_3;
			opb_U3 <= de_e_mu_L3;
			fpu_op_U3 <= 3'b000; //out = NEW_para_3
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= para_4;
			opb_U4 <= de_e_mu_L4;
			fpu_op_U4 <= 3'b000; //out = NEW_para_4
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= para_5;
			opb_U5 <= de_e_mu_L5;
			fpu_op_U5 <= 3'b000; //out = NEW_para_5
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= para_6;
			opb_U6 <= de_e_mu_L6;
			fpu_op_U6 <= 3'b000; //out = NEW_para_6
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= para_7;
			opb_U7 <= de_e_mu_L7;
			fpu_op_U7 <= 3'b000; //out = NEW_para_7
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				para_0 <= out_U0;				
				para_1 <= out_U1;
				para_2 <= out_U2;
				para_3 <= out_U3;
				para_4 <= out_U4;
				para_5 <= out_U5;
				para_6 <= out_U6;
				para_7 <= out_U7;
				count_operation <= 14;
			end
		end
		14: begin
			opa_U0 <= para_8;
			opb_U0 <= de_e_mu_L8;
			fpu_op_U0 <= 3'b000; //out = NEW_para_8
			rmode_U0 = 2'b00;
			enable_U0 <= 1'b1;
	
			opa_U1 <= para_9;
			opb_U1 <= de_e_mu_L9;
			fpu_op_U1 <= 3'b000; //out = NEW_para_9
			rmode_U1 = 2'b00;
			enable_U1 <= 1'b1;
	
			opa_U2 <= para_10;
			opb_U2 <= de_e_mu_L10;		
			fpu_op_U2 <= 3'b000; //out = NEW_para_10
			rmode_U2 = 2'b00;
			enable_U2 <= 1'b1;
	
			opa_U3 <= para_11;
			opb_U3 <= de_e_mu_L11;
			fpu_op_U3 <= 3'b000; //out = NEW_para_11
			rmode_U3 = 2'b00;
			enable_U3 <= 1'b1;
	
			opa_U4 <= para_12;
			opb_U4 <= de_e_mu_L12;
			fpu_op_U4 <= 3'b000; //out = NEW_para_12
			rmode_U4 = 2'b00;
			enable_U4 <= 1'b1;

			opa_U5 <= para_13;
			opb_U5 <= de_e_mu_L13;
			fpu_op_U5 <= 3'b000; //out = NEW_para_13
			rmode_U5 = 2'b00;
			enable_U5 <= 1'b1;

			opa_U6 <= para_14;
			opb_U6 <= de_e_mu_L14;
			fpu_op_U6 <= 3'b000; //out = NEW_para_14
			rmode_U6 = 2'b00;
			enable_U6 <= 1'b1;

			opa_U7 <= para_15;
			opb_U7 <= de_e_mu_L15;
			fpu_op_U7 <= 3'b000; //out = NEW_para_15
			rmode_U7 = 2'b00;
			enable_U7 <= 1'b1;

			#4;
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			
			#60;

			if (ready_U0&ready_U1&ready_U2&ready_U3&ready_U4&ready_U5&ready_U6&ready_U7 == 1) begin
				para_8 <= out_U0;				
				para_9 <= out_U1;
				para_10 <= out_U2;
				para_11 <= out_U3;
				para_12 <= out_U4;
				para_13 <= out_U5;
				para_14 <= out_U6;
				para_15 <= out_U7;
				count_operation <= 15;				
				enable_internal <= 0;
				ready <= 1;

			end
		end
		15: begin
			enable_U0 <= 1'b0;
			enable_U1 <= 1'b0;
			enable_U2 <= 1'b0;
			enable_U3 <= 1'b0;
			enable_U4 <= 1'b0;
			enable_U5 <= 1'b0;
			enable_U6 <= 1'b0;
			enable_U7 <= 1'b0;
			end
		default:;
		endcase
	end
	end
end	

// fpu modules *8
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

fpu U7 (
	.clk(clk_operation),
	.rst(rst),
	.enable(enable_U7),
	.rmode(rmode_U7),
	.fpu_op(fpu_op_U7),
	.opa(opa_U7),
	.opb(opb_U7),
		.out(out_U7),
		.ready(ready_U7),
		.underflow(underflow),
		.overflow(overflow),
		.inexact(inexact),
		.exception(exception),
		.invalid(invalid));

//fpu_op (operation code, 3 bits, 000 = add, 001 = subtract,010 = multiply, 011 = divide, others are not used)
endmodule // para_approx

