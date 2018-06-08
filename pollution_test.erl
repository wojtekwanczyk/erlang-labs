%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. kwi 2018 19:33
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("Wojtek").

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).

createMonitor_test() ->
  ?assert(pollution:createMonitor() =:= #{}).

addStation_test()->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("First",{1,1},P),
  P2 = pollution:addStation("Second",{1,1},P1),
  P3 = pollution:addStation("Third",{1,1},P1),
  P4 = pollution:addStation("First",{2,2},P1),
  P5 = pollution:addStation("Fourth",{2,2},P1),
  ?assertEqual(#{{station, "First",{1,1}} => []},P1),
  ?assertEqual({error, "Station already exists"},P2),
  ?assertEqual({error, "Station already exists"},P3),
  ?assertEqual({error, "Station already exists"},P4),
  ?assertEqual(#{{station, "Fourth",{2,2}} => [], {station, "First",{1,1}} => []},P5).


addValue_test() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Stacja1",{22.332,31.23231}, P),
  P2 = pollution:addValue("Stacja1", {{2017,05,01},{15,20,12}}, "PM10",58254,P1),
  P3 = pollution:addValue("Stacja1", {{2017,05,01},{15,20,12}},"PM10",58254,P2),
  P4 = pollution:addValue({22.332,31.23231}, {{2017,05,01},{15,20,12}}, "PM10",58254,P2),
  P5 = pollution:addValue("Stacja1", {{2017,05,01},{15,20,12}}, "PM10",54,P2),
  P6 = pollution:addValue("Stacja2",{{2015,08,17},{14,52,12}},"PM10",15,P1),
  ?assertEqual(#{{station, "Stacja1",{22.332,31.23231}} =>
  [{measurement,{{2017,5,1},{15,20,12}},"PM10",58254}]},P2),
  ?assertEqual({error, "Measurement already exists"}, P3),
  ?assertEqual({error, "Measurement already exists"}, P4),
  ?assertEqual({error, "Measurement already exists"}, P5),
  ?assertEqual({error, "Station does not exists"}, P6).

removeValue_test() ->
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("Station1", {1, 2}, M1),
  M3 = pollution:addStation("Station2", {2, 3}, M2),
  M4 = pollution:addValue("Station1",{{2017, 04, 11},{20, 0, 0}}, "PM10",6, M3),
  M5 = pollution:addValue("Station1",{{2017, 04, 11},{19, 0, 0}}, "PM10",6, M4),
  M6 = pollution:removeValue("Station1", {{2017, 04, 11},{19, 0, 0}}, "PM10", M5),
  ?assertEqual(M4, M6),
  M7 = pollution:addValue("Station1", {{2017, 04, 11},{20, 0, 0}}, "PM25",6, M6),
  M8 = pollution:removeValue("Station1", {{2017, 04, 11},{20, 0, 0}}, "PM25", M7),
  ?assertEqual(M6, M8),
  M9 = pollution:addValue("Station2",{{2017, 04, 11},{20, 0, 0}}, "PM10", 6, M8),
  M10 = pollution:removeValue({2,3},{{2017, 04, 11},{20, 0, 0}}, "PM10", M9),
  ?assertEqual(M8, M10),
  M11 = pollution:addValue("Station2",{{2017, 04, 11},{20, 0, 0}},"PM10", 6, M10 ),
  M12 = pollution:removeValue("Station1", {{2017, 04, 11},{18, 0, 0}}, "PM10", M11),
  ?assertEqual(M11, M12).


getOneValue_test() ->
  P = pollution:createMonitor(),
  P2 = pollution:addStation( "Station 1", {52, 32}, P),
  P3 = pollution:addStation("Station 2", {55, 32}, P2),
  P4 = pollution:addValue( "Station 1" , {{2017,5,4},{21,22,39}},"PM2", 10.0 , P3),
  ?assertEqual(10.0, pollution:getOneValue("PM2", {{2017,5,4},{21,22,39}}, "Station 1", P4)),
  ?assertEqual({error,"Measurement does not exists"}, pollution:getOneValue("PM2", {{2017,5,4},{21,22,39}},"Station 2",  P4)),
  ?assertEqual({error,"Station does not exists"}, pollution:getOneValue("PM10",{{2017,5,4},{12,58,14}}, "Stacja tzrecia" ,P4)).

getStationMean_test() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Stacja pierwsza", {32.123,{1.582}},P),
  P2 = pollution:addStation("Stacja druga",{21.47,4.147},P1),
  P3 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{12,47,58}}, "PM10", 4,P2),
  P4 = pollution:addValue("Stacja pierwsza",{{2017,5,13},{12,47,58}}, "PM10", 8,P3),
  P5 = pollution:addValue("Stacja pierwsza",{{2017,5,14},{12,47,58}}, "PM10", 2,P4),
  P6 = pollution:addValue("Stacja pierwsza",{{2017,5,14},{21,47,58}}, "PM10", 2,P5),
  ?assertEqual(4.0, pollution:getStationMean("PM10", "Stacja pierwsza", P6)).

getDailyMean_test() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Stacja pierwsza", {32.123,{1.582}},P),
  P2 = pollution:addStation("Stacja druga",{21.47,4.147},P1),
  P3 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{11,14,8}}, "PM10", 3,P2),
  P4 = pollution:addValue("Stacja druga",{{2017,5,12},{15,7,23}}, "PM10", 1,P3),
  P5 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{12,47,58}}, "PM10", 2,P4),
  P6 = pollution:addValue("Stacja druga",{{2017,5,12},{21,47,58}}, "PM10", 2,P5),
  ?assertEqual(2.0, pollution:getDailyMean("PM10",{2017,5,12},P6)).


getMinMaxValue_test() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Stacja pierwsza", {32.123, 1.582}, P),
  P2 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{12,47,58}}, "PM10", 111,P1),
  P3 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{12,49,58}}, "PM10", 454,P2),
  P4 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{12,54,58}}, "PM10", 833,P3),
  P5 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{12,55,58}}, "PM10", 662,P4),
  P6 = pollution:addValue("Stacja pierwsza",{{2017,5,12},{21,34,58}}, "PM10", 22,P5),
  ?assertEqual({22,833}, pollution:getMinMaxValue({32.123, 1.582}, "PM10", {2017,5,12}, P6)).