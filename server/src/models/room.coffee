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