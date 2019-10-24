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

//Move Instructions
//MOV1
//Mov1: Test 1 --> opcode = 110, op = 10,  Rn = 000,  im8 = 8'b00000111
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

//Mov 1: Test 2 --> opcode = 110, op = 10, Rn = 001, im8 = 8'b00000010
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


//Mov 1: Test 3 --> opcode = 110, op = 10, Rn = 011, im8 = 8'b00000011
    in = 16'b1101001100000011;       
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'h3) begin
      err = 1;
      $display("FAILED: MOV R3, #3");
     
    end

//MOV2
//Mov2: Test 1 --> opcode= 110, op = 00, Rn = 000, Rd = 001, sh = 00, Rm = 010;
    
    in = 16'b1100000000100010;  

    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== cpu_tb.DUT.DP.REGFILE.R2) begin
      err = 1;
      $display("FAILED: MOV R1, R2{<no_shift>}");
     
    end

//Mov2: Test 2 --> opcode = 110, op = 00, Rn = 000, Rd = 010, sh = 01, Rm = 001
    in = 16'b1100000001001001;
    R[1]=16'b0000000000000001;

    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd2) begin
      err = 1;
      $display("FAILED: MOV R2,R1{<shift_left>}");
     
    end

//Mov2: Test 3 --> opcode = 110, op = 00, Rn = 000, Rd = 010, sh = 10, Rm = 010
    in = 16'b1100000001010010;
    R[2] = 16'b0000000000000010;
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd1) begin
      err = 1;
      $display("FAILED: MOV2 R2,R2{<shift_right>}");
     
    end


//ALU Instructions
//ADD
//ADD test 1 --> opcode=101, op = 00, Rn = 010, Rd = 001, sh = 00, Rm = 011
    in = 16'b1010001000100011; 
    R[2] = 16'd4;
    R[3] = 16'd1;
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R1 !==16'd5) begin
      err = 1;
      $display("FAILED: MOV R0,Rm");
     
    end


//ADD test 2 --> opcode = 101, op=00, Rn = 010, Rd = 001, sh = 01, Rm = 011
    in = 16'b1100001000101011; 
    R[2] = 16'd1;
    R[3] = 16'd2;
    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'd5}) begin
      err = 1;
      $display("FAILED: ADD Rd, Rn, Rm");
     
    end

//ADD test 3 --> opcode = 101, op = 00, Rn = 010, Rd = 100, sh = 10, Rm = 001
    in = 16'b1100001010010001;
    R[2] = 16'd1;
    R[1] = 16'd2; 

    load = 1;
    s = 1;
    #20;
    load = 0;
    
    #20
    s = 0;
    @(posedge w); //wait for w to go high again
    #40;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'd2) begin
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
