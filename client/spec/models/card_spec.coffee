describe "Card Model", ->
	describe "Sanity test", ->
		it "should exist", ->
			expect(Card).to.be.ok
	# sanity test
	describe "Card Count", ->
		it "have some counts", (done) ->
			setTimeout( ->
				expect(Card.count > 0).to.equal true
				done()
			, 1950)
# Card Model