-module(em_manager).

%% API
-export([start_link/0,
         stop/0,
         add_handler/2,
         delete_handler/2]).

-record(state, {}).


%%%===================================================================
%%% API functions
%%%===================================================================
start_link() ->
    gen_event:start_link({local, ?MODULE}).

stop() ->
    gen_event:stop(?MODULE).

add_handler(Handler, Args) ->
    gen_event:add_handler(?MODULE, Handler, Args).

delete_handler(Handler, Args) ->
    gen_event:delete_handler(?MODULE, Handler, Args).


%%%===================================================================
%%% Internal functions
%%%===================================================================
