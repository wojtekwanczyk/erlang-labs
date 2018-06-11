%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. maj 2018 11:57
%%%-------------------------------------------------------------------
-module(pollution_gen_server_supervisor).
-author("Wojtek").
-behaviour(supervisor).

%% API
-export([start_link/0, init/1]).


start_link() ->
  supervisor:start_link({local, sup},
    ?MODULE, []).


init(_) ->
  {ok, {
    {one_for_all, 2, 3},
    [ {pollution_gen_server,
      {pollution_gen_server, start, []},
      permanent, brutal_kill, worker, [pollution_gen_server]}
    ]}
  }.


%addStation(Name, {X, Y}) ->
%  gen_server:call(pollution_gen_server, {Name, {X,Y}, addStation}).

%handle_call({Name, Coords, addStation}, _From, Monitor) ->
%  {reply, ok, pollution:addStation(Name, Coords, Monitor)}.


% skopiowac supervisor i pozmieniac nazwy modulow
% przetestuj czy supervisor zabija wszystko pod soba
% czyli 1/0 w konsoli