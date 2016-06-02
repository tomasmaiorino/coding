class Move

	attr_accessor :tower,:circle, :next_tower, :next_circle, :game, :parsed_move, :moves_count, :parsed_game
  	
  	def initialize(tower = nil, circle = nil, next_tower = nil, next_circle = nil, game = nil)
  		@tower = tower
  		@circle = circle
  		@game = game
  		@parsed_move = ''
  		@next_circle = next_circle
  		@next_tower = next_tower
      @moves_count = nil
      @parsed_game = nil
	end

  #tested
  def parsed_game
    parsed_game = game.parse_game unless game.nil?
  end

  #tested
  def has_next_move
    !@next_tower.nil?
  end

  #tested
  def does_move
    @tower.change_circle @circle
  end

  #tested
  def does_next_move
    @next_tower.change_circle @next_circle
  end

  def parsed_move
    parsed_move = ''
    parsed_move << (if tower.nil? then '' else tower.id.to_s end)
    parsed_move << ConstClass::MOVE_SEPARATOR
    parsed_move << (if circle.nil? then '' else circle.size.to_s end)
    parsed_move << ConstClass::MOVE_SEPARATOR
    parsed_move << (if next_tower.nil? then '' else next_tower.id.to_s end)
    parsed_move << ConstClass::MOVE_SEPARATOR
    parsed_move << (if next_circle.nil? then '' else next_circle.size.to_s end)
  end

  def load_move(parsed_move)
    parsed_content = parsed_content.split(ConstClass::MOVE_SEPARATOR)

  end

end