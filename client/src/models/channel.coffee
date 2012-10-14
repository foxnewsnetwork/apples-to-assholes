
class Channel extends Backbone.Model
	defaults:
		"master": null ,
		"name": null ,
		"count": 0 ,
	, # defaults
	join: (socket) ->
		if @count == 0
			@set "master", socket, {silent: true}
		@count += 1
	, # join
	leave: (socket)->
		@count -= 1
		if @count is 0
			@destroy()
			delete Channels[@get "name"]
		if socket is @get("master")

	, # leave
	serialize: ->
		@toJSON()
	, # serialize

	initialize: ->
		_.extend(this, Backbone.Events)
	# initialize
# Channel