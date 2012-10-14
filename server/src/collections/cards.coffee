# The cards collection
# We should initialize a a bunch of cards for room
class Cards extends Backbone.Collection
	model: Card,
	initialize: (@color) ->

	, # initialize
	random: (amount = 1) ->
		return Card.random({ "category": @color, "amount": amount })
	, # random
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