###
# Tests for Card collections
###

describe "Cards", ->
	describe "Sanity test", ->
		it "should exist", ->
			expect(Cards).to.be.ok
	describe "Retrieve", ->
		it "should retrieve cards", ->
			cards = Cards.retrieve({category: "black", limit: 1})
			expect(cards.length).to.equal 1
			