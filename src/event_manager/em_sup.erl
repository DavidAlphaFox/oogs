-module(em_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SUPERVISOR, ?MODULE).


%%%===================================================================
%%% API functions
%%%===================================================================
start_link() ->
    supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, []).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([]) ->
    Child = {em_manager, {em_manager, start_link, []}, permanent, 5000, worker, [em_manager]},
    RestartStrategy = {one_for_one, 1, 0},
    {ok, {RestartStrategy, [Child]}}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
