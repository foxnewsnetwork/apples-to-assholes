###
# Channels Spec
###
describe "Channels Collection", ->
	describe "Sanity test", ->
		it "should be ok", ->
			expect(Channels).to.be.ok
	# sanity
	describe "functionality", ->
		channels = new Channels()
		it "should be ok", ->
			expect(channels).to.be.ok
		it "should let me get to a channel", ->
			expect(channels.length).to.equal 0
			channel = channels.retrieve "test-chan"
			expect(channels.length).to.equal 1
		it "should be the right channel", ->
			channel = channels.retrieve "test-chan"
			expect(channel).to.be.ok
			expect(channel.name).to.equal "test-chan"
			expect(channel.count).to.equal 0
	# functionality
# Channels Collection
