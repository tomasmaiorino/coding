class Move

	attr_accessor :circle, :tower, :next_circle, :next_tower
  	
  	def initialize(circle, tower, next_circle = nil, next_tower = nil)
		@circle = circle
		@tower = tower
		@next_circle = next_circle
		@next_tower = next_tower
	end
end