class RoomView extends Backbone.View
	tagName: "div", 
	className: "room" ,
	parent: $("body") ,
	render: ->
		@parent.append $(@el)
	# render
# RoomView