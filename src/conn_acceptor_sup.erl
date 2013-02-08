-module(conn_acceptor_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_acceptor/1, start_muti_acceptor/2]).

%% Supervisor callbacks
-export([init/1]).

-define(SUPERVISOR, ?MODULE).


%%%===================================================================
%%% API functions
%%%===================================================================
start_link() ->
    supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, []).

start_acceptor(LSock) ->
    supervisor:start_child(?SUPERVISOR, [LSock]).

start_muti_acceptor(_LSock, 0) ->
    ok;

start_muti_acceptor(LSock, Num) ->
    start_acceptor(LSock),
    start_muti_acceptor(LSock, Num - 1).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([]) ->
    Child = {conn_acceptor, {conn_acceptor, start_link, []},
        permanent, 5000, worker, [conn_acceptor]},
    RestartStrategy = {simple_one_for_one, 5, 1},
    {ok, {RestartStrategy, [Child]}}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
