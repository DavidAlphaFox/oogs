-module(conn_acceptor).

-behaviour(gen_fsm).

%% API
-export([start_link/0]).

%% gen_fsm callbacks
-export([init/1,
         accept/2,
         handle_event/3,
         handle_sync_event/4,
         handle_info/3,
         terminate/3,
         code_change/4]).

-record(state, {listen_socket}).


%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).


%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================
init([LSock]) ->
    {ok, state_name, #state{listen_sock = LSock}}.

accept(_Event, State) ->
    case gen_tcp:accept(State#state.listen_socket) of
        {ok, Sock} ->
	    dispatch_connection(Sock),
	    {next_state, accept, State};
	Error ->
            {next_state, accept, State}
    end.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
dispatch_connection(Sock) ->
    case conn_client_sup:start_client(Sock) of
        {ok, Pid} ->
	    gen_tcp:controlling_process(Sock, Pid);
	Error ->
	    Error
    end.
