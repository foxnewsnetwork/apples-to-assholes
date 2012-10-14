###
# Router Section
###
# Decentralized Static Game Server
# the DSGS is a simple machine that stores minimum state info
# and serves out static assets. Because no state is maintained
# on the server, "update" and "create" are not availible
# update and create should, instead, be handled separately else-
# where and interact directly with whatever storage system you use

# Initialize the game in here, ostensibly, we should do it else where
# It seems there are really only two types of socket events:
# 1. echo : pass an event to everyone in the room
# 2. interact : request some data from the server
channels = new Channels()
io.sockets.on "connection", (socket) ->
	# Setups the user into a room
	channels.setup socket

	socket.on "set nickname up", (nickname) ->
		socket.nickname = nickname
	# nickname

	socket.on "echo event up", (data) ->
		channel = channels.retrieve socket.room
		channel.echo data
	# echo event up

	# Obviously, implement this method to your content when using
	socket.on "interact event up", (data) ->
		channels.interact socket, data
		# switch
	# interact event
# io.sockets.on connection

