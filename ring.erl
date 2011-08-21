-module (ring).
-export ([build/1, listen_and_forward_to/1]).

% Initial start to building a ring. Takes in a ring size and spawns the first process.
build(Size) ->
  spawn(fun() -> build(Size - 1, self()) end).
  
% The last listening process.  It listens and forwards requests to the starting pid.
build(0, StartingPid) ->
  io:format("Spawning last listener~n", []),
  listen_and_forward_to(StartingPid);
% Builds a successor process that it will forward requests to, and then sets itslef up
% to listen for work.
build(Size, StartingPid) ->
  io:format("Spawning successor for ~p~n", [Size]),
  Successor = spawn(fun() -> build(Size - 1, StartingPid) end),
  listen_and_forward_to(Successor).
  
listen_and_forward_to(Pid) ->
  receive
    Message ->
      io:format("Received ~p~n", [Message]),
      Pid ! Message
  end.