-module(ring).
-export([start/2, build/1, listen_and_forward_to/1]).

start(Size, Message) ->
  LastPid = build(Size - 1),
  LastPid ! Message,
  listen_and_forward_to(LastPid).

build(Size) ->
  Builder = fun(_Num, Pid) -> spawn(ring, listen_and_forward_to, [Pid]) end,
  lists:foldl(Builder, self(), lists:seq(1, Size)).

listen_and_forward_to(Pid) ->
  io:format("Process ~p forwarding to ~p~n", [self(), Pid]),
  receive
    Message ->
      io:format("Process ~p received ~p, forwarding to ~p~n", [self(), Message, Pid]),
      Pid ! Message
  end.