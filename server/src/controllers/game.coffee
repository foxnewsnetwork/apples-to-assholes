###
# Router Section
###
# 4 socket events will be exposed in the router
# the naming convention:
#all events emitted by the client and received by the server will end with up
# all events emitted by the server down to the client will end with down

# The 4 socket io events are as below
io.sockets.on "connection", (socket) ->
	# Confirms connection
	socket.emit("connection down", socket.id)
	
	# join room up happens when a player joins a room; all visitors need to join a room.
	# once joined, the server needs to let everyone else in the room know a new player has joined
	socket.on "join room up", (data) ->
		# data = 
		# 	socketid : Integer ,
		# 	roomid : String
		# throw "Not Implemented"
		room = Rooms.retrieve data['roomid']
		player = room.join data
		socket.join(data['roomid'])
		socket.to(data['roomid']).emit "join room down", player
	# join room up

	# white cards are response cards to a given prompt card.
	# the server needs to let everyone else in the room know who put what white card up
	# after the first card received after the server has sent down a black card starts a timer
	# at the end of the timer, no more white cards can be submitted until a new round starts
	socket.on "white card up", (data) ->
		# data =
		# 	socketid : Integer ,
		# 	cardid : Integer ,
		# 	roomid : String
		# throw "Not Implemented"
		
		# Step 1: Null check - are we even in a room?
		room = Rooms.retrieve data['roomid']
		white_card = room.white_card data
		socket.to(data['roomid']).emit "white card down", white_card if white_card?

	# white card up

	# players vote after the white card submission timer ends.
	# the first vote triggers a vote timer, and the winner of the voting wins all the white cards in play
	# after the voting, the server starts a new game by sending down another black card
	socket.on "vote up", (data) ->
		# data =
		# 	socketid : Integer ,
		# 	cardid : Integer ,
		# 	roomid : String
		# throw "Not Implemented"

		# Step 1: Get the room
		room = Rooms.retrieve data['roomid']
		vote = room.vote data
		socket.to(data['roomid']).emit "vote down" , vote if vote?
	# vote up

	# occurs when a player leaves the room, the server must let everyone else know. 
	# if he has white cards in play, they are destroyed
	socket.on "leave room up", (data) ->
		# data = 
		# 	socketid : Integer ,
		# 	roomid : String
		room = Rooms.retrieve data['roomid']
		player = room.leave data
		socket.to(data['roomid']).emit "leave room down", player if player?
	# leave room up
# io.sockets.on connection
