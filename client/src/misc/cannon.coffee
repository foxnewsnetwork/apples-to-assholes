# The event cannon sets up backbone events
# origination, destination are strings designating cannon range
# their values are, so far: local, global, galatic
# local events don't travel up to the server
# global events are echoed to everyone else in your room
# galatic events are echoed to everyone everywhere in the galaxy
# future support might allow for an array of socketid targets

socket.on "backbone event down", (eventname, data) ->
	# We force events that come down from the server to be considered
	# local, that way we don't end up in infinite communication loops
	if data?
		data = _.extend(data, {"local": true})
	else
		data = {"local": true}
	Backbone.Events.trigger "#{eventname}", data
# backbone event down
Backbone.Events.on "all", (eventname)->
	rest = (new Array).slice.call(arguments, 1)
	if rest['local']
		return false
	socketid = socket.id or null
	data = {
		"socketid": socketid ,
		"data": rest
	} # data
	socket.emit "backbone event up", data
# all events 