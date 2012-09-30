describe "Game", ->
	describe "Sanity Test", ->
		it "should have that thing", ->
			expect(Game).to.be.ok
		it "Should at least exist", ->
			expect(apples_to_assholes).to.be.ok
		it "Should have the proper globals", ->
			expect(io).to.be.ok
		it "should have socket enabled", ->
			expect(socket).to.be.ok
	# Sanity Test
	describe "Actual Operation", ->
		it "should have a proper id", (done)->
			setTimeout( =>
				expect(apples_to_assholes.socketid).to.equal(socket.id)
				done()
			, 1950) # timeout
	# Actual Operation
# Game