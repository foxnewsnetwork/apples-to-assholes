class Card extends Backbone.Model
	defaults:
		category: null ,
		content: null,
		image: null
	# defaults
	@random: (options) ->
		options = {"category": "white"} unless options?
		card = new Card("category": options["category"])
		switch options["category"]
			when "white"
				# Obviously, we need to load this from the server
				card["content"] = "Old wrinkly Dick"
				card["image"] = "http://upload.wikimedia.org/wikipedia/commons/thumb/8/88/46_Dick_Cheney_3x4.jpg/220px-46_Dick_Cheney_3x4.jpg"
			when "black"
				# Obviously, we need to load this from the server
				card["content"] = "Trevor thinks of _____________ every night before going to bed."
			else
				throw "Nonexistant category error"
		# switch
	# random
# Card