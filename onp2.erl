%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. kwi 2018 14:41
%%%-------------------------------------------------------------------
-module(onp2).
-author("Wojtek").

%% API
-export([onp2/1, onpc/2, bin_to_num/1]).


onp2(T) ->
  onpc(string:tokens(T, " "), []).

onpc(["+" | T], [A | [B | S]]) ->
  onpc(T, [A + B | S]);

onpc(["*" | T], [A | [B | S]]) ->
  onpc(T, [A * B | S]);

onpc(["/" | T], [A | [B | S]]) ->
  onpc(T, [B / A | S]);

onpc(["-" | T], [A | [B | S]]) ->
  onpc(T, [B - A | S]);

onpc(["sqrt" | T], [A | S]) ->
  onpc(T, [math:sqrt(A) | S]);

onpc(["^" | T], [A | [B | S]]) ->
  onpc(T, [math:pow(B, A) | S]);

onpc(["sin" | T], [A | S]) ->
  onpc(T, [math:sin(A) | S]);

onpc(["cos" | T], [A | S]) ->
  onpc(T, [math:cos(A) | S]);

onpc([A | T], S) ->
  onpc(T, [bin_to_num(A)] ++ S);

onpc([], [S]) ->
  S.


bin_to_num(Expr) ->
  case string:to_float(Expr) of
    {error, no_float} -> list_to_integer(Expr);
    {F, _Rest} -> F
  end.