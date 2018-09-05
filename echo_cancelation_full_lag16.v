//echo_cancelation_full_lag16
//ankai liu
//takes at least 1800 for proper outputs.


`timescale 1us / 1us
module echo_cancelation_full_lag16 (
	sig16b,
	sig16b_lag,
	clk_operation,
	sampling_cycle,
	sampling_cycle_counter,
	rst,
	enable,
	set_max_iteration,
		iteration,
		sig16b_without_echo,
		iteration,
		para_approx_0,
		para_approx_1,
		para_approx_2,
		para_approx_3,
		para_approx_4,
		para_approx_5,
		para_approx_6,
		para_approx_7,
		para_approx_8,
		para_approx_9,
		para_approx_10,
		para_approx_11,
		para_approx_12,
		para_approx_13,
		para_approx_14,
		para_approx_15
);


input [12:0] sampling_cycle, sampling_cycle_counter;
input rst,clk_operation,enable;
input [15:0] sig16b,sig16b_lag;
input [12:0] set_max_iteration;
output reg [12:0] iteration = 0;
output wire [15:0] sig16b_without_echo;
output wire [63:0] para_approx_0,para_approx_1,para_approx_2,para_approx_3,para_approx_4,para_approx_5,para_approx_6,para_approx_7,para_approx_8,para_approx_9,para_approx_10,para_approx_11,para_approx_12,para_approx_13,para_approx_14,para_approx_15;

reg enable_MUT1,enable_MUT2,enable_MUT3,enable_MUT4,enable_MUT5;
wire [63:0] sig_double,sig_lag_double;
wire [63:0] signal_without_echo;
wire [10:0] signal_without_echo_exp;
wire ready_MUT1,ready_MUT2,ready_MUT3;
wire [10:0] e_exp,normalize_amp_exp;
wire [63:0] e;
reg [63:0] sig_double_MUT3,sig_lag_double_MUT3,sig_lag_double_MUT4,sig_double_MUT4;
reg enable_sampling_MUT3, enable_sampling_MUT4;
reg enable_para_approx;
reg [63:0] double_MUT5;


always @(posedge clk_operation) begin
	if (rst) begin
		iteration = 0;
		enable_para_approx <= 1;
	end
	if (iteration >= set_max_iteration) enable_para_approx <= 0;
end

sig16b_to_double MUT1(				//#50
	.clk_operation(clk_operation),
	.rst(rst),
	.sig16b(sig16b),
	.enable(enable_MUT1),
		.double(sig_double),
		.ready(ready_MUT1)
);

sig16b_to_double MUT2(				//50
	.clk_operation(clk_operation),
	.rst(rst),
	.sig16b(sig16b_lag),
	.enable(enable_MUT2),
		.double(sig_lag_double),
		.ready(ready_MUT2)
);

para_approx_lag16 MUT3(			//1200
	.rst(rst),
	.sampling_cycle_counter(sampling_cycle_counter),
	.clk_operation(clk_operation),
	.enable_sampling(enable_sampling_MUT3),
	.enable(enable_MUT3),
	.signal(sig_double_MUT3),
	.signal_lag(sig_lag_double_MUT3),
	.gamma(64'b0011111111010000000000000000000000000000000000000000000000000000),
//default      64'b0 01111111101 0000000000000000000000000000000000000000000000000000; //0.01
	.mu(64'b0011111111110000000000000000000000000000000000000000000000000000),
//default   64'b0 01111111111 0000000000000000000000000000000000000000000000000000; //1
		.para_0(para_approx_0),
		.para_1(para_approx_1),
		.para_2(para_approx_2),
		.para_3(para_approx_3),
		.para_4(para_approx_4),
		.para_5(para_approx_5),
		.para_6(para_approx_6),
		.para_7(para_approx_7),
		.para_8(para_approx_8),
		.para_9(para_approx_9),
		.para_10(para_approx_10),
		.para_11(para_approx_11),
		.para_12(para_approx_12),
		.para_13(para_approx_13),
		.para_14(para_approx_14),
		.para_15(para_approx_15),
		.e(e),
		.e_exp(e_exp),
		.normalize_amp_exp(normalize_amp_exp),
		.ready(ready_MUT3)
);

echo_cancelation_lag16 MUT4(			//500
	.rst(rst),
	.sampling_cycle_counter(sampling_cycle_counter),
	.clk_operation(clk_operation),
	.enable_sampling(enable_sampling_MUT4),
	.enable(enable_MUT4),
	.signal_receive(sig_lag_double_MUT4),
	.signal_send(sig_double_MUT4),
	.para_0(para_approx_0),
	.para_1(para_approx_1),
	.para_2(para_approx_2),
	.para_3(para_approx_3),
	.para_4(para_approx_4),
	.para_5(para_approx_5),
	.para_6(para_approx_6),
	.para_7(para_approx_7),
	.para_8(para_approx_8),
	.para_9(para_approx_9),
	.para_10(para_approx_10),
	.para_11(para_approx_11),
	.para_12(para_approx_12),
	.para_13(para_approx_13),
	.para_14(para_approx_14),
	.para_15(para_approx_15),
		.signal_without_echo(signal_without_echo),
		.signal_without_echo_exp(signal_without_echo_exp),
		.ready(ready_MUT4)
);

double_to_sig16b MUT5(
	.sampling_cycle_counter(sampling_cycle_counter),
	.clk_operation(clk_operation),
	.rst(rst),
	.enable(enable_MUT5),
	.double(double_MUT5),
		.sig16b(sig16b_without_echo)
);

always @(posedge clk_operation) begin
	if (enable) begin
	if (enable_para_approx) begin
		if (sampling_cycle_counter == 0) begin
			enable_MUT1 <= 1;
			enable_MUT2 <= 1;
			#4            //double operation clk
			enable_MUT1 <= 0;
			enable_MUT2 <= 0;
			#50
			if (ready_MUT1&ready_MUT2) begin
				sig_double_MUT3 <= sig_double;
				sig_double_MUT3 <= sig_lag_double;
				sig_lag_double_MUT4 <= sig_lag_double;
				sig_double_MUT4 <= sig_double;
				enable_MUT3 <= 1;
				enable_sampling_MUT3 <= 1;
				enable_sampling_MUT4 <= 1;
				#4
				enable_MUT3 <= 0;
			end
			#1200
			if (ready_MUT3) begin
				enable_MUT4 <= 1;
				#4
				enable_MUT4 <= 0;
			end
			#500
			if (ready_MUT4) begin
				enable_MUT5 <= 1;
				double_MUT5 <= e;
				iteration <= iteration + 1;
			end
		end
	end
	else begin
		if (sampling_cycle_counter == 0) begin
			enable_MUT1 <= 1;
			enable_MUT2 <= 1;
			#4            //double operation clk
			enable_MUT1 <= 0;
			enable_MUT2 <= 0;
			#50
			if (ready_MUT1&ready_MUT2) begin
				sig_double_MUT3 <= sig_double;
				sig_lag_double_MUT3 <= sig_lag_double;
				sig_lag_double_MUT4 <= sig_lag_double;
				sig_double_MUT4 <= sig_double;
				enable_sampling_MUT3 <= 1;
				enable_sampling_MUT4 <= 1;
				enable_MUT4 <= 1;
				#4
				enable_MUT4 <= 0;
			end
			#500
			if (ready_MUT4) begin
				enable_MUT5 <= 1;
				double_MUT5 <= signal_without_echo;
			end
			end
	end
	end
end
endmodule //echo_cancelation_full
