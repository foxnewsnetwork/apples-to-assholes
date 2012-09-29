
describe "Rooms Collection", ->
	describe "Sanity Test", ->
		it "should not be null", ->
			expect(Rooms).to.be.ok
	# sanity test
	describe "rooms", ->
		rooms = new Rooms()
		it "should create a collection", ->
			expect(rooms).to.be.ok
			expect(rooms.length).to.equal 0
		it "should create a room", ->
			rooms.retrieve("test room")
			expect(rooms.length).to.equal 1
	# rooms
# Rooms