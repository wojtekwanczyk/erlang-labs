%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. cze 2018 10:09
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-author("Wojtek").
-behaviour(gen_server).

%% API
-export([start/0, stop/0, init/1, terminate/2, handle_call/3, handle_cast/2,
  addStation/2, addValue/4, removeValue/3,
  getOneValue/3, getStationMean/2, getDailyMean/2,
  getMinMaxValue/3, crash/0]).

start() ->
  gen_server:start_link({local, pollution_gen_server},
    ?MODULE, [], []).

init(_) ->
  {ok, pollution:createMonitor()}.

stop() ->
  gen_server: cast(pollution_gen_server, stop).

handle_cast(stop, State) ->
  {stop, normal, State};

handle_cast(crash, State) ->
  1/0,
  {noreply, State}.

terminate(Reason, State) ->
  io:format("Server: exit with value ~p~n", [State]),
  Reason.

crash() -> gen_server: cast(pollution_gen_server, {crash}).





addStation(Name, {X, Y}) ->
  gen_server:call(pollution_gen_server, {addStation, Name, {X, Y}}).

addValue(NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type, Val) ->
  gen_server:call(pollution_gen_server, {addValue, NameOrCoords,
    {{Ye, M, D}, {H,Min,S}}, Type, Val}).

removeValue(NameOrCoodrs, Date, Type) ->
  gen_server:call(pollution_gen_server, {removeValue, NameOrCoodrs, Date, Type}).

getOneValue(Type, Date, NameOrCoords) ->
  gen_server:call(pollution_gen_server, {getOneValue, Type, Date, NameOrCoords}).

getStationMean(Type, NameOrCoords) ->
  gen_server:call(pollution_gen_server, {getStationMean, Type, NameOrCoords}).

getDailyMean(Type, {Ye, Mo, Day}) ->
  gen_server:call(pollution_gen_server, {getDailyMean, Type, {Ye, Mo, Day}}).

getMinMaxValue(Coords, Type, Date) ->
  gen_server:call(pollution_gen_server, {getMinMaxValue, Coords, Type, Date}).



handle_call({addStation, Name, {X, Y}}, _From, State) ->
  NewState = pollution:addStation(Name, {X,Y}, State),
  case NewState of
    {error, Msg} ->  {reply, Msg, State};
    _ ->   {reply, ok, NewState}
  end;

handle_call({addValue, NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type, Val}, _From, State) ->
  NewState = pollution:addValue(NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type, Val, State),
  case NewState of
    {error, Msg} ->  {reply, Msg, State};
    _ ->   {reply, ok, NewState}
  end;

handle_call({removeValue, NameOrCoodrs, Date, Type}, _From, State) ->
  NewState = pollution:removeValue(NameOrCoodrs, Date, Type, State),
  case NewState of
    {error, Msg} ->  {reply, Msg, State};
    _ ->   {reply, ok, NewState}
  end;



handle_call({getOneValue, Type, Date, NameOrCoords}, _From, State) ->
  NewState = pollution:getOneValue(Type, Date, NameOrCoords, State),
  case NewState of
    {error, Msg} ->  {reply, Msg, State};
    _ ->   {reply, ok, NewState}
  end;

handle_call({getStationMean, Type, NameOrCoords}, _From, State) ->
NewState = pollution:getStationMean(Type, NameOrCoords, State),
case NewState of
{error, Msg} ->  {reply, Msg, State};
_ ->   {reply, ok, NewState}
end;


handle_call({getDailyMean, Type, {Ye, Mo, Day}}, _From, State) ->
NewState = pollution:getDailyMean(Type, {Ye, Mo, Day}, State),
case NewState of
{error, Msg} ->  {reply, Msg, State};
_ ->   {reply, ok, NewState}
end;


handle_call({getMinMaxValue, Coords, Type, Date}, _From, State) ->
NewState = pollution:getMinMaxValue(Coords, Type, Date, State),
case NewState of
{error, Msg} ->  {reply, Msg, State};
_ ->   {reply, ok, NewState}
end.

