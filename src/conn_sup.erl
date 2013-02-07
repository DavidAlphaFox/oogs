-module(conn_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%%%===================================================================
%%% API functions
%%%===================================================================
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([]) ->
    AcceptorSup = {conn_acceptor_sup, {conn_acceptor_sup, start_link, []},
        permanent, 5000, supervisor, [conn_acceptor_sup]},
    ClientSup = {conn_client_sup, {conn_client_sup, start_link, []},
        permanent, 5000, supervisor, [conn_client_sup]},
    RestartStrategy = {{one_for_one, 5, 10}},
    {ok, {RestartStrategy, [AcceptorSup, ClientSup]}}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
