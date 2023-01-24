module counter(LEDS,BTNS,CLOCK,RST);

	output reg[3:0] LEDS;
	input wire CLOCK;
	input wire BTNS[1:0];
	wire HzClock;

	clock_divider Count(HzClock,CLOCK);

	initial begin
		LEDS = 0;
	end

	always@(posedge HzClock) begin
		LEDS <= LEDS + BTNS[0] - BTNS[1];
		if(RST)
			LEDS <= 0;
		end
endmodule

module jackpot(LEDS,SWITCHES,CLOCK,RST);

	output reg[3:0] LEDS;
	input wire CLOCK;
	input wire[3:0] SWITCHES
	wire HzClock;
	reg Lock;
	reg JackSw0[3:0], JackSw1[3:0];
	wire JackEdge[3:0];
	clock_divider #(.n(20)) Count(HzClock,CLOCK)//TODO CHANGE PARAMETER TO BE FAST

	initial begin
		LEDS = 0;
	end

	always@(posedge HzClock) begin
		JackSw0 <= SWITCHES;
		JackSw1 <= JackSw0;
	end
	
	assign JackEdge = ~JackSw1 & JackSw0;

	always@(posedge HzClock) begin
		if(!Lock) begin
			if(JackEdge == LEDS)
				Lock<= 1;
				LEDS = 4'b1111;
			if(!LEDS)
				LEDS<=1;
			else
				LEDS <= LEDS<<1;
		end
		if(RST) begin
			Lock<=0;
			LEDS<=0;
		end
	end

endmodule


module clock_divider
	#(parameter n = 26) //default parameter sets it to ~1Hz
	(ClkOut, ClkIn);
	
	output wire ClkOut;//ClkOut is ~1Hz
	input wire ClkIn;//Clkin is 125MHz

	reg [n:0] Count;//Parameterized length

	always@(posedge ClkIn)
		Count <= Count + 1;

	assign ClkOut = Count[n];
endmodule

