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

class Channel extends Backbone.Model
	count: 0 ,
	users: {} ,
	initialize: (@name) ->
	, # initialize
	join: (socket) ->
		socketid = socket.id or socket
		if @count is 0
			@master = socket
		else
			@users[socketid] = socket
		@count++
	, # join
	leave: (socket) ->
		socketid = socket.id or socket
		if socket is @master
			for key of @users
				@master = @users[key]
				delete @users[key]
				break
		else
			delete @users[socketid]
		@count--
	, # leave

# Channel

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
	

class Channels extends Backbone.Collection
	model: Channel ,
	names_hash: {} ,
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
# Channels

###
# Router Section
###
# 4 socket events will be exposed in the router
# the naming convention:
#all events emitted by the client and received by the server will end with up
# all events emitted by the server down to the client will end with down
# The 4 socket io events are as below

io.sockets.on "connection", (socket) ->
	channels = {}
	# Confirms connection
	socket.emit("connection down", socket.id)
	
	socket.on "join room up", (name) ->
		socket.join(name)
		Channels[name] = new Channel() unless Channels[name]?
		Channels[name].join socket
		socket.emit "channel stat down", channels[name].serialize()
		io.sockets.in(name).emit "join room down", socket.id

		io.sockets.in(name).on "backbone event up", (data={}) ->
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
				io.sockets.emit "backbone event down", data
			else
				io.sockets.in(rest["name"]).emit("backbone event down", data)
		# all
	# join room up

	socket.on "disconnect", ->
		Channels[name].leave
		io.sockets.in(socket.room).emit "leave room down", socket.id
	# disconnect
# io.sockets.on connection


chai = require("chai")
expect = chai.expect
should = chai.should()
assert = chai.assert

###
# Tests for Card collections
###

describe "Cards", ->
	describe "Sanity test", ->
		it "should exist", ->
			expect(Cards).to.be.ok
	describe "Retrieve", ->
		it "should retrieve cards", ->
			cards = Cards.retrieve({category: "black", limit: 1})
			expect(cards.length).to.equal 1
			

###
# Room "Model" Spec
###
describe "Room Model", ->
	describe "Sanity Test" , ->
		it "should not be null" , ->
			expect(Room).to.be.ok
	describe "initialization", ->
		beforeEach ->
			@room = new Room(
				"name": "test room" ,
				"start_vote": -> return false ,
				"announce_winner" : -> return false ,
				"pass_whites": (whites) -> return false ,
				"pass_blacks": (blacks) -> return false 
			) # new room
		afterEach ->
			@room.destroy()
		it "should work", ->
			expect(@room.get "name").to.equal "test room"
		it "should have 0 counter", ->
			expect(@room.counter).to.equal(0)
		it "should attempt to join a new game", ->
			@room.join()
			expect(@room.counter).to.equal 1

###
# Channel Spec
###
describe "Channel Model", ->
	describe "Sanity test", ->
		it "should be ok", ->
			expect(Channel).to.be.ok
	# Sanity
	describe "Joining", ->
		channel = new Channel("testing_channel")
		it "should be initially empty", ->
			expect(channel.count).to.equal 0
		it "should allow sockets to join", ->
			channel.join( "socketid" )
			expect(channel.count).to.equal 1
			expect(channel.master).to.equal "socketid"
		it "should allow someone else to join also", ->
			channel.join( "leaverid")
			expect(channel.count).to.equal 2
			expect(channel.users["leaverid"]).to.equal "leaverid"
		it "should let people leave", ->
			channel.leave( "leaverid" )
			expect(channel.count).to.equal 1
		it "should fallback the master to another person if the current master leaves", ->
			channel.join( "fillerid" )
			channel.leave( "socketid" )
			expect(channel.master).to.equal "fillerid"
	# Joining
# Channel Model

###
# Channels Spec
###
describe "Channels Collection", ->
	describe "Sanity test", ->
		it "should be ok", ->
			expect(Channels).to.be.ok
	# sanity
	describe "functionality", ->
		channels = new Channels()
		it "should be ok", ->
			expect(channels).to.be.ok
		it "should let me get to a channel", ->
			expect(channels.length).to.equal 0
			channel = channels.retrieve "test-chan"
			expect(channels.length).to.equal 1
		it "should be the right channel", ->
			channel = channels.retrieve "test-chan"
			expect(channel).to.be.ok
			expect(channel.name).to.equal "test-chan"
			expect(channel.count).to.equal 0
	# functionality
# Channels Collection



describe "Rooms Collection", ->
	describe "Sanity Test", ->
		it "should not be null", ->
			expect(Rooms).to.be.ok
	# sanity test
	describe "rooms", ->
		rooms = new Rooms()
		it "should create a collection", ->
			expect(rooms).to.be.ok
			expect(rooms.length).to.equal 0
		it "should create a room", ->
			rooms.retrieve("test room")
			expect(rooms.length).to.equal 1
	# rooms
# Rooms