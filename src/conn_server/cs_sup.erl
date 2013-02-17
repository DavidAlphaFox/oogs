-module(cs_sup).

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
    supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, [LSock]).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([LSock]) ->
    AcceptorSup = {cs_acceptor_sup, {cs_acceptor_sup, start_link, [LSock]},
        permanent, 5000, supervisor, [cs_acceptor_sup]},
    ClientSup = {cs_client_sup, {cs_client_sup, start_link, []},
        permanent, 5000, supervisor, [cs_client_sup]},
    RestartStrategy = {one_for_one, 5, 10},
    {ok, {RestartStrategy, [AcceptorSup, ClientSup]}}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
