module ALU_tb; //Ain,Bin,ALUop,out,Z
reg[15:0]Ain,Bin;
reg[1:0]ALUop;  // 00 +   //~(B)
reg err;	// 01 -
wire[2:0]ZNO;		// 10 &
wire[15:0]out;

ALU DUT(Ain,Bin,ALUop,out,ZNO);

initial begin
err=1'b0; ALUop=2'b00; Ain=16'b0000_0000_0000_0000;Bin=16'b0000_0000_0000_0001;  //+
#5;
$display("Expected out==16'b0000_0000_0000_0001 , testbench out=%b",out);
$display("Expected ZNO=000, testbench ZNO=%b",ZNO);
if(out!==16'b0000_0000_0000_0001 | ZNO!==3'b000)begin $display("FAILED"); err = 1'b1; end
else err=1'b0; 

ALUop=2'b01; Ain=16'b0000_0000_0000_0011;Bin=16'b0000_0000_0000_0001; //-
#5;
$display("Expected out==16'b0000_0000_0000_0010 , testbench out=%b",out);
$display("Expected ZNO=000, testbench ZNO=%b",ZNO);
if(out!==16'b0000_0000_0000_0010 | ZNO!==3'b000)begin $display("FAILED"); err = 1'b1; end
else err=1'b0; 

ALUop=2'b10; Ain=16'b0100_0100_0000_0011;Bin=16'b0000_0000_0000_0000; //&
#5;
$display("Expected out==16'b0000_0000_0000_0000 , testbench out=%b",out);
$display("Expected ZNO=100, testbench ZNO=%b",ZNO);
if(out!==16'b0000_0000_0000_0000 | ZNO!==3'b100)begin $display("FAILED");err = 1'b1; end
else err=1'b0; 

ALUop=2'b11; Ain=16'b0000_0000_0000_0011;Bin=16'b1111_1111_1111_1110; //~B
#5;
$display("Expected out==16'b0000_0000_0000_0001 , testbench out=%b",out);
$display("Expected ZNO=000, testbench ZNO=%b",ZNO);
if(out!==16'b0000_0000_0000_0001 | ZNO!==3'b000)begin $display("FAILED"); err = 1'b1; end
else err=1'b0; 

ALUop=2'b11; Ain=16'b0000_0000_0000_0011;Bin=16'b1111_1111_1111_1110; //Z
#5;
$display("Expected out==16'b0000_0000_0000_0001 , testbench out=%b",out);
$display("Expected ZNO=000, testbench ZNO=%b",ZNO);
if(out!==16'b0000_0000_0000_0001 | ZNO!==3'b000)begin $display("FAILED"); err = 1'b1; end
else err=1'b0; 

ALUop=2'b01; Ain=16'b0000_0000_0000_0011;Bin=16'b0000_0000_0000_0111; //N
#5;
$display("Expected out==16'b1111_1111_1111_1100 , testbench out=%b",out);
$display("Expected ZNO=010, testbench ZNO=%b",ZNO);
if(out!==16'b1111_1111_1111_1100 | ZNO!==3'b010)begin $display("FAILED"); err = 1'b1; end
else err=1'b0; 

ALUop=2'b00; Ain=16'b0111_1111_1111_1110;Bin=16'b0000_0000_0000_1111; //O
#5;
$display("Expected out==16'b1000000000001101 , testbench out=%b",out);
$display("Expected ZNO=011, testbench ZNO=%b",ZNO);
if(out!==16'b1000000000001101 | ZNO!==3'b011)begin $display("FAILED"); err = 1'b1;  end
else err=1'b0; 




if(~err) $display("PASSED");
else $display("FAILED");
#20;
$stop;

end



endmodule


