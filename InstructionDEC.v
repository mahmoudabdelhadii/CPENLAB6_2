module InsDEC(opcode,op,ALUop,sximm5,sximm8,shift, readnum,writenum,nsel,in);
output [15:0] sximm5,sximm8;
output [2:0] readnum, writenum,opcode;
output [1:0] ALUop, shift,op;
input [15:0] in;
input [2:0] nsel;
wire[2:0] Rn,Rd,Rm,mux_out;

assign Rn = in[10:8];
assign Rd = in[7:5];
assign Rm = in[2:0];
assign ALUop= in[12:11];
assign sximm5 = {{11{in[4]}},in[4:0]};
assign sximm8 = {{8{in[7]}},in[7:0]};
assign shift = in[4:3];
assign mux_out = ((nsel== 3'b001)? Rm: (nsel== 3'b010)? Rd: (nsel== 3'b100)? Rn: 3'bxxx);
assign readnum= mux_out;
assign writenum = mux_out;
assign opcode = in[15:13];
assign op = in[12:11];

endmodule


