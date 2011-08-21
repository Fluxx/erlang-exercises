-module(my_lists).
-compile(export_all).

min([H | T]) ->
  min(H, T);

min(A, []) ->
  A;
  
min(A, [H | T]) when A < H ->
  min(A, T);
  
min(_A, [H | T]) ->
  min(H, T).
