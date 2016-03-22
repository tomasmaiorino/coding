class Player

	attr_accessor :cards, :id, :points

	def initialize(cards, id, points = 0)
		@cards = cards
		@id = id
		@points = points
	end
end
