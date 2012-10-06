class RoomView extends Backbone.View
	tagName: "div", 
	className: "room" ,
	parent: $("body") ,
	render: ->
		@parent.append "<div class='vote-counter'></div>"
		@parent.append $(@el)
		@update_score()
	, # render
	update_score: ->
		$(".vote-counter").html(@model.score)
	# update_score
# RoomView