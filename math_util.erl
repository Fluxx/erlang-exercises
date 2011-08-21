-module (math_util).
-compile(export_all).

perimter({square, Side}) -> Side * 4;
perimter({circle, Radius}) -> math:pi() * math:pow(Radius, 2);
perimter({triangle, A, B, C}) -> A + B + C.