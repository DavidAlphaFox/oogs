-module(cs_acceptor_sup).

-behaviour(supervisor).

%% API
-export([start_link/1, start_acceptor/0, start_acceptor/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SUPERVISOR, ?MODULE).


%%%===================================================================
%%% API functions
%%%===================================================================
start_link(LSock) ->
    supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, [LSock]).

start_acceptor() ->
    supervisor:start_child(?SUPERVISOR, []).

start_acceptor(0) ->
    ok;

start_acceptor(Num) ->
    start_acceptor(),
    start_acceptor(Num - 1).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([LSock]) ->
    Child = {cs_acceptor, {cs_acceptor, start_link, [LSock]},
        permanent, 5000, worker, [cs_acceptor]},
    RestartStrategy = {simple_one_for_one, 5, 1},
    {ok, {RestartStrategy, [Child]}}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
