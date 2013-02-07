-module(conn_acceptor_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_acceptor/1, start_muti_acceptor/2]).

%% Supervisor callbacks
-export([init/1]).


%%%===================================================================
%%% API functions
%%%===================================================================
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_acceptor(LSock) ->
    supervisor:start_child([LSock]).

start_muti_acceptor(_LSock, 0) ->
    ok;

start_muti_acceptor(LSock, Num) ->
    start_acceptor(LSock),
    start_muti_acceptor(LSock, Num - 1).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([]) ->
    Child = {acceptor, {conn_acceptor, start_link, []},
        permanent, 5000, worker, [conn_acceptor]},
    RestartStrategy = {simple_one_for_one, 0, 1},
    {ok, {RestartStrategy, [Child]}}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
