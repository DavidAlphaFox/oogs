-module(cs_app).

-behaviour(application).

%% Application callbacks
-export([start/2,
         stop/1]).


%%%===================================================================
%%% Application callbacks
%%%===================================================================
start(_StartType, [Port, AcceptorNum]) ->
    case gen_tcp:listen(Port, []) of
        {ok, LSock} ->
            {ok, Pid} = cs_sup:start_link(LSock),
            ok = cs_acceptor_sup:start_acceptor(AcceptorNum),
	    {ok, Pid};
	Error ->
	    Error
    end.

stop(_State) ->
    ok.


%%%===================================================================
%%% Internal functions
%%%===================================================================
