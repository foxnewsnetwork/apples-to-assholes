
class CardView extends Backbone.View
	tagName: "div", 
	className: "card" ,
	text: _.template( "<p class='card-contents'><%= content %></p>" ),
	image: _.template( "<img src='<%= image %>' class='img-circle img-card' />" ),
	container: $("body") ,
	has_image: false ,
	events:
		"click": "interact" ,
		"mouseenter": "swap2img", 
		"mouseleave": "swap2txt"
	, # events
	render: ->
		unless @model?
			throw "Calling View Without a Model Error"
			return this
		@has_image = @model.has "image"
		$(@el).append @text(@model.toJSON()) 
		$(@el).attr "class", "card #{@model.get('category')}-card"
		@container.append $(@el)
		if @has_image
			$(@el).append @image(@model.toJSON())
			@$("img").hide()
	, # render
	interact: ->
		# You should overwrite this as a callback
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