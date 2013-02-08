{application, conn,
	[{description, "OOGS connection-server subsystem"},
	 {vsn, "0.0.1"},
	 {modules, [conn, conn_sup, conn_app, conn_acceptor,
	            conn_acceptor_sup, conn_client, conn_client_sup]},
	 {registerd, [kernel, stdlib]},
	 {mod, {conn_app, [8090, 5]}}
	]}.
