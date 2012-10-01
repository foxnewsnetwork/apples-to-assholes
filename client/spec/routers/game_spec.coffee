describe "Game Router", ->
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
		it "should properly be in a room", (done) ->
			setTimeout( => 
				expect(apples_to_assholes.room).to.be.ok
				done()
			, 1950)
		it "should have a hand", (done) ->
			setTimeout( => 
				expect(apples_to_assholes.room.player.cards.length).to.equal 10
				done()
			, 1950)
	# Actual Operation
# Game