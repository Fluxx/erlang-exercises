-module(star).
-export([start/1, listen/1]).

start(Number) ->
  Spawner = fun(_N) -> spawn(star, listen, [self()]) end,
  Pids = lists:map(Spawner, lists:seq(1, Number)),
  lists:foreach(fun (Pid) -> Pid ! "Hello World" end, Pids).
  
listen(Centroid) ->
  receive
    Message ->
      io:format("Process ~p received ~p forwarding back to ~p~n", [self(), Message, Centroid]),
      Centroid ! Message
  end.