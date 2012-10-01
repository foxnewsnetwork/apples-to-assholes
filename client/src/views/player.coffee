class PlayerView extends Backbone.View
	tagName: "div", 
	className: "player" ,
	parent: $("body") ,
	render: ->
		$(@el).append(@template).appendTo @parent
		@container = $(@el)
	, # render
# PlayerView