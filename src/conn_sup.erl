-module(conn_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SUPERVISOR, ?MODULE).


%%%===================================================================
%%% API functions
%%%===================================================================
start_link(LSock) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [LSock]).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([LSock]) ->
    AcceptorSup = {conn_acceptor_sup, {conn_acceptor_sup, start_link, [LSock]},
        permanent, 5000, supervisor, [conn_acceptor_sup]},
    ClientSup = {conn_client_sup, {conn_client_sup, start_link, []},
        permanent, 5000, supervisor, [conn_client_sup]},
    RestartStrategy = {one_for_one, 5, 10},
    {ok, {RestartStrategy, [AcceptorSup, ClientSup]}}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
