{application, conn,
	[{description, "OOGS connection-server subsystem"}
	 {vsn, "0.0.1"},
	 {modules, [conn, conn_server, conn_sup, conn_app]},
	 {registerd, [kernel, stdlib]},
	 {mod, {conn_app, []}}
	]}.
