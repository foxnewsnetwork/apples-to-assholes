class Player extends Backbone.Model
	initialize: (cards)->
		@view = new PlayerView(model: this)
		@view.render()
		@cards = Cards.random({"category": "white", "limit": 10})
		@cards.render(@view.container)
	# initialize
# Player