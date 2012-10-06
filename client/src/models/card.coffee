class Card extends Backbone.Model
	@count: 0 ,
	in_play: false ,
	defaults:
		category: null ,
		content: null,
		image: null,
		socketid: null,
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
		@view = new CardView({"model": this})
	, # initialize
	move_to: (target) ->
		@view.remove()
		@view = new CardView({"model":this})
		@view.render target
	, # move_in
	render: (container) ->
		@view.render container
	, # render
	remove: ->
		@view.remove()
		@destroy({silent: true})
	, # remove
# Card