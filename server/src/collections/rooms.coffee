class Rooms extends Backbone.Collection
	names: {} ,
	# Gets the room, or creates one if it doesn't exist
	retrieve: (name)->
		position = @names[name]
		if position?
			return @at position
		else
			@names[name] = @length
			room = new Room("name": name)
			@add room
		# if-else
	, # retrieve
	model: Room
# Rooms
	