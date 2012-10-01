class Cards extends Backbone.Collection
	model: Card
	@random: (options) ->
		options = { category: "white", limit: 1 } unless options?
		cards = new Cards()
		for k in [1..options["limit"]]
			card = Card.random(options)
			cards.add card
		return cards
	# @random
# Cards