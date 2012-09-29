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
		start_vote: -> throw "Not Implemented Error" ,
		announce_winner: -> throw "Not Implemented Error" ,
		pass_whites: -> throw "Not Implemented Error" ,
		pass_blacks: -> throw "Not Implemented Error"
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
	

###
# Router Section
###
# 4 socket events will be exposed in the router
# the naming convention:
#all events emitted by the client and received by the server will end with up
# all events emitted by the server down to the client will end with down

# The 4 socket io events are as below
io.sockets.on "connection", (socket) ->
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
