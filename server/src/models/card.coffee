# The Card class
class Card extends Backbone.Model
	# Cards have one 2 attributes, content, and category. To make things easy, cards are immutable
	defaults: 
		# for example: "Just before his death, Michael Jackson thought of ________"
		content: "" , 
		# Black cards are prompt cards and white cards are response cards
		category: "white"
	, # defaults
	@create: ( data ) ->
		# The create method creates and saves a card somewhere
		throw "Not Implemented Exception"
	, # create
	@all: (category) ->
		# Gets all the cards of a certain category
		throw "Not Implemented Exception"
	, # all
	@limit: (category, count) ->
		# returns count number of cards of category category
		throw "Not Implemented Exception"
	, # limit
	get: (key) ->
		# gets the value of the attribute
		throw "Not Implemented Exception"
	, # get
# Card

