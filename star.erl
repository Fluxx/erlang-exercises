-module(star).
-export([start/1, listen_for_response/0, listen_and_respond_to/1]).

start(Number) ->
  Centroid = spawn(star, listen_for_response, []),
  Points = spawn_points(Number, Centroid),
  lists:foreach(fun (Pid) -> Pid ! "Hello World" end, Points).

spawn_points(Number, Centroid) ->
  Spawner = fun(_N) -> spawn(star, listen_and_respond_to, [Centroid]) end,
  lists:map(Spawner, lists:seq(1, Number)).

listen_for_response() ->
  receive
    Message ->
      io:format("Centroid received ~p~n", [Message]),
      listen_for_response()
  end.
  
listen_and_respond_to(Centroid) ->
  receive
    Message ->
      io:format("Process ~p received ~p forwarding back to ~p~n", [self(), Message, Centroid]),
      Centroid ! Message
  end.