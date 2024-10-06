module Add4(
    input [3:0]        a,
    input [3:0]        b,
    input              cin,
    output             cout,
    output [3:0]       c
);
    wire [3:0] p;
    wire [3:0] g;

    assign p = a ^ b;
    assign g = a & b;
    
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);

endmodule

module Add16(
    input [15:0]       a,
    input [15:0]       b,
    input              cin,
    output             cout,
    output [15:0]      c
);

    Add4 a0(
       .a(a[3:0]),
       .b(b[3:0]),
       .cin(cin),
       .cout(c[4]),
       .c(c[3:0])
   );
    Add4 a1(
         .a(a[7:4]),
         .b(b[7:4]),
         .cin(a0.cout),
         .cout(c[8]),
         .c(c[7:4])
    );
    Add4 a2(
         .a(a[11:8]),
         .b(b[11:8]),
         .cin(a1.cout),
         .cout(c[12]),
         .c(c[11:8])
    );
    Add4 a3(
         .a(a[15:12]),
         .b(b[15:12]),
         .cin(a2.cout),
         .cout(cout),
         .c(c[15:12])
    );

endmodule

module Add(
    input       [31:0]          a,
    input       [31:0]          b,
    output reg  [31:0]          sum
);

    wire [31:0] c;
    wire useless;

    assign c[0] = 1'b0;

    Add16 a0(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .cout(c[16]),
        .c(c[15:0])
    );

    Add16 a1(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(a0.cout),
        .cout(useless),
        .c(c[31:16])
    );

    always @(*) begin
        sum = a ^ b ^ c;
    end
    
endmodule
