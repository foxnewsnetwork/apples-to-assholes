###
# Channel Spec
###
describe "Channel Model", ->
	describe "Sanity test", ->
		it "should be ok", ->
			expect(Channel).to.be.ok
	# Sanity
	describe "Joining", ->
		channel = new Channel("testing_channel")
		it "should be initially empty", ->
			expect(channel.count).to.equal 0
		it "should allow sockets to join", ->
			channel.join( "socketid" )
			expect(channel.count).to.equal 1
			expect(channel.master).to.equal "socketid"
		it "should allow someone else to join also", ->
			channel.join( "leaverid")
			expect(channel.count).to.equal 2
			expect(channel.users["leaverid"]).to.equal "leaverid"
		it "should let people leave", ->
			channel.leave( "leaverid" )
			expect(channel.count).to.equal 1
		it "should fallback the master to another person if the current master leaves", ->
			channel.join( "fillerid" )
			channel.leave( "socketid" )
			expect(channel.master).to.equal "fillerid"
	# Joining
# Channel Model