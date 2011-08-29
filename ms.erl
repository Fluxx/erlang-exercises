-module (ms).
-export ([start/1, spawn_slaves/1, master/1, slave/1, to_slave/2]).

start(N) ->
  register(master, spawn(ms, spawn_slaves, [N])).

to_slave(Message, N) ->
  master ! {Message, N}.

spawn_slaves(N) ->
  process_flag(trap_exit, true),
  master(lists:map(fun spawn_slave/1, lists:seq(1, N))).

spawn_slave(N) ->
  {N, spawn_link(ms, slave, [N])}.

slave_pid(N, Slaves) ->
  erlang:element(2, lists:keyfind(N, 1, Slaves)).

replace_pid({N, NewPid}, Slaves) ->
  lists:keyreplace(N, 1, Slaves, {N, NewPid}).

master(Slaves) ->
  receive
    {'EXIT', _FromPid, {N, die} } ->
      master(replace_pid(spawn_slave(N), Slaves));
    {Message, N} ->
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
