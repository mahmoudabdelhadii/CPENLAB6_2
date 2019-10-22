module datapath(datapath_in,loada,loadb,loadc,loads,asel,bsel,vsel,ALUop,shift,datapath_out,Z_out,write,writenum,readnum,clk);
input [15:0]datapath_in;
input[2:0]readnum,writenum;
input[1:0]ALUop,shift;
input loada,loadb,loadc,loads,asel,bsel,write,clk,vsel;

output[15:0] datapath_out;
output Z_out;  //zero negative overflow

//LET's WRITE WIRE BUSSES
wire[15:0]data_in;
wire[15:0]data_out,inA,inB,sout,Ain,Bin,out;
wire Z;

//INSTANTIATIONS
assign data_in=vsel?{8'b0,datapath_in}:datapath_out;

REGFILE REGFILE(data_in,writenum,write,readnum,clk,data_out); //REGISTER FILE
vDFFE #(16) A(clk,loada,data_out,inA); //D-FLIP FLOP for A
vDFFE #(16) B(clk,loadb,data_out,inB); //D-FLIP  FLOP for B
assign Ain=asel?16'b0:inA; //MUX FOR Ain
shifter U1(inB,shift,sout); //Shift for inB?
assign Bin=bsel?{11'b0,datapath_in[4:0]}:sout; //MUX FOR Bin
ALU U2(Ain,Bin,ALUop,out,Z);
vDFFE #(16) C(clk,loadc,out,datapath_out);
vDFFE #(1)status(clk,loads,Z,Z_out);

endmodule 