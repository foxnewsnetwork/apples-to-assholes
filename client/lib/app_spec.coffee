# $.ajaxPrefilter (options, originalOptions, jqXHR) ->
# 	options.xhrFields = { 	"withCredentials": true }
# 	jqXHR.setRequestHeader( "X-CSRF-TOKEN", $("meta[name='csrf-token']").attr("content") )
# # ajaxPrefilter

methodMap =
	'create': 'POST',
	'update': 'PUT',
	'delete': 'DELETE',
	'read':   'GET'
# methodMap

sync_machine = 
	socketio: (method, model, options) ->
		# Step 1: determine the event name
		throw "You must specify a model name error #{JSON.stringify model}" unless model.name
		eventname = "#{model.name} #{method} up" or options["eventname"]

		# Step 2: the socketio globals are availible
		throw "Socket.IO is currently not working ERROR" unless socket?

		# Step 3: Generate the params that eventually gets IO'd up
		params = { eventname: eventname, socketid: socket.id }

		# Step 4: serialize the model if no data
		unless options.data?
			if model.serialize?
				params["data"] = model.serialize() 
			else
				params["data"] = model.toJSON() 
		# unless

		# Step 5: Retrieve the callbacks from options (if any)
		if options["callback"]?
			callback = options["callback"]
			delete options["callback"]
			return socket.emit( eventname, _.extend( options, params ), callback )
		else
			return socket.emit( eventname, _.extend(options, params) )
		# if-else
	, # socketio
	ajax: (method, model, options) ->
		type = methodMap[method]

		# Default JSON-request options.
		params = {type: type, dataType: 'json'}

		# Ensure that we have a URL.
		if (!options.url)
			params.url = model.url or throw "URL ERROR #{JSON.stringify model}"

		# Ensure that we have the appropriate request data.
		if (!options.data and model and (method is 'create' or method is 'update'))
			params.contentType = 'application/json'
			temp_data = { "authenticity_token" : $("meta[name='csrf-token']").attr "content"	}
			throw "You Must Specifiy a Model Name Error #{JSON.stringify model}" unless model.name?
			temp_data[model.name] = model.serialize() if model.serialize?
			temp_data[model.name] = model.toJSON() unless model.serialize?
			params.data = JSON.stringify( temp_data )
	    	
		# For older servers, emulate JSON by encoding the request into an HTML-form.
		if (Backbone.emulateJSON)
			params.contentType = 'application/x-www-form-urlencoded'
			params.data = if params.data then {model: params.data} else {}
		# if

		# For older servers, emulate HTTP by mimicking the HTTP method with `_method`
		# And an `X-HTTP-Method-Override` header.
		if (Backbone.emulateHTTP)
			if (type is 'PUT' or type is 'DELETE')
				if (Backbone.emulateJSON) 
					params.data._method = type
					params.type = 'POST'
					params.beforeSend = (xhr) ->
						xhr.setRequestHeader('X-HTTP-Method-Override', type)
						return
					# params.beforeSend
				# if 
			# if PUT or Delete
		# if HTTP

		# Don't process data on a non-GET request.
		params.processData = false if params.type isnt 'GET' and !Backbone.emulateJSON
			
		# Make the request, allowing the user to override any Ajax options.
		return $.ajax(_.extend(params, options))
	# ajax
# sync_machine

Backbone.sync = (method, model, options) ->
	# Default options, unless specified.
	options or (options = {})

	switch options["protocolStyle"]
		when "socketio"
			return sync_machine.socketio(method, model, options)
		else
			return sync_machine.ajax(method, model, options)
	# switch	
# Backbone.sync



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


# Initialization
socket = io.connect "http://localhost:3123"
apples_to_assholes = new Game socket


mocha.setup "bdd"
$("document").ready ->
	mocha.globals(['apples_to_assholes']).run()
# document ready

describe "Game", ->
	describe "Sanity Test", ->
		it "should have that thing", ->
			expect(Game).to.be.ok
		it "Should at least exist", ->
			expect(apples_to_assholes).to.be.ok
		it "Should have the proper globals", ->
			expect(io).to.be.ok
		it "should have socket enabled", ->
			expect(socket).to.be.ok
	# Sanity Test
	describe "Actual Operation", ->
		it "should have a proper id", (done)->
			setTimeout( =>
				expect(apples_to_assholes.socketid).to.equal(socket.id)
				done()
			, 1950) # timeout
	# Actual Operation
# Game