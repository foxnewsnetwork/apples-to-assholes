class Player extends Backbone.Model
	initialize: (cards)->
		@view = new PlayerView(model: this)
		CardView.first_click = true
		CardView.first_vote = true
		@view.render()
		@cards = Cards.random({"category": "white", "limit": 10})
		@cards.render(@view.container)
	, # initialize
	post_game_clean_up: ->
		if @cards?
			while @cards.length > 0
				@cards.pop().remove()
	, # post_game_clean_up
# Player