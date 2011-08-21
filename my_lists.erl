-module(my_lists).
-compile(export_all).

min([H | T]) ->
  min(H, T).

min(A, []) ->
  A;
min(A, [H | T]) when A < H ->
  min(A, T);
min(_A, [H | T]) ->
  min(H, T).

max([H | T]) ->
  max(H, T).

max(A, []) ->
  A;
max(A, [H | T]) when A > H ->
  max(A, T);
max(_A, [H | T]) ->
  max(H, T).

min_max(List) ->
  {min(List), max(List)}.