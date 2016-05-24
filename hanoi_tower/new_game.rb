class NewGame

	attr_accessor :actual_move, :towers, :game_circles
  	
		@game_circles = []
		@towers = {}
		@actual_move = 0
	end

	def move(move)
		#check if there is another move to make
		if move.has_next_move
			#does the move
			move.does_move
		end
		#check if the game is finished
		if !finished
			#get the new move
			move = get_move
		end
		#does the move
		move.does_move

		#configure the move to be showed at the view layer
		move.parsed_move = parse_move(move)
		#return the move
		return move
	end

	def get_move
		move = nil
		if Circle.moves_count == 0
			destiny_tower = get_destiny_tower get_all_towers_available
			#destiny_tower.change_circle game_circles[game_circles.size - 1]
			move = new Move(destiny_tower, game_circles[game_circles.size - 1], self)
			return move
		end
		circles = get_availables_circles
		if !circles.empty?
				circles.each {|c|
					# gel all avalailable towers from all game circles and the actual circle
					towers = get_towers_available_from_circle get_all_towers_available, c
					# retrieve all empty towers
					empty_towers = get_all_tower_with_empty_circles(get_all_towers_available, true)
					towers_temp_one = []

					towers.each{ |t|
						towers_temp_one << t
					}
					empty_towers.each{ |t|
						towers_temp_one << t
					}					
					move = treat_destiny_towers towers_temp_one, circles, true
					return move unless move.nil?
					#get the last tower as destination tower
					if !empty_towers.empty? && !towers.empty?
						#configure the move and return it
						move = new Move(empty_towers[empty_towers.size - 1], c)
						return move
					elsif empty_towers.empty? && towers.empty?
						move = get_move_from_towers(empty_towers. towers, c)
					else
						move = get_move_from_towers(empty_towers. towers, c)
					end
					return move
				}
		end

	end

end