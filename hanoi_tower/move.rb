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

  #tested
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
    parsed_content = parsed_move.split(ConstClass::MOVE_SEPARATOR)
    move = parsed_content[0]
    circle = parsed_content[1]
    next_tower = parsed_content[2]
    next_circle = parsed_content[3]

    @circle = @tower = @next_circle = @next_tower = nil

    @circle = game.get_game_circle_by_size(circle.to_i) unless circle.nil? || circle.empty?
    @tower = game.towers[tower.to_i] unless tower.nil? || tower.empty?
    @next_circle = game.get_game_circle_by_size(next_circle.to_i) unless next_circle.nil? || next_circle.empty?
    @next_tower = game.towers[next_tower.to_i] unless next_tower.nil? || next_tower.empty?

  end

  def load_full_game(parsed_full_game)
    if game.nil?
      game = NewGame.new
    end
    #separate the move content from game content
    parsed_game = parsed_full_game.split(ConstClass::MOVE_GAME_SEPARATOR)
    #load game
    game = game.load_game_from_parsed(parsed_game[0])
    #load move
    load_move(parsed_game[1])
  end

  def parse_full_game
    parse_move = parsed_move
    if !parse_move.nil? && !parse_move.empty?
      parse_move << ConstClass::MOVE_GAME_SEPARATOR
      parse_move << game.parse_game
      return parse_move
    end
  end

end