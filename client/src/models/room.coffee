class Room extends Backbone.Model
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
		Backbone.Events.on "card:white", (card) =>
			@whites.add card
			unless @white_timer?
				@white_timer = setTimeout(=>
					Backbone.Events.trigger "game:start"
				, 15000)
	, # initialize
# Room