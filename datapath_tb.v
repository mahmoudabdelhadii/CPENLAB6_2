module datapath_tb;  //datapath_in,loada,loadb,loadc,loads,asel,bsel,vsel,ALUop,shift,datapath_out,Z_out,write,writenum,readnum,clk
reg err;
reg[15:0]datapath_in;
reg[2:0]writenum,readnum;
reg[1:0]ALUop,shift;
reg loada,loadb,loadc,loads,asel,bsel,vsel,clk,write;
wire[15:0]datapath_out;
wire Z_out;


datapath DUT(datapath_in,loada,loadb,loadc,loads,asel,bsel,vsel,ALUop,shift,datapath_out,Z_out,write,writenum,readnum,clk);



//MOV R0, #7     	 this means,take the absolute number 7 and store it in R0
//MOV R1, #2      	 this means,take the absolute number 2 and store it in R1
//ADD R2, R1,R0, LSL#1	 this means R2 = R1 + (R0 shifted left by 1) = 2+14=16

initial begin  //every 5-15-25 posedge clk
clk=1'b0;loada=1'b0;loadb=1'b1;
err=1'b0;  vsel=1'b1;  datapath_in=16'd7;
write=1'b1;shift=2'b01; writenum=3'b000; readnum=3'b000;#5;//we want to write to R0 
clk=1'b1; #5;  //should be written here data_out
clk=1'b0; #5;
clk=1'b1; #5; //should be written in inB and it is shifted!!!!!!!
if(datapath_tb.DUT.inB!==16'd7)begin $display("FAILED"); err=1'b1; $stop; end // writing to R0
else err=1'b0;


clk=1'b0;loada=1'b1;loadb=1'b0;
err=1'b0;  vsel=1'b1;  datapath_in=16'd2;
write=1'b1;shift=2'b01; writenum=3'b001; readnum=3'b001;#5;//we want to write to R0 
clk=1'b1; #5;  //should be written here data_out
clk=1'b0; #5;
clk=1'b1; #5; //should be written in inB and it is shifted!!!!!!!
if(datapath_tb.DUT.inA!==16'd2)begin $display("FAILED"); err=1'b1; $stop; end // writing to R0
else err=1'b0;

asel=1'b0; bsel=1'b0; ALUop=2'b00; loadc=1'b1; loads=1'b1;
clk=1'b0;#5;
clk=1'b1;#5;
if(datapath_out!==16'd16)begin $display("FAILED"); err=1'b1; $stop; end // writing to R0
else err=1'b0;


if(~err) $display("PASSED");
else $display("FAILED");
$stop;

end


endmodule 