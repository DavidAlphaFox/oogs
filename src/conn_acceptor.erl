-module(conn_acceptor).

-behaviour(gen_fsm).

%% API
-export([start_link/1]).

%% gen_fsm callbacks
-export([init/1,
         accept/2,
         handle_event/3,
         handle_sync_event/4,
         handle_info/3,
         terminate/3,
         code_change/4]).

%% gen_fsm state
-record(state, {listen_sock}).


%%%===================================================================
%%% API
%%%===================================================================
start_link(LSock) ->
    gen_fsm:start_link(?MODULE, [LSock], []).


%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================
init([LSock]) ->
    {ok, accept, #state{listen_sock = LSock}}.

accept(_Event, State) ->
    case gen_tcp:accept(State#state.listen_sock) of
        {ok, Sock} ->
	    dispatch_connection(Sock),
	    {next_state, accept, State};
	_Error ->
            {next_state, accept, State}
    end.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    {reply, ok, StateName, State}.

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
