`timescale 1ns / 1ps

module lab0_top(
    //input     [1:0] sw,
    input     [3:0] btn,
    output    [3:0] led
    );

  // Connect two right-most switches to the two right-most LEDs
  //assign led = sw;
  assign led = btn;
  
endmodule
