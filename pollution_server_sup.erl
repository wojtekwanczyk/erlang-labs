%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. maj 2018 11:40
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("Wojtek").

%% API
-export([start_link/0, init/0]).


start_link() ->
  spawn(?MODULE, init, []).

init() ->
  process_flag(trap_exit, true),
  pollution_server:start(),
  receive
    {'EXIT', _, _} ->
      start_link()
  end.


