# We might not use this and the model class
class Votes extends Backbone.Collection
	model: Vote ,
	remove: ->
		count = @length
		while @length > 0
			@pop().destroy()
		return count
	# refresh
# Votes