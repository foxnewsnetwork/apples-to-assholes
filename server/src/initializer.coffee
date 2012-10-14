###
# Initializers Live Here		
###

port = 3123
io = require("socket.io").listen(port)
Backbone = require "backbone"
_ = require "underscore"