
# The game model drives the game and handles communication with the server
# It fires all 4 events detailed in the game.coffee controller, and receives the following 4
class Game extends Backbone.Model
	@socket: ( ->
		socket.on "join room down", (data) ->
			data =
				socketid : Integer
				roomid : Integer
			throw "Not implemented"
		# join room down
		socket.on "black card down", (data) ->
			data =
				roomid : Integer
				cardid : Integer
				content : String
			throw "Not implemented"
		# black card down
		socket.on "white card down", (data) ->
			data =
				roomid : Integer
				socketid : Integer
				content : String
			throw "Not implemented"
		# white card down
		socket.on "vote down", (data) ->
			data =
				roomid : Integer
				socketid : Integer
			throw "Not implemented"
		# vote down
		return socket
	)() , # socket
# Game
