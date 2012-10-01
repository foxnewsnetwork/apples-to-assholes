class Room extends Backbone.Model
	initialize: ->
		Backbone.Events.on "game:start", =>
			@black = Card.random({"category": "black"})
			@whites = new Cards()
			@player = new Player() # you
			@white_timer = null
		Backbone.Events.on "card:white", (card) =>
			@whites.add card
			unless @white_timer?
				@white_timer = setTimeout(=>
					Backbone.Events.trigger "game:start"
				, 15000)
	, # initialize
# Room