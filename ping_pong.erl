-module(ping_pong).

%%-export([]).
-compile(export_all).


start(M) when M > 0 ->
    PingPid = spawn(ping_pong, ping, [M]),
    register(ping, PingPid),
    PongPid = spawn(ping_pong, pong, []),
    register(pong, PongPid);
    %%ping(M);

start(M) ->
    io:format("number must be positive ~n",[M]).

ping(M) ->
    pong ! {ping, M},
    receive
	{pong, 0} ->
	    io:format("Done ~n",[]);
	{pong, 1} ->
	    io:format("pong recieved is ~p ~n",[1]),
	    pong ! {ping, 0};
	{pong, N} ->
	    io:format("pong recieved is ~p ~n",[N]),
	    ping(N-1);
	_OtherMsgs ->
	    io:format("it's not required messsage, ~p ~n",[_OtherMsgs])
    end.


pong() ->
    receive
	{ping, 0} ->
	    io:format("Done ~n",[]);
	{ping, 1} ->
	    io:format("ping recieved is ~p ~n",[1]),
	    ping ! {pong, 0};
	{ping, M} ->
	    io:format("ping recieved is ~p ~n",[M]),
	    ping ! {pong, M-1},
	    pong();
	_OtherMsgs ->
	    io:format("it's not required messsage, ~p ~n",[_OtherMsgs])
    end.
    
    
