###
# Room "Model" Spec
###
describe "Room Model", ->
	describe "Sanity Test" , ->
		it "should not be null" , ->
			expect(Room).to.be.ok
	describe "initialization", ->
		beforeEach ->
			@room = new Room(
				"name": "test room" ,
				"start_vote": -> return false ,
				"announce_winner" : -> return false ,
				"pass_whites": (whites) -> return false ,
				"pass_blacks": (blacks) -> return false 
			) # new room
		afterEach ->
			@room.destroy()
		it "should work", ->
			expect(@room.get "name").to.equal "test room"
		it "should have 0 counter", ->
			expect(@room.counter).to.equal(0)
		it "should attempt to join a new game", ->
			@room.join()
			expect(@room.counter).to.equal 1