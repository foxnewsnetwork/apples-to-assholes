class Room extends Backbone.Model
	@white_time: 15000 ,
	state: "pre-game" ,
	post_game_clean_up: ->
		Flash.show "Cleaning after the game"
		@black.remove() if @black?
		if @whites?
			while @whites.length > 0
				@whites.pop().remove()
		if @player?
			@player.post_game_clean_up()
	, # post_game_clean_up
	initialize: ->
		@view = new RoomView(model: this)
		@view.render()
		Backbone.Events.on "game:start", =>
			Flash.show "game:start event received"
			@black = Card.random({"category": "black"})
			@black.render($(@view.el))
			@whites = new Cards()
			@player = new Player() # you
			@white_timer = null
			@state = "black-card"
		Backbone.Events.on "card:white", (card) =>
			switch @state
				when "black-card"
					unless @white_timer?
						@white_timer = Timer.setTimeout(=>
							@post_game_clean_up()
							Backbone.Events.trigger "game:start"
						, Room.white_time)
						@state = "white-card"
					@whites.add card
					card.move_to($(@view.el))
					card.in_play = true
				when "white-card"
					@whites.add card
					card.move_to($(@view.el))
					card.in_play = true
			# switch
	, # initialize
# Room