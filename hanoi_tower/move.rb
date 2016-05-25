class Move

	attr_accessor :tower,:circle, :next_tower, :next_circle, :game, :parsed_move
  	
  	def initialize(tower = nil, circle = nil, next_tower = nil, next_circle = nil, game = nil)
  		@tower = tower
  		@circle = circle
  		@game = game
  		@parsed_move = ''
  		@next_circle = next_circle
  		@next_tower = next_tower
	end


  #ok
  def has_next_move
    !@next_tower.nil?
  end

  #ok
  def does_move
    @tower.change_circle @circle
  end

  #ok
  def does_next_move
    @next_tower.change_circle @next_circle
  end

  def parse_move_to_response

  end

  def parse_move_from_request

  end
end