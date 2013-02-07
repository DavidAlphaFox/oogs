all:ebin/*.beam
	erlc -o ebin src/*.erl
