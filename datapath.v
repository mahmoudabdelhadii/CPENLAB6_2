module datapath(sximm8,loada,loadb,loadc,loads,asel,bsel,vsel,ALUop,shift,sximm5,PC,mdata,datapath_out,Z_out,write,writenum,readnum,clk);

input[2:0]readnum,writenum;
input[1:0]ALUop,shift;
input loada,loadb,loadc,loads,asel,bsel,write,clk;
input [3:0]vsel;
input [15:0] sximm5, sximm8, mdata;
input [7:0] PC;

output[15:0] datapath_out;
output [2:0] Z_out;  //zero negative overflow

//LET's WRITE WIRE BUSSES
wire[15:0]data_in;
wire[15:0]data_out,inA,inB,sout,Ain,Bin,out;
wire [2:0] ZNO;

//INSTANTIATIONS
//assign data_in=vsel?{8'b0,datapath_in}:datapath_out;
/*always@(*) begin
    case(vsel)
		4'b0001: data_in= mdata;
		4'b0010: data_in = sximm8; 
		4'b0100: data_in= {8'b0,PC};
		4'b1000: data_in= datapath_out;
		default:16'bxxxxxxxxxxxxxxxx;
end*/
assign data_in = ((vsel== 4'b0001)? mdata: (vsel== 4'b0010)? sximm8: (vsel==4'b0100)?{8'b0,PC}: (vsel== 4'b1000)? datapath_out:16'bxxxxxxxxxxxxxxxx);

REGFILE REGFILE(data_in,writenum,write,readnum,clk,data_out); //REGISTER FILE
vDFFE #(16) A(clk,loada,data_out,inA); //D-FLIP FLOP for A
vDFFE #(16) B(clk,loadb,data_out,inB); //D-FLIP  FLOP for B
assign Ain=asel?16'b0:inA; //MUX FOR Ain
shifter U1(inB,shift,sout); //Shift for inB?
assign Bin=(bsel==1)?sximm5:sout; //MUX FOR Bin
ALU U2(Ain,Bin,ALUop,out,ZNO);
vDFFE #(16) C(clk,loadc,out,datapath_out);
vDFFE #(3) status(clk,loads,ZNO,Z_out);

endmodule 