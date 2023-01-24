module switch(SWITCHES,LEDS);
	input[3:0] SWITCHES;
	output[3:0] LEDS;

	assign LEDS[3:0] = SWITCHES[3:0];
endmodule

