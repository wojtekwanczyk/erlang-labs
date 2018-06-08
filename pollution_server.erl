%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. maj 2018 12:30
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("Wojtek").

%% API
-export([start/0, stop/0, init/0,
  addStation/2, addValue/4, removeValue/3,
  getOneValue/3, getStationMean/2, getDailyMean/2,
  getMinMaxValue/3, crash/0]).


start() ->
  register(server, spawn(?MODULE, init, [])).

init() ->
  Monitor = pollution:createMonitor(),
  io:format("Server is working now ~n"),
  loop(Monitor).


stop() ->
  server ! {req, self(), stop},
  io:format("Server stopped ~n").

loop(Monitor) ->
%  io:format("Loop waiting ~n"),
  receive
    crash -> 1/0;

    {req, Pid, {addStation, Name, {X,Y}}} ->
      P = pollution:addStation(Name, {X,Y}, Monitor),
      case P of
        {error, Msg} -> Pid ! {res, Msg}, loop(Monitor);
        _ -> Pid ! {res, P}, loop(P)
      end;

    {req, Pid, {addValue, NameOrCoords, Date, Type, Val}} ->
      P = pollution:addValue(NameOrCoords, Date, Type, Val, Monitor),
      case P of
        {error, Msg} -> Pid ! {res, Msg}, loop(Monitor);
        _ -> Pid ! {res, P}, loop(P)
      end;

    {req, Pid, {removeValue, NameOrCoords, Date, Type}} ->
      P = pollution:removeValue(NameOrCoords, Date, Type, Monitor),
      case P of
        {error, Msg} -> Pid ! {res, Msg}, loop(Monitor);
        _ -> Pid ! {res, P}, loop(P)
      end;

    {req, Pid, {getOneValue, Type, Date, NameOrCoords}} ->
      P = pollution:getOneValue(Type, Date, NameOrCoords, Monitor),
      case P of
        {error, Msg} -> Pid ! {res, Msg}, loop(Monitor);
        _ -> Pid ! {res, P}, loop(Monitor)
      end;

    {req, Pid, {getStationMean, Type, NameOrCoords}} ->
      P = pollution:getStationMean(Type, NameOrCoords, Monitor),
      case P of
        {error, Msg} -> Pid ! {res, Msg}, loop(Monitor);
        _ -> Pid ! {res, P}, loop(Monitor)
      end;

    {req, Pid, {getDailyMean, Type, Date}} ->
      P = pollution:getDailyMean(Type, Date, Monitor),
      case P of
        {error, Msg} -> Pid ! {res, Msg}, loop(Monitor);
        _ -> Pid ! {res, P}, loop(Monitor)
      end;

    {req, Pid, {getMinMaxValue, Coords, Type, Date}} ->
      P = pollution:getMinMaxValue(Coords, Type, Date, Monitor),
      case P of
        {error, Msg} -> Pid ! {res, Msg}, loop(Monitor);
        _ -> Pid ! {res, P}, loop(Monitor)
      end;

    {req, _, stop} ->
      ok;

    _ -> io:format("Server cannot understand request!~n"), loop(Monitor)
  end.




call(Message) ->
  server ! {req, self(), Message},
  receive
    {res, Mes} -> Mes;
    _ -> io:format("Something went wrong!~n")
  after
    5000 -> io:format("Timout(5s) - server didn't respond~n")
  end.

addStation(Name, {X,Y}) ->
  call({addStation, Name, {X,Y}}).

addValue(NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type, Val) ->
  call({addValue, NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type, Val}).

removeValue(NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type) ->
  call({removeValue, NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type}).

%getOneValue(Type, {{Ye, M, D}, {H,Min,S}}, NameOrCoords) ->
%  call({getOneValue, Type, {{Ye, M, D}, {H,Min,S}}, NameOrCoords}).
%
%getStationMean(Type, NameOrCoords) ->
%  call({getStationMean, Type, NameOrCoords}).
%
%getDailyMean(Type, {{Ye, M, D}, {H,Min,S}}) ->
%  call({getDailyMean, Type, {{Ye, M, D}, {H,Min,S}}}).
%
%getMinMaxValue(Coords, Type, {{Ye, M, D}, {H,Min,S}}) ->
%  call({getMinMaxValue, Coords, Type, {{Ye, M, D}, {H,Min,S}}}).


getOneValue(Type, {{Ye, M, D}, {H,Min,S}}, NameOrCoords) ->
  server ! {req, self(), {getOneValue, Type, {{Ye, M, D}, {H,Min,S}}, NameOrCoords}},
  receive
    {res, Data} -> Data;
    _ -> io:format("Wrong data received~n")
  after
    5000 -> io:format("No data received(5s)~n")
  end.

getStationMean(Type, NameOrCoords) ->
  server ! {req, self(), {getStationMean, Type, NameOrCoords}},
  receive
    {res, Data} -> Data;
    _ -> io:format("Wrong data received~n")
  after
    5000 -> io:format("No data received(5s)~n")
  end.

getDailyMean(Type, {Ye, M, D}) ->
  server ! {req, self(), {getDailyMean, Type, {Ye, M, D}}},
  receive
    {res, Data} -> Data;
    _ -> io:format("Wrong data received~n")
  after
    5000 -> io:format("No data received(5s)~n")
  end.

getMinMaxValue(Coords, Type, {Ye, M, D}) ->
  server ! {req, self(), {getMinMaxValue, Coords, Type, {Ye, M, D}}},
  receive
    {res, Data} -> Data;
    _ -> io:format("Wrong data received~n")
  after
    5000 -> io:format("No data received(5s)~n")
  end.

crash() ->
  server ! crash.