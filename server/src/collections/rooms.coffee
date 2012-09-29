class Rooms extends Backbone.Collection
	names: {} ,
	# Gets the room, or creates one if it doesn't exist
	retrieve: (name)->
		position = @names[name]
		if position?
			return @at position
		else
			@names[name] = @length
			room = new Room(
				"name": name ,
				start_vote: (data)->
					io.sockets.in(name).emit( "start vote down" , data)
				, # start_vote
				announce_winner: (data)->
					io.sockets.in(name).emit( "winner down", data)
				, # announce_winner
				pass_whites: (data)->
					io.sockets.in(name).emit( "white cards down", data)
				, # pass_whites
				pass_blacks: (data)->
					io.sockets.in(name).emit( "black card down", data)
				, # pass_blacks
			) # room
			@add( )
		# if-else
	, # retrieve
	model: Room
# Rooms
	