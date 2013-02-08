-module(conn_client_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_client/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SUPERVISOR, ?MODULE).


%%%===================================================================
%%% API functions
%%%===================================================================
start_link() ->
    supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, []).

start_client(Sock) ->
    supervisor:start_client(?SUPERVISOR, [Sock]).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([]) ->
    Child = {client, {client, start_link, []}, temporary, brutal_kill,
        worker, [client]},
    RestartStrategy = {simple_one_for_one, 0, 1},
    {ok, {RestartStrategy, [Child]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
