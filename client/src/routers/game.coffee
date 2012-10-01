
# The game model drives the game and handles communication with the server
# It fires all 4 events detailed in the game.coffee controller, and receives the following 4
# socket only lives in here, backbone events fire everywhere though
class Game extends Backbone.Router
	routes: {
		":name": "room_switch"
	} , # routes	
	# routes are actually game states
	initialize: (@socket) ->
		@room = new Room()
		Backbone.Events.trigger "game:start"
	, # initialize
# Game
