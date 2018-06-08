%%%-------------------------------------------------------------------
%%% @author Wojtek
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. maj 2018 10:43
%%%-------------------------------------------------------------------
-module(incrementator).
-author("Wojtek").

%% API
-export([]).

-behaviour(gen_server).
%% API
-export([start_link/0, increment/1,get/1,close/1, decrement/1]).
-export([init/1,handle_call/3,handle_cast/2,terminate/2]).

%% START %%
start_link()   -> gen_server:start_link(?MODULE,0,[]).

%% INTERFEJS KLIENT -> SERWER %%
increment(Pid) -> gen_server:cast(Pid,inc).
decrement(Pid) -> gen_server:cast(Pid,dec).
get(Pid)       -> gen_server:call(Pid, get).
close(Pid)     -> gen_server:call(Pid,terminate).
init(N)        -> {ok,N}.

%% OBSŁUGA WIADOMOŚCI %%
handle_cast(inc, N) -> {noreply, N+1};
handle_cast(dec, N) -> {noreply, N-1}.


handle_call(get,_From, N)      -> {reply, N, N};
handle_call(terminate,_From,N) -> {stop, normal, ok, N};
handle_call(_,_From, N)      -> {reply, N, N}.


terminate(normal, N) -> io:format("The number is: ~B~nBye.~n",[N]), ok.