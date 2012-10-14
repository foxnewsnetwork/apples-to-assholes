# Initialization
socket = io.connect "http://localhost:3123"
socket.on "connection down", (socketid)->
	socket.id = socketid
	apples_to_assholes = new Game socket
	room_name = window.location.hash or "#apples-to-assholes" 
	socket.emit "join room up", room_name
	socket.on "join room down", (socketid) ->
		Flash.show "#{socketid} has joined room #{room_name}", "warning"
# connnection down

