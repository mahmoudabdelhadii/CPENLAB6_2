module cpu(clk,reset,s,load,in,out,N,V,Z,w);
  input clk,reset,s,load;
  input [15:0] in;
  output wire [15:0] out;
  output N,V,Z,w;

wire[15:0] instregout;
wire [2:0] opcode,readnum,writenum;
wire [1:0] op,shift,ALUop;
wire[15:0] sximm5,sximm8,mdata;
wire [7:0] PC;
wire loada,loadb,loadc,loads,asel,bsel,write;
wire[2:0] nsel;
wire[3:0] vsel;



assign PC=8'b00000000;
assign mdata = 16'b0000000000000000;
vDFFE #(16) U0(clk,load,in,instregout);
InsDEC U1(.opcode(opcode),.op(op),.ALUop(ALUop),.sximm5(sximm5),.sximm8(sximm8),.shift(shift), .readnum(readnum),.writenum(writenum),/*FSM*/.nsel(nsel),.in(instregout));
datapath DP(.sximm8(sximm8),/*FSM*/.loada(loada),/*FSM*/.loadb(loadb),/*FSM*/.loadc(loadc),/*FSM*/.loads(loads),/*FSM*/.asel(asel),/*FSM*/.bsel(bsel),/*FSM*/.vsel(vsel),.ALUop(ALUop),.shift(shift),.sximm5(sximm5),.PC(PC),.mdata(mdata), .datapath_out(out),.Z_out({Z,N,V})/*[2](Z),.Z_out[1](N),.Z_out[0](V)*/,/*FSM*/.write(write),.writenum(writenum),.readnum(readnum),.clk(clk));


//fsm
`define SW 4
`define Wait 4'b0000
`define Decode 4'b0001

`define mov1 4'b0011
`define mov2 4'b0100
`define Writelmm 4'b0101

`define GetA 4'b0111
`define GetB 4'b1000
`define ADD 4'b1001
`define AND 4'b1010
`define MVN1 4'b1011
`define MVN2 4'b1100
`define CMP1 4'b1101
`define CMP2 4'b1110

wire [`SW-1:0] present_state, state_next_reset, state_next; // From Slide Set 7
 reg [18:0] next;
  
  // state DFF for control FSM for exponent circuit
  vDFF #(`SW) STATE(clk,state_next_reset,present_state);
  // reset mux for control FSM for exponent circuit
  assign state_next_reset = reset ? `Wait : state_next;
  // combinational logic for control FSM for exponent circuit
  always @(posedge clk) begin
    casex ( {opcode, op, ALUop, s, reset, present_state} ) //What state changes depend upon
      {3'bxxx,2'bxx,2'bxx,1'b0,1'b0,`Wait}: next = {`Wait, 1'b1, 7'b0000000,4'bx,3'bx}; // Wait -> Wait if s=0 and reset = 0: output: w = 1;
      {3'bxxx,2'bxx,2'bxx,1'b1,1'b0,`Wait}: next = {`Decode,1'b0, 7'b0000000,4'bx,3'bx}; // Wait -> Decode if s=1 and reset =0: output: w = 0;
        {3'b110,2'b00,2'bxx,1'bx,1'b0,`Decode}: next = {`mov2,1'b0,/**/1'bx,1'b1,1'bx,1'bx,1'b1,1'b0,1'bx,4'bx, 3'bx}; //Decode -> mov2 if opcode = 110 and op = 00: output: nsel =001 loadb =1 bsel =0 asel= 1
            {3'b110,2'b00,2'bxx,1'bx,1'b0,`mov2}: next = {`Writelmm,1'b0,/**/1'bx,1'bx,1'bx,1'b1,1'bx,1'bx,1'b1,4'b1000,3'b010}; //mov2 -> Writelmm: output: loadc =1 vsel = 1000 nsel = 010 write =1
            {3'b110,2'b00,2'bxx,1'bx,1'b0,`Writelmm}: next ={`Wait,1'b1,/**/1'bx,1'bx,1'bx,1'bx,1'bx,1'bx,1'bx,4'bx,3'bx}; //Writelmm-> Wait
        {3'b110,2'b10,2'bxx,1'bx,1'b0,`Decode}: next = {`mov1,1'b0,/**/1'bx,1'bx,1'b1,1'bx,1'bx,1'bx,1'b1/*7'bxxxxxx1*/,4'b0010,3'b100}; //Decode -> mov1 if op = 10: output: vsel = 0010 nsel = 100 write = 1
        {3'b101,2'bxx,2'bx0,1'bx,1'b0,`Decode}: next ={`GetA,1'b0, 7'b1xxxxxx,4'bx,3'b001};//Decode-> GetA if opcode = 101 and ALUop = x0: output: nsel =001, loada=1
            {3'b101,2'bxx,2'bx0,1'bx,1'b0,`GetA}: next ={`GetB,1'b0,7'bx1xxxxx,4'bx,3'b010}; //GetA-> GetB: output: nsel = 010 loadb =1
                {3'b101,2'bxx,2'b00,1'bx,1'b0,`GetB}: next = {`ADD,1'b0,7'bxx1x001,4'b1000,3'b010};//GetB-> ADD if ALUop = 00: output: asel=bsel = 0, aluop=00, loadc =1 write =1 nsel = 010 vsel = 1000
                  {3'b101,2'bxx,2'b00,1'bx,1'b0,`ADD}: next ={`Wait,1'b1,7'bx,4'bx,3'bx}; //ADD-> Wait
                {3'b101,2'bxx,2'b10,1'bx,1'b0,`GetB}: next = {`AND,1'b0,7'bxx1x001,4'b1000,3'b010}; //GetB -> AND if ALUop = 10" output: asel=bsel = 0, aluop = 10, loadc =1, write =1, nsel = 010, vsel = 1000
                  {3'b101,2'bxx,2'b10,1'bx,1'b0,`AND}: next ={`Wait,1'b1,7'bx,4'bx,3'bx}; //AND-> Wait
            {3'b101,2'bxx,2'b11,1'bx,1'b0,`Decode}: next ={`MVN1,1'b0,7'bx1xxxxx,4'bx,3'b001};//Decode -> MVN1 if ALUop = 11: output: nsel = 001, loadb = 1 
                {3'b101,2'bxx,2'b11,1'bx,1'b0,`MVN1}: next ={`MVN2,1'b0,7'bxx1xx0x,4'bx,3'b010};//MVN1 -> MVN2: output: bsel = 0, aluop = 11, loadc =1, nsel = 010
                  {3'b101,2'bxx,2'b11,1'bx,1'b0,`MVN2}: next ={`Wait,1'b1,7'bx,4'bx,3'bx}; //MVN2-> Wait
            {3'b101,2'bxx,2'b01,1'bx,1'b0,`Decode}: next ={`CMP1,1'b0,7'bx1xxx0x,4'bx,3'b001};//Decode -> CMP1 if ALUop = 01: output: loadb = 1, nsel = 001, bsel = 0 
                {3'b101,2'bxx,2'b01,1'bx,1'b0,`CMP1}: next ={`CMP2,1'b0,7'b1xx10xx,4'bx,3'b100}; //CMP1->CMP2: output: loada =1, asel=0,aluop=01,loads=1,nsel=100
                  {3'b101,2'bxx,2'b01,1'bx,1'b0,`CMP2}: next ={`Wait,1'b1,7'bx,4'bx,3'bx}; //CMP2-> Wait
      
      default:  next = {18'bx}; //default outputs
    endcase
   end
  // copy to module output
 assign {state_next,w, loada, loadb, loadc, loads, asel, bsel, write, vsel, nsel}=next;

/*always(posedge clk)begin
if(reset==1'b1)
current_state=12'b0;
casex({opcode,op,reset,s,current_state})begin
*/

endmodule
