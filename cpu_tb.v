module cpu_tb();
  reg clk, reset, s, load;
  reg [15:0] in;
  wire [15:0] out;
  wire N,V,Z,w;

  reg err;

  cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);

  initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

  initial begin
    err = 0;
    reset = 1; s = 0; load = 0; in = 16'b0;
    #20;
    reset = 0; 
    #20;

in = 16'b1101000000000111;
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
     
    end

    in = 16'b1101000100000010;
    load = 1;
    #20;
    load = 0;
    s = 1;
    #20
    s = 0;
    @(posedge w); // wait for w to go high again
    #20;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'h2) begin
      err = 1;
      $display("FAILED: MOV R1, #2");
     
    end

    in = 16'b1010000101001000;
    load = 1;
    #20;
    load = 0;
    s = 1;
    #20
    s = 0;
    @(posedge w); // wait for w to go high again
    #20;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'h10) begin
      err = 1;
      $display("FAILED: ADD R2, R1, R0, LSL#1");
      $stop;
    end


//change from here
in = 16'b1101000000000111;      //MOV1
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
     
    end
    

    in = 16'b1101000000000111;       //MOV1
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
     
    end


    in = 16'b1101000000000111;       //MOV2
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
     
    end



    in = 16'b1101000000000111;      //MOV2
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, Rm");
     
    end



    in = 16'b1101000000000111;    //MOV2
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0,Rm");
     
    end




    in = 16'b1101000000000111;       //ADD
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0,Rm");
     
    end




    in = 16'b1101000000000111;       //ADD
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: ADD Rd, Rn, Rm");
     
    end


    in = 16'b1101000000000111;       //AND
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: ADD Rd, Rn, Rm, LSL #2");
     
    end



in = 16'b1101000000000111;       //AND
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: ADD Rd, Rn, Rm");
     
    end


    in = 16'b1101000000000111;       //NOT
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: ADD Rd, Rn, Rm, LSR #2");
     
    end


    in = 16'b1101000000000111;       //NOT
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MVN R0, #7");
     
    end


    in = 16'b1101000000000111;       //NOT
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MVN R0, #7");
     
    end

    in = 16'b1101000000000111;       //CMP
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
     
    end


in = 16'b1101000000000111;       //CMP
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
     
    end


    in = 16'b1101000000000111;       //CMP
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
     
    end





if (~err) $display("INTERFACE OK");
    $stop;
  end
endmodule