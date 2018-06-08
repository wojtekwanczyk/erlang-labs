%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. kwi 2018 11:26
%%%-------------------------------------------------------------------
-module(lab3).
-author("Wojtek").

%% API
-export([start/0, play/1, stop/0, ping_loop/0, pong_loop/0]).


start() ->
  register(ping, spawn(?MODULE, ping_loop, [])),
  register(pong, spawn(?MODULE, pong_loop, [])).


play(N) ->
  ping ! N.

stop() ->
  ping ! endp,
  pong ! endp.


ping_loop() ->
  receive
    0 ->
      ping_loop();
    N ->
      timer:sleep(1000),
      case N of
        endp ->
          ok;
        _ ->
          io:format("Ping odbija!~n"),
          pong ! N-1,
          ping_loop()
      end
  after
    20000 -> ok
  end.


pong_loop() ->
  receive
    0 ->
      pong_loop();
    N ->
      timer:sleep(1000),
      case N of
        endp ->
          ok;
        _ ->
          io:format("Pong odbija!~n"),
          ping ! N-1,
          pong_loop()
      end
  after
    20000 -> ok
  end.