module InsDEC_tb();
wire [15:0] sximm5,sximm8;
wire [2:0] readnum, writenum,opcode;
wire [1:0] ALUop, shift,op;
reg [15:0] in;
reg [2:0] nsel;
