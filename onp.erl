%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. mar 2018 14:14
%%%-------------------------------------------------------------------
-module(onp).
-author("Wojtek").

%% API
-export([onp/1, onpc/1]).


onp(L) ->
  onpc(string:tokens(L," ")).

onpc([A, B, "*"]) ->
  list_to_integer(A)*list_to_integer(B);

onpc([A, B, "*" | T]) ->
  onpc([integer_to_list(list_to_integer(A)*list_to_integer(B)) | T]);

onpc([A, B, "+"]) ->
  list_to_integer(A)+list_to_integer(B);

onpc([A, B, "+" | T]) ->
  onpc([integer_to_list(list_to_integer(A)+list_to_integer(B)) | T]);

onpc([A, B, "-"]) ->
  list_to_integer(A)-list_to_integer(B);

onpc([A, B, "-" | T]) ->
  onpc([integer_to_list(list_to_integer(A)-list_to_integer(B)) | T]);


onpc([A, B, "/"]) ->
  list_to_integer(A)/list_to_integer(B);

onpc([A, B, "/" | T]) ->
  onpc([integer_to_list(list_to_integer(A)/list_to_integer(B)) | T]);



onpc(_) ->
  io:format("Incorrect form\n").


