-module (ping).
-export ([start/0, listen/0]).

ping(Listener, 0) ->
  Listener ! finished,
  io:format("Sending finished to the listener~n", []);
ping(Listener, Number) ->
  Listener ! {ping, self()},
  receive
    pong ->
      io:format("Pinger received its pong~n", [])
  end,
  ping(Listener, Number - 1).

listen() ->
  receive
    finished ->
      io:format("Listener is finished. Goodbye!~n", []);
    {ping, From} ->
      io:format("Listener received ping!~n", []),
      From ! pong,
      listen()
  end.

start() ->
  Listener = spawn(concurrency, listen, []),
  ping(Listener, 5).