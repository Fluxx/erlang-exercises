-module(star).
-export([start/3, listen_for_response/0, listen_and_respond_to/1]).

start(Number, Message, Count) ->
  Centroid = spawn(star, listen_for_response, []),
  io:format("Centroid spawned with PID ~p~n", [Centroid]),
  Points = spawn_points(Number, Centroid),
  lists:foreach(fun (N) -> send({Message, N}, Points) end, lists:reverse(lists:seq(0, Count-1))).

send(Message, Pids) -> lists:foreach(fun (Pid) -> Pid ! Message end, Pids).

spawn_points(Number, Centroid) ->
  Spawner = fun(_N) -> spawn(star, listen_and_respond_to, [Centroid]) end,
  lists:map(Spawner, lists:seq(1, Number)).

listen_for_response() ->
  receive
    {Message, Remainder} ->
      io:format("Centroid received ~p (~p)~n", [Message, Remainder]),
      listen_for_response()
  end.

listen_and_respond_to(Pid) ->
  receive
    {Message, 0} ->
      io:format("Process ~p received ~p (0) forwarding back to ~p~n", [self(), Message, Pid]),
      Pid ! {Message, 0};
    {Message, Remainder} ->
      io:format("Process ~p received ~p (~p) forwarding back to ~p~n", [self(), Message, Remainder, Pid]),
      Pid ! {Message, Remainder},
      listen_and_respond_to(Pid)
  end.