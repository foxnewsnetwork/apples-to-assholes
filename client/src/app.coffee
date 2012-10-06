# Initialization
socket = io.connect "http://localhost:3123"
socket.on "connection down", (socketid)->
	socket.id = socketid
	
	apples_to_assholes = new Game socket
