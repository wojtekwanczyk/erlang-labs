%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. mar 2018 13:18
%%%-------------------------------------------------------------------
-module(lab1).
-author("Wojtek").

%% API
-export([sumFloats/1]).


sumFloats([H|T]) ->
  H + sumFloats(T);

sumFloats([]) ->
  0.

