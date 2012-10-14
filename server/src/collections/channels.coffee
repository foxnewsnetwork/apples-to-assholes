class Channels extends Backbone.Collection
	model: Channel ,
	names_hash: {} ,
	@interact: (socket, data) ->
		throw "INTERACT NOT IMPLEMENTED ERROR"
	, # interact
	retrieve: (name) ->
		if @names_hash[name]?
			pos = @names_hash[name]
			return @at pos
		else
			channel = new Channel(name)
			@names_hash[name] = @length
			@push channel
			return channel
	, # retrieve
	setup: (socket) ->
		# Step 1: Confirms connection
		socket.emit("connection down", socket.id)
		
		# Step 2: Handle joining channel
		socket.on "join room up", (name) =>
			
			channel = @retrieve(name)
			channel.join socket
		# join room up

		socket.on "disconnect", ->
			io.sockets.in(socket.room).emit "leave room down", socket.id
		# disconnect
	# setup
# Channels