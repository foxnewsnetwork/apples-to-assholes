###
# Initializers Live Here		
###

port = 3123
io = require("socket.io").listen(port)


Backbone = require "backbone"
_ = require "underscore"

# The Card class
class Card extends Backbone.Model
	# Cards have one 2 attributes, content, and category. To make things easy, cards are immutable
	defaults: 
		# for example: "Just before his death, Michael Jackson thought of ________"
		content: "" , 
		# Black cards are prompt cards and white cards are response cards
		category: "white" ,
		# Image associated with the card
		image: null
	, # defaults
# Card



# The cards collection
# We should initialize a a bunch of cards for room
class Cards extends Backbone.Collection
	model: Card,
	@retrieve: (options) ->
		# options = { category : "black/white", limit : n }
		# returns count number of cards of category category
		switch options["category"]
			when "black"
				# TODO: Write code to actually get black cards
				return [new Card({ "category": "black", "content": "some content here"})]
			when "white"
				# TODO: Write code to actually get black cards
				return [new Card("category": "white", "content": "niggers")]
		# switch
	, # retrieve
# Cards

# The room is where the game actually happens. If there is 1 or more players in a room, a game
# is constantly happening. A game only stops when all players leave, at which time the room dies
class Room extends Backbone.Model
	@white_card_time: 15000 ,
	@vote_time: 15000 ,
	@starting_hand: 10 ,
	defaults:
		state: "pre-game" ,
		name: "default" ,
		start_vote: -> 
			
			Backbone.Events.trigger "stuff"
		, # start_vote
		announce_winner: -> 
			
			Backbone.Events.trigger "stuff"
		, # announce_winner
		pass_whites: -> 
			
			Backbone.Events.trigger "stuff"
		, # pass_whites
		pass_blacks: -> 
			
			Backbone.Events.trigger "stuff"
		, # pass_blacks
	, # defaults
	initialize: ->
		@counter = 0
	, # initialize
	join: (data={}) ->
		if @counter is 0
			@start_game()
		@counter += 1
		# Return starting hand
		return _.extend(data, {cards: Cards.retrieve(limit: Room.starting_hand, category: "white")})
	, # join
	start_game: ->
		# Step 1: Change game state
		@set "state", "black-card", {silent: true}

		# Step 1.5: Get a bunch of white cards
		white = Cards.retrieve({limit: @counter, category: "white"})

		# Step 2: Pass out 1 white card to all players
		@get("pass_whites")(white)

		# Step 3: Get a black card
		black = Cards.retrieve({limit: 1, category: "black"})

		# Step 4: Pass out the black card to all players
		@get("pass_blacks")(black)

	, # start_game
	leave: (data) ->
		@counter -= 1
		if @counter is 0
			clearTimeout(@white_timer) if @white_timer?
			clearTimeout(@vote_timer) if @vote_timer?
			clearTimeout(@post_game_timer) if @post_game_timer?
			@destroy()
		return data
	, # leave
	white_card: (data) ->
		# accepts a white card and starts timer to advance game state
		switch @get "state"
			when "black-card"
				@white_timer = setTimeout( ( =>
					@start_vote() )
				, Room.white_card_time ) # 15 seconds after the first card
				@set "state", "white-card", {silent: true}
				return data
			when "white-card"
				return data
			else
				return null
		# switch
	, # white_card
	start_vote: ->
		@set "state", "vote", {silent: true}
		@get("start_vote")()
	, # start_vote
	vote: (data) ->
		# accepts a vote and starts timer to advance game state
		switch @get "state"
			when "vote"
				@vote_timer = setTimeout( (=>
					@announce_winner()
				), Room.vote_time)
				@set "state", "vote-counting", {silent: true}
				return data
			when "vote-counting"
				return data
			else
				return null
		# switch	
	, # vote
	announce_winner: ->
		@set "state", "post-game", {silent: true}
		@get("announce_winner")()
		@post_game_timer = setTimeout( ( => @start_game() ) , 2000 )
	, # announce_winner
# Room

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
	
	socket.on "join room up", (name) ->
		socket.join(name)
		io.sockets.in(name).emit "join room down", socket.id
	# join room up

	socket.on "disconnect", ->
		io.sockets.in(socket.room).emit "leave room down", socket.id
	# disconnect

	socket.on "backbone event up", (data={}) ->
		eventname = data['eventname']
		content = _.extend(data, {"local":true})
		Backbone.Events.trigger eventname, content
	# backbone event up

	Backbone.Events.on "all", (eventname) ->
		rest = Array.prototype.slice.call(arguments, 1)[0]
		if rest["local"]
			return
		data = {
			"socketid": socket.id ,
			"eventname": eventname ,
			"data": rest
		} # data
		if rest["global"]
			socket.emit "backbone event down", data
		else
			io.sockets.in(rest["name"]).emit("backbone event down", data)

###		console.log "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		console.log "+	Backbone Event #{eventname} Up Detected!!!	+"
		console.log "+	#{JSON.stringify(rest[0])}	+"
		console.log "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"###
	# all
# io.sockets.on connection
