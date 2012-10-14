class Channel extends Backbone.Model
	count: 0 ,
	users: {} ,
	initialize: (@name) ->
	, # initialize
	join: (socket) ->
		socketid = socket.id or socket
		if @count is 0
			@master = socket
			@master.emit "master down" if socket.id?
		else
			@users[socketid] = socket
		@count++

		# Handle events
		if socket.id?
			socket.join(@name)
			io.sockets.in(@name).emit "join room down", socket.id
			io.sockets.in(@name).emit "room status down", @status()
			socket.on "disconnect", =>
				@leave socket
		# if 
	, # join
	leave: (socket) ->
		socketid = socket.id or socket
		if socket is @master
			for key of @users
				@master = @users[key]
				delete @users[key]
				break
			@master.emit "master down" if socket.id?
		else
			delete @users[socketid]
		@count--

		if socket.id?
			io.sockets.in(@name).emit "room status down", @status()
	, # leave
	status: ->
		output = {
			"count": @count ,
			"users": [] ,
			"name": @name 
		} # output
		for socketid, user of @users
			output["users"].push( user.nickname or socketid )
		return output
	, # status
	echo: (data) ->
		io.sockets.in(@name).emit "echo event down", data
	, # echo
# Channel