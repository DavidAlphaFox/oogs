-module(conn_sup).

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
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_client(Sock) ->
    supervisor:start_client(?SUPERVISOR, [Sock]).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([]) ->
    Child = {client, {client, start_link, []}, temporary, brutal_kill,
        brutal_kill, [client]},
    RestartStrategy = {simple_one_for_one, 1, 0},
    {ok, {RestartStrategy, [Child]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
