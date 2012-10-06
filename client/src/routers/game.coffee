
# The game model drives the game and handles communication with the server
# It fires all 4 events detailed in the game.coffee controller, and receives the following 4
# socket only lives in here, backbone events fire everywhere though
class Game extends Backbone.Router
	routes: {
		"room": "room_switch"
	} , # routes	
	# routes are actually game states
	initialize: (@socket) ->
		@room = new Room()
		alert @socket.id
		Backbone.Events.trigger "game:start"
		Backbone.Events.on "card:white", (card) =>
			if @socket.id is card.get "socketid"
				@socket.emit "white card up", card
	, # initialize
	room_switch: (name) ->
		Flash.show "Switched to room #{name}", "success"
	# room_switch
# Game
