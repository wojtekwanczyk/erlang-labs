%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. maj 2018 15:20
%%%-------------------------------------------------------------------
-module(server_test).
-author("Wojtek").

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).


start_test() ->
  ?assert(pollution_server:start() =:= true),
  pollution_server:stop().

addStation_test()->
  pollution_server:start(),
  P1 = pollution_server:addStation("First",{1,1}),
  P2 = pollution_server:addStation("Second",{1,1}),
  P3 = pollution_server:addStation("Third",{1,1}),
  P4 = pollution_server:addStation("First",{2,2}),
  P5 = pollution_server:addStation("Fourth",{2,2}),
  pollution_server:stop(),
  ?assertEqual(#{{station, "First",{1,1}} => []},P1),
  ?assertEqual("Station already exists",P2),
  ?assertEqual("Station already exists",P3),
  ?assertEqual("Station already exists",P4),
  ?assertEqual(#{{station, "Fourth",{2,2}} => [], {station, "First",{1,1}} => []},P5).


addValue_test() ->
  pollution_server:start(),
  pollution_server:addStation("Stacja1",{22.332,31.23231}),
  P2 = pollution_server:addValue("Stacja1", {{2017,05,01},{15,20,12}}, "PM10",58254),
  P3 = pollution_server:addValue("Stacja1", {{2017,05,01},{15,20,12}},"PM10",58254),
  P4 = pollution_server:addValue({22.332,31.23231}, {{2017,05,01},{15,20,12}}, "PM10",58254),
  P5 = pollution_server:addValue("Stacja1", {{2017,05,01},{15,20,12}}, "PM10",54),
  P6 = pollution_server:addValue("Stacja2",{{2015,08,17},{14,52,12}},"PM10",15),
  pollution_server:stop(),
  ?assertEqual(#{{station, "Stacja1",{22.332,31.23231}} =>
  [{measurement,{{2017,5,1},{15,20,12}},"PM10",58254}]},P2),
  ?assertEqual("Measurement already exists", P3),
  ?assertEqual("Measurement already exists", P4),
  ?assertEqual("Measurement already exists", P5),
  ?assertEqual("Station does not exists", P6).

removeValue_test() ->
  pollution_server:start(),
  pollution_server:addStation("Station1", {1, 2}),
  M4 = pollution_server:addValue("Station1",{{2017, 04, 11},{20, 0, 0}}, "PM10",6),
  pollution_server:addValue("Station1",{{2017, 04, 11},{19, 0, 0}}, "PM10",6),
  M6 = pollution_server:removeValue("Station1", {{2017, 04, 11},{19, 0, 0}}, "PM10"),
  pollution_server:stop(),
  ?assertEqual(M4, M6).


getOneValue_test() ->
  pollution_server:start(),
  pollution_server:addStation( "Station 1", {52, 32}),
  pollution_server:addStation("Station 2", {55, 32}),
  pollution_server:addValue( "Station 1" , {{2017,5,4},{21,22,39}},"PM2", 10.0),
  ?assertEqual(10.0, pollution_server:getOneValue("PM2", {{2017,5,4},{21,22,39}}, "Station 1")),
  ?assertEqual("Measurement does not exists", pollution_server:getOneValue("PM2", {{2017,5,4},{21,22,39}},"Station 2")),
  ?assertEqual("Station does not exists", pollution_server:getOneValue("PM10",{{2017,5,4},{12,58,14}}, "Stacja tzrecia")),
  pollution_server:stop().

getStationMean_test() ->
  pollution_server:start(),
  pollution_server:addStation("Stacja pierwsza", {32.123,{1.582}}),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{12,47,58}}, "PM10", 4),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,13},{12,47,58}}, "PM10", 8),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,14},{12,47,58}}, "PM10", 2),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,14},{21,47,58}}, "PM10", 2),
  ?assertEqual(4.0, pollution_server:getStationMean("PM10", "Stacja pierwsza")),
  pollution_server:stop().


getDailyMean_test() ->
  pollution_server:start(),
  pollution_server:addStation("Stacja pierwsza", {32.123,{1.582}}),
  pollution_server:addStation("Stacja druga",{21.47,4.147}),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{11,14,8}}, "PM10", 3),
  pollution_server:addValue("Stacja druga",{{2017,5,12},{15,7,23}}, "PM10", 1),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{12,47,58}}, "PM10", 2),
  pollution_server:addValue("Stacja druga",{{2017,5,12},{21,47,58}}, "PM10", 2),
  ?assertEqual(2.0, pollution_server:getDailyMean("PM10",{2017,5,12})),
  pollution_server:stop().



getMinMaxValue_test() ->
  pollution_server:start(),
  pollution_server:addStation("Stacja pierwsza", {32.123, 1.582}),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{12,47,58}}, "PM10", 111),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{12,49,58}}, "PM10", 454),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{12,54,58}}, "PM10", 833),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{12,55,58}}, "PM10", 662),
  pollution_server:addValue("Stacja pierwsza",{{2017,5,12},{21,34,58}}, "PM10", 22),
  ?assertEqual({22,833}, pollution_server:getMinMaxValue({32.123, 1.582}, "PM10", {2017,5,12})),
  pollution_server:stop().
