
# The game model drives the game and handles communication with the server
# It fires all 4 events detailed in the game.coffee controller, and receives the following 4
class Game extends Backbone.Model
	initialize: (@socket) ->
		# Step 1: setup connection with the server
		@socket.on "connection down", (socketid) ->
			@socketid = socketid
			# Step 2: Do other stuff
		# connection down
	, # initialize
# Game
