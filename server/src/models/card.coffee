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
	@random: (options)
		options = options or { "category": "white", "amount" : 1 }
		cards = []
		for k in [1..options["amount"]]
			cards.push(new Card({
				"content": "Test Card" ,
				"category": options["category"] ,
				"image": "http://placehold.it/240x240"
			}))	# cards push
		return cards
	, # random
# Card

