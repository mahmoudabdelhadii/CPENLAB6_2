module ALU_tb; //Ain,Bin,ALUop,out,Z
reg[15:0]Ain,Bin;
reg[1:0]ALUop;  // 00 +   //~(B)
reg err;	// 01 -
wire Z;		// 10 &
wire[15:0]out;

ALU DUT(Ain,Bin,ALUop,out,Z);

initial begin
err=1'b0; ALUop=2'b00; Ain=16'b0000_0000_0000_0000;Bin=16'b0000_0000_0000_0001;  //+
#5;
$display("Expected out==16'b0000_0000_0000_0001 , testbench out=%b",out);
$display("Expected Z=0, testbench Z=%b",Z);
if(out!==16'b0000_0000_0000_0001 | Z!==0)begin $display("FAILED"); $stop; end
else err=1'b0; 

ALUop=2'b01; Ain=16'b0000_0000_0000_0011;Bin=16'b0000_0000_0000_0001; //-
#5;
$display("Expected out==16'b0000_0000_0000_0010 , testbench out=%b",out);
$display("Expected Z=0, testbench Z=%b",Z);
if(out!==16'b0000_0000_0000_0010 | Z!==1'b0)begin $display("FAILED"); $stop; end
else err=1'b0; 

ALUop=2'b10; Ain=16'b0100_0100_0000_0011;Bin=16'b0000_0000_0000_0000; //&
#5;
$display("Expected out==16'b0000_0000_0000_0000 , testbench out=%b",out);
$display("Expected Z=1, testbench Z=%b",Z);
if(out!==16'b0000_0000_0000_0000 | Z!==1'b1)begin $display("FAILED"); $stop; end
else err=1'b0; 

ALUop=2'b11; Ain=16'b0000_0000_0000_0011;Bin=16'b1111_1111_1111_1110; //~B
#5;
$display("Expected out==16'b0000_0000_0000_0001 , testbench out=%b",out);
$display("Expected Z=0, testbench Z=%b",Z);
if(out!==16'b0000_0000_0000_0001 | Z!==1'b0)begin $display("FAILED");  end
else err=1'b0; 

if(~err) $display("PASSED");
else $display("FAILED");
#500;
$stop;

end



endmodule
