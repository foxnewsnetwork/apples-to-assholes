class Player extends Backbone.Model
	initialize: (cards)->
		@cards = Cards.random({"category": "white", "limit": 10})
	# initialize
# Player