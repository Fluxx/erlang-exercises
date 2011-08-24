-module(ring).
-export([start/3, build/1, listen_and_forward_to/2]).

start(Size, Message, Count) ->
  LastPid = build(Size - 1),
  LastPid ! {Message, Count},
  listen_and_forward_to(LastPid, true).

build(Size) ->
  Builder = fun(_Num, Pid) -> spawn(ring, listen_and_forward_to, [Pid, false]) end,
  lists:foldl(Builder, self(), lists:seq(1, Size)).

listen_and_forward_to(Pid, Last) ->
  receive
    {Message, 1} ->
      Pid ! {Message, 1},
      io:format("Process ~p received ~p (1), forwarding to ~p~n", [self(), Message, Pid]);
    {Message, Count} ->
      io:format("Process ~p received ~p (~p), forwarding to ~p~n", [self(), Message, Count, Pid]),
      case Last of
        true -> Pid ! {Message, Count - 1};
        false -> Pid ! {Message, Count}
      end,
      listen_and_forward_to(Pid, Last)
  end.