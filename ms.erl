-module (ms).
-export ([start/1, spawn_slaves/1, master/1, slave/1, to_slave/2]).

start(N) ->
  MasterPid = spawn(ms, spawn_slaves, [N]),
  register(master, MasterPid).

spawn_slaves(N) ->
  Slaves = lists:map(fun(X) -> {X, spawn(ms, slave, [X])} end, lists:seq(1, N)),
  master(Slaves).

to_slave(Message, N) -> master ! {Message, N}.

slave_pid(N, Slaves) ->
  {_N, Pid} = lists:keyfind(N, 1, Slaves),
  Pid.

master(Slaves) ->
  receive
    {Message, N} ->
      io:format("Sending ~p to slave ~p~n", [Message, N]),
      slave_pid(N, Slaves) ! Message
  end.

slave(N) ->
  receive
    Message ->
      io:format("Process ~p received ~p~n", [self(), Message]),
      slave(N)
  end.
