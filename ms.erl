-module (ms).
-export ([start/1, spawn_slaves/1, master/1, slave/1, to_slave/2]).

start(N) -> register(master, spawn(ms, spawn_slaves, [N])).

to_slave(Message, N) -> master ! {Message, N}.

spawn_slaves(N) ->
  process_flag(trap_exit, true),
  Builder = fun(X) -> {X, spawn_link(ms, slave, [X])} end,
  master(lists:map(Builder, lists:seq(1, N))).

slave_pid(N, Slaves) ->
  {_N, Pid} = lists:keyfind(N, 1, Slaves),
  Pid.

replace_pid(N, NewPid, Slaves) ->
  lists:keyreplace(N, 1, Slaves, {N, NewPid}).

master(Slaves) ->
  receive
    {'EXIT', _FromPid, {N, die} } ->
      io:format("Process ~p died. Spawning a new one...~n", [N]),
      ReplacementPid = spawn_link(ms, slave, [N]),
      io:format("Replacement PID ~p spawned~n", [ReplacementPid]),
      master(replace_pid(N, ReplacementPid, Slaves));
    {Message, N} ->
      io:format("Sending ~p to slave ~p~n", [Message, N]),
      slave_pid(N, Slaves) ! Message,
      master(Slaves)
  end.

slave(N) ->
  receive
    die ->
      exit({N, die});
    Message ->
      io:format("Process ~p received ~p~n", [self(), Message]),
      slave(N)
  end.
