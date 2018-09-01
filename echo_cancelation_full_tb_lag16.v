`timescale 1us / 1us
module echo_cancelation_full_tb_lag16 ();

reg sampling_light;

reg clk_operation;
reg [12:0] sampling_cycle, sampling_cycle_counter;

reg rst,enable_MUT1,enable_MUT2,enable_MUT3,enable_MUT4,enable_MUT5;
wire [15:0] sig16b;
wire [63:0] sig_double;
wire [15:0] sig16b_lag_MUT3,sig16b_MUT4;
wire [15:0] sig16b_without_echo;                        //finla result. expecting to be 0!!!!!!!!!!!!!!
wire ready_MUT1,ready_MUT2;
wire [63:0] signal_lag,signal_align_MUT2;
reg [63:0] para_in_0,para_in_1,para_in_2,para_in_3,para_in_4,para_in_5,para_in_6,para_in_7,para_in_8,para_in_9,para_in_10,para_in_11,para_in_12,para_in_13,para_in_14,para_in_15;
wire [63:0] para_approx_0,para_approx_1,para_approx_2,para_approx_3,para_approx_4,para_approx_5,para_approx_6,para_approx_7,para_approx_8,para_approx_9,para_approx_10,para_approx_11,para_approx_12,para_approx_13,para_approx_14,para_approx_15;

wire integer iteration;
reg enable_sampling_MUT2;

initial begin
clk_operation = 1;
sampling_cycle = 4000;
sampling_cycle_counter = 0;
rst = 1;
#200
rst = 0;
para_in_0[63] = 0;
para_in_0[62:52] = 11'b01111111111;
para_in_0[51:0] = $urandom;

para_in_1[63] = 0;
para_in_1[62:52] = 11'b01111111111;
para_in_1[51:0] = $urandom;

para_in_2[63] = 0;
para_in_2[62:52] = 11'b01111111111;
para_in_2[51:0] = $urandom;

para_in_3[63] = 0;
para_in_3[62:52] = 11'b01111111111;
para_in_3[51:0] = $urandom;

para_in_4[63] = 0;
para_in_4[62:52] = 11'b01111111111;
para_in_4[51:0] = $urandom;

para_in_5[63] = 0;
para_in_5[62:52] = 11'b01111111111;
para_in_5[51:0] = $urandom;

para_in_6[63] = 0;
para_in_6[62:52] = 11'b01111111111;
para_in_6[51:0] = $urandom;

para_in_7[63] = 0;
para_in_7[62:52] = 11'b01111111111;
para_in_7[51:0] = $urandom;

para_in_8[63] = 0;
para_in_8[62:52] = 11'b01111111111;
para_in_8[51:0] = $urandom;

para_in_9[63] = 0;
para_in_9[62:52] = 11'b01111111111;
para_in_9[51:0] = $urandom;

para_in_10[63] = 0;
para_in_10[62:52] = 11'b01111111111;
para_in_10[51:0] = $urandom;

para_in_11[63] = 0;
para_in_11[62:52] = 11'b01111111111;
para_in_11[51:0] = $urandom;

para_in_12[63] = 0;
para_in_12[62:52] = 11'b01111111111;
para_in_12[51:0] = $urandom;

para_in_13[63] = 0;
para_in_13[62:52] = 11'b01111111111;
para_in_13[51:0] = $urandom;

para_in_14[63] = 0;
para_in_14[62:52] = 11'b01111111111;
para_in_14[51:0] = $urandom;

para_in_15[63] = 0;
para_in_15[62:52] = 11'b01111111111;
para_in_15[51:0] = $urandom;

end

always #1 begin
	clk_operation <= ~clk_operation;
	sampling_cycle_counter <= sampling_cycle_counter + 1;
		if (sampling_cycle_counter >= sampling_cycle - 1) begin
			sampling_cycle_counter <= 0;
			sampling_light <= 1;
		end
		else begin
			sampling_light <= 0;
		end
end

signal_generator MUT0(
	.sampling_cycle_counter(sampling_cycle_counter),
	.clk_operation(clk_operation),
		.signal(sig16b)
);

sig16b_to_double MUT1(
	.clk_operation(clk_operation),
	.rst(rst),
	.sig16b(sig16b),
	.enable(enable_MUT1),
		.double(sig_double),
		.ready(ready_MUT1)
);

lag_generator_lag16 MUT2(
	.rst(rst),
	.enable_sampling(enable_sampling_MUT2),
	.enable(enable_MUT2),
	.sampling_cycle_counter(sampling_cycle_counter),
	.clk_operation(clk_operation),
	.signal(sig_double),
	.para_0(para_in_0),
	.para_1(para_in_1),
	.para_2(para_in_2),
	.para_3(para_in_3),
	.para_4(para_in_4),
	.para_5(para_in_5),
	.para_6(para_in_6),
	.para_7(para_in_7),
	.para_8(para_in_8),
	.para_9(para_in_9),
	.para_10(para_in_10),
	.para_11(para_in_11),
	.para_12(para_in_12),
	.para_13(para_in_13),
	.para_14(para_in_14),
	.para_15(para_in_15),
		.signal_lag(signal_lag),
		.signal_align(signal_align_MUT2),
		.ready(ready_MUT2)
);

double_to_sig16b MUT3(
	.sampling_cycle_counter(sampling_cycle_counter),
	.clk_operation(clk_operation),
	.rst(rst),
	.enable(enable_MUT3),
	.double(signal_lag),
		.sig16b(sig16b_lag_MUT3)
);

double_to_sig16b MUT4(
	.sampling_cycle_counter(sampling_cycle_counter),
	.clk_operation(clk_operation),
	.rst(rst),
	.enable(enable_MUT4),
	.double(signal_align_MUT2),
		.sig16b(sig16b_MUT4)
);

echo_cancelation_full_lag16 MUT5(
	.sig16b(sig16b_MUT4),
	.sig16b_lag(sig16b_lag_MUT3),
	.clk_operation(clk_operation),
	.sampling_cycle(sampling_cycle),
	.sampling_cycle_counter(sampling_cycle_counter),
	.rst(rst),
	.enable(enable_MUT5),
		.sig16b_without_echo(sig16b_without_echo),
		.iteration(iteration),
		.para_approx_0(para_approx_0),
		.para_approx_1(para_approx_1),
		.para_approx_2(para_approx_2),
		.para_approx_3(para_approx_3),
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
		.para_15(para_approx_15)
	);

initial begin
	enable_sampling_MUT2 <= 0;
	#8000;
	enable_sampling_MUT2 <= 1;
end

always @(posedge clk_operation) begin
	if (sampling_cycle_counter == 0) begin
		enable_MUT1 <= 1;
		#4            //double operation clk
		enable_MUT1 <= 0;
		#50
		if (ready_MUT1) begin
			enable_MUT2 <= 1;
			#4
			enable_MUT2 <= 0;
/*$display(
"##iteration: %d", iteration
);*/
		end
		#400
		if (ready_MUT2) begin
			enable_MUT3 <= 1;
			enable_MUT4 <= 1;
		end
		#4
		enable_MUT5 <= 1;
	end
end
endmodule //echo_cancelation_full_tb_lag16
