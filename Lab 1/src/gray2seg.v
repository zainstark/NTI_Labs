module gray2seg (
		input [3:0] Gray,
		output a,b,c,d,e,f,g
);

	wire [3:0] B;
	gray2bin GBD(
		.G(Gray),
		.B(B)
	);

	bin2seg BSD(
		.B(B),
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.e(e),
		.f(f)
	);

	endmodule


