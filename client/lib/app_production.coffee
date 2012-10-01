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


class Card extends Backbone.Model
	@count: 0
	defaults:
		category: null ,
		content: null,
		image: null
	# defaults
	@random: (options) ->
		options = {"category": "white"} unless options?
		data = {"category": options["category"]}
		switch options["category"]
			when "white"
				# Obviously, we need to load this from the server
				data["content"] = "Old wrinkly Dick"
				data["image"] = "http://upload.wikimedia.org/wikipedia/commons/thumb/8/88/46_Dick_Cheney_3x4.jpg/220px-46_Dick_Cheney_3x4.jpg"
			when "black"
				# Obviously, we need to load this from the server
				data["content"] = "Trevor thinks of _____ every night before going to bed."
			else
				throw "Nonexistant category error"
		# switch
		return new Card(data, options)
	, # random
	initialize: ->
		Card.count += 1
		@view = new CardView({model: this})
	, # initialize
	render: (container) ->
		@view.render container
# Card

class Player extends Backbone.Model
	initialize: (cards)->
		@view = new PlayerView(model: this)
		@view.render()
		@cards = Cards.random({"category": "white", "limit": 10})
		@cards.render(@view.container)
	# initialize
# Player

class Room extends Backbone.Model
	initialize: ->
		@view = new RoomView(model: this)
		@view.render()
		Backbone.Events.on "game:start", =>
			Flash.show "game:start event received"
			@black = Card.random({"category": "black"})
			@black.render($(@view.el))
			@whites = new Cards()
			@player = new Player() # you
			@white_timer = null
		Backbone.Events.on "card:white", (card) =>
			@whites.add card
			unless @white_timer?
				@white_timer = setTimeout(=>
					Backbone.Events.trigger "game:start"
				, 15000)
	, # initialize
# Room

class Vote extends Backbone.Model
# Vote

class Cards extends Backbone.Collection
	model: Card
	@random: (options) ->
		options = { category: "white", limit: 1 } unless options?
		cards = new Cards()
		for k in [1..options["limit"]]
			card = Card.random(options)
			cards.add card
		return cards
	, # @random
	render: (container)->
		@forEach (card) -> 
			card.render(container)
		# forEach
	# render
# Cards

class Players extends Backbone.Collection
	model: Player
# Players

# I guess we don't really use on the client side
class Rooms extends Backbone.Collection
	model: Room
# Rooms

class Votes extends Backbone.Collection
	model: Vote
# Votes

class CardView extends Backbone.View
	tagName: "div", 
	className: "card" ,
	text: _.template( "<p class='card-contents'><%= content %></p>" ),
	image: _.template( "<img src='<%= image %>' class='img-circle img-card' />" ),
	parent: $("body") ,
	has_image: false ,
	events:
		"click": "interact" ,
		"mouseenter": "swap2img", 
		"mouseleave": "swap2txt"
	, # events
	render: (container)->
		unless @model?
			throw "Calling View Without a Model Error"
			return this
		@parent = container if container?
		@has_image = @model.has "image"
		$(@el).append @text(@model.toJSON()) 
		$(@el).attr "class", "card #{@model.get('category')}-card"
		@parent.append $(@el)
		if @has_image
			$(@el).append @image(@model.toJSON())
			@$("img").hide()
	, # render
	interact: ->
		Backbone.Events.trigger "card:white", @model
		return false
	, # interact
	swap2txt: ->
		if @has_image
			@$("p").show()
			@$("img").hide()
		return false
	, # swap2txt
	swap2img: ->
		if @has_image
			@$("img").show()
			@$("p").hide()
		return false
	, # swap2img
# CardView

class Flash extends Backbone.View
	@container: ( ->
		$("body").append("<ul id='flash-container' class='flash-container'></ul>")
		return $("#flash-container")
	)() , # staticInitializer
	@show: (content, color) ->
		data = { 
			content: content ,
			color: if color then color else "info"
		} # data
		(new Flash()).render(data)
	, # static show
	tagName: "li" ,
	className: "alert alert-block" ,
	events: 
		"mouseover .alert": "diffusify" ,
		"mouseleave .alert": "focusify"
	, # events
	render: (data) ->
		$(@el).attr "class", "#{@className} alert-#{data['color']}" if data['color']?
		$(@el).html( data['content'] )
		Flash.container.append $(@el)
		setTimeout( ( (dom) -> 
			return ( -> 
				dom.$(dom.el).hide(1000)
				dom.remove() 
			) # return
		)(this), 5000 ) # setTimeout
		return this
	, # render
	diffusify: (e) ->
		$(@el).css "opacity", 0.5
	, # diffusify
	focusify: (e) ->
		$(@el).css "opacity", 1
	, # focusify
# Flash


class PlayerView extends Backbone.View
	tagName: "div", 
	className: "player" ,
	parent: $("body") ,
	render: ->
		$(@el).append(@template).appendTo @parent
		@container = $(@el)
	, # render
# PlayerView

class RoomView extends Backbone.View
	tagName: "div", 
	className: "room" ,
	parent: $("body") ,
	render: ->
		@parent.append $(@el)
	# render
# RoomView


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


# Initialization
socket = io.connect "http://localhost:3123"
apples_to_assholes = new Game socket
