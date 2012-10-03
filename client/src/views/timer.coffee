class Timer extends Backbone.View
	@setTimeout: (callback, time) ->
		setTimeout callback, time
		timer = new Timer()
		timer.render time
		return timer
	, # setTimeout
	tagName: "div", 
	className: "count-down-timer" ,
	timeLeft: null ,
	parent: $("body") ,
	render: (time) ->
		$(@el).html(time / 1000).appendTo @parent
		@timeLeft = time
		@countdown = setInterval( => 
			if @timeLeft > 0
				@timeLeft -= 1000
				$(@el).html(@timeLeft / 1000)
			else
				clearInterval @countdown
				$(@el).hide()
				$(@el).remove()
		, 1000 )
	# render
# Timer