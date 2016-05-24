class Move

	attr_accessor :tower, :next_tower, :next_circle, :circle, :game, :parsed_move
  	
  	def initialize(tower = nil, circle = nil, game = nil, parsed_move = nil, next_tower = nil, next_circle = nil)
  		@tower = tower
  		@circle = circle
  		@game = game
  		@parsed_move = parsed_move
  		@next_circle = next_circle
  		@next_tower = next_tower
	end


end