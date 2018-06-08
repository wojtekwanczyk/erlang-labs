%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. maj 2018 11:57
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-author("Wojtek").
-behaviour(supervisor).

%% API
-export([start/0, stop/0, addStation/2, crash/0, init/1, handle_call/3]).

crash() ->
  pollution_server:crash().

start() ->
  gen_server:start_link({local, pollution_gen_server}, pollution_gen_server, [], []).

init(_) ->
  {ok, pollution:createMonitor()}.

stop() ->
  pollution_server:stop().

addStation(Name, {X, Y}) ->
  gen_server:call(pollution_gen_server, {Name, {X,Y}, addStation}).

handle_call({Name, Coords, addStation}, _From, Monitor) ->
  {reply, ok, pollution:addStation(Name, Coords, Monitor)}.


% skopiowac supervisor i pozmieniac nazwy modulow
% przetestuj czy supervisor zabija wszystko pod soba
% czyli 1/0 w konsoli