%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. kwi 2018 13:46
%%%-------------------------------------------------------------------
-module(pollution).
-author("Wojtek").

%% API
-export([createMonitor/0, addStation/3, addValue/5, stationExists/2, getMinMaxValue/4,
  removeValue/4, getOneValue/4, getStationMean/3, getDailyMean/3, initPol/0]).

-record(measurement, {date, type, value}).

-record(station, {name, coords}).



createMonitor() -> #{}.

addStation(Name, {X, Y}, P) ->
  case stationExists(Name, maps:keys(P)) of
    false ->
      case stationExists({X, Y}, maps:keys(P)) of
        false -> P#{#station{name = Name, coords = {X, Y}} => []};
        _     -> {error, "Station already exists"}
      end;
    _     -> {error, "Station already exists"}
  end.




addValue(NameOrCoords, {{Ye, M, D}, {H,Min,S}}, Type, Val, P) ->
  NewDate = {{Ye, M, D}, {H,Min,S}},
  case stationExists(NameOrCoords, maps:keys(P)) of
    false -> {error, "Station does not exists"};
    Station ->
      case lists:any(fun(#measurement{type = T, date = Date}) -> T =:= Type andalso Date =:= NewDate end, maps:get(Station,P)) of
        true -> {error, "Measurement already exists"};
        _    -> P#{Station := [#measurement{date = NewDate, type = Type, value = Val} | maps:get(Station, P)]}
      end
  end.


removeValue(NameOrCoodrs, Date, Type, P) ->
  case stationExists(NameOrCoodrs, maps:keys(P)) of
    false -> {error, "Station does not exists"};
    Station ->
      Mes = lists:filter(fun(#measurement{date = D, type = T}) -> D =/= Date orelse T =/= Type end, maps:get(Station, P)),
      P#{Station := Mes}
  end.

getOneValue(Type, Date, NameOrCoords, P) ->
  case stationExists(NameOrCoords, maps:keys(P)) of
    false -> {error, "Station does not exists"};
    Station ->
      case lists:filter(fun(#measurement{date = D, type = T}) -> D =:= Date andalso T =:= Type end,maps:get(Station, P)) of
        [H] -> H#measurement.value;
        [] -> {error, "Measurement does not exists"};
        _ -> {error, "Something went wrong"}
      end
  end.


getStationMean(Type, NameOrCoords, P) ->
  case stationExists(NameOrCoords, maps:keys(P)) of
    false -> {error, "Station does not exists"};
    Station ->
      F = fun(#measurement{value = V1}, V2)-> V1 + V2 end,
      Mes = maps:get(Station, P),
      Sum = lists:foldl(F ,0 ,lists:filter(fun(#measurement{type = T}) -> T =:= Type end, Mes)),
      Sum/lists:flatlength(Mes)
  end.


getDailyMean(Type, {Ye, Mo, Day}, P) ->
  Mes = lists:flatten(maps:values(P)),
  F1 = fun(#measurement{date = {D, _}, type = T}) -> D =:= {Ye, Mo, Day} andalso T =:= Type end,
  Mes2 = lists:filter(F1, Mes),
  Size = length(Mes2),
  F2 = fun(#measurement{value = V1}, V2) -> V1 + V2 end,
  Sum = lists:foldl(F2, 0, Mes2),
  Sum/Size.


getMinMaxValue(Coords, Type, Date, P) ->
  case stationExists(Coords, maps:keys(P)) of
    false -> {error, "Station does not exists"};
    Station ->
      Mes1 = maps:get(Station, P),
      F1 = fun(#measurement{date = {D, _}, type = T}) -> D =:= Date andalso T =:= Type end,
      Mes2 = lists:filter(F1, Mes1),
      F2 = fun(#measurement{value = V}) -> V end,
      Values = lists:map(F2, Mes2),
      {lists:min(Values), lists:max(Values)}
  end.


stationExists(_, []) -> false;

stationExists({X, Y}, [H]) ->
  case {X, Y} =:= H#station.coords of
    false -> false;
    _ -> H
  end;

stationExists({X, Y}, [H | T]) ->
  case {X, Y} =:= H#station.coords of
    true -> H;
    _ -> stationExists({X, Y}, T)
  end;

stationExists(Name, [H]) ->
  case Name == H#station.name of
    false -> false;
    _ -> H
  end;

stationExists(Name, [H | T]) ->
  case Name == H#station.name of
    true -> H;
    _ -> stationExists(Name, T)
  end.


initPol() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Jakas", {10, 20}, P),
  P2 = pollution:addValue({10, 20}, calendar:local_time(), "PM20", 4, P1),
  P3 = pollution:addStation("Druga", {1, 20}, P2),
  P4 = pollution:addValue("Druga", calendar:local_time(), "PM20", 1, P3),
  P5 = pollution:addStation("Trzecia", {10, 200}, P4),
  P6 = pollution:addValue("Trzecia", calendar:local_time(), "PM20", 3, P5),
  pollution:addValue({10, 20} ,{{2018,4,22},{18,40,56}} , "PM20", 10, P6).



