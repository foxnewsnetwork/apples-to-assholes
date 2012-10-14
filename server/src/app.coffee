###
# The Apples-to-Assholes app
###
# Just mostly an initializer file; everything not mentioned
# is a part of this suckit.io package for a decentralized 
# game server

blacks = new Cards("black")
whites = new Cards("white")

Channels.interact = (socket, data) ->
	amount = data["amount"]
	cards = []
	switch data["eventname"]
		when "request:white"
			cards.concat(whites.random amount)
		when "request:black"
			cards.concat(blacks.random amount)
	# switch
	
# Channels.interact