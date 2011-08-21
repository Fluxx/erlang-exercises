% Converts temperatures to and from F and C

-module(temperature).
-compile(export_all).

f2c(F) -> (F - 32) * (5/9).
c2f(C) -> C * (9/5) + 32.

convert({c, C}) -> c2f(C);
convert({f, F}) -> f2c(F).