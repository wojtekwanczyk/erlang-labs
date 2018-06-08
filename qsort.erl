%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. kwi 2018 11:36
%%%-------------------------------------------------------------------
-module(qsort).
-author("Wojtek").

%% API
-export([lessThan/2, grtEqThan/2, qs/1, randomElems/3, compareSpeeds/3, digitSum/1, map2/2]).


lessThan(List, Arg) -> [X || X <- List, X < Arg].

grtEqThan(List, Arg) -> [X || X <- List, X >= Arg].

qs([Pivot|Tail]) -> qs(lessThan(Tail, Pivot)) ++ [Pivot] ++ qs(grtEqThan(Tail, Pivot));
qs([]) -> [].

randomElems(N, Min, Max) -> [X || X <- lists:map(fun(_) -> rand:uniform(Max-Min) + Min end,lists:seq(1,N))].

compareSpeeds(List, Fun1, Fun2) ->
  {T1, _} = timer:tc(Fun1, [List]),
  {T2, _} = timer:tc(Fun2, [List]),
  {T1,T2}.

digitSum(X) ->
  lists:foldl(fun(A,B) -> A+B end, 0, lists:map(fun(Y) -> Y - $0 end,integer_to_list(X))).

map2(Fun, X) -> [Fun * X].