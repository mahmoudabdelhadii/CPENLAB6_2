module ALU(Ain,Bin,ALUop,out,ZNO); 
input [15:0] Ain, Bin;
input [1:0] ALUop;
output reg[15:0] out;
output reg[2:0] ZNO; //zero negative overflow
wire sub,ovf;
wire [15:0] sum;


assign sub= (ALUop==2'b01)?1'b1:1'b0;

AddSub v(Ain,Bin,sub,sum,ovf);
always@(*)begin
 case(ALUop)
2'b00:out=Ain+Bin;
2'b01:out=Ain-Bin;
2'b10:out=Ain&Bin;
2'b11:out=~Bin;

 endcase
 ZNO[2] = ((out == 16'b0000000000000000)?  1'b1: 1'b0);
 ZNO[1] = ((out[15] == 1'b1) ? 1'b1: 1'b0);
case(ALUop) 
2'b10: ZNO[0] =1'b0;
2'b11: ZNO[0] = 1'b0;
2'b00: ZNO[0] =ovf;
2'b01: ZNO[0] =ovf;
default: ZNO[0] = 1'bx;
endcase

end


endmodule

module AddSub(a,b,sub,s,ovf) ;
  parameter n = 16 ;
  input [n-1:0] a, b ;
  input sub ;           // subtract if sub=1, otherwise add
  output [n-1:0] s ;
  output ovf ;          // 1 if overflow
  wire c1, c2 ;         // carry out of last two bits
  wire ovf = c1 ^ c2 ;  // overflow if signs don't match

  // add non sign bits
  Adder1 #(n-1) ai(a[n-2:0],b[n-2:0]^{n-1{sub}},sub,c1,s[n-2:0]) ;
  // add sign bits
  Adder1 #(1)   as(a[n-1],b[n-1]^sub,c1,c2,s[n-1]) ;
endmodule

module Adder1(a,b,cin,cout,s) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input cin ;
  output [n-1:0] s ;
  output cout ;
  wire [n-1:0] s;
  wire cout ;

  assign {cout, s} = a + b + cin ;
endmodule 



/*case(ALUop) 
2'b10: ZNO[0] =1'b0;
2'b11: ZNO[0] = 1'b0;
2'b00: ZNO[0] =ovf;
2'b01: ZNO[0] =ovf;
default: ZNO[0] = 1'bx;
endcase
*/


/*if(ALUop == 2'b10|2'b11) begin
 assign ZNO[0]= 1'b0;
end
 else 
 assign ZNO[0] = ~((Bin[15]^sub)^Ain[15]) & (Ain[15]^out[15]);
*/



