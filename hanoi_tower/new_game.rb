class NewGame

	attr_accessor :actual_move, :towers, :game_circles  	
		@game_circles = []
		@towers = {}
		@actual_move = 0
	end

	def move(move)
		#check if there is another move to make
		if !move.nil? && move.has_next_move
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

	def get_all_towers_available
     	towers = []
     	@towers.each {|key, value|
        	towers << value
     	}
    	return towers
 	end

	def get_destiny_tower(towers)
		tower = nil
		if towers.kind_of?(Array)
			towers.each {|value|
				if value.is_destiny
					tower = value
					break
				end
			}
		else
			towers.each {|key, value|
				if value.is_destiny
					tower = value
					break
				end
			}
		end
		return tower
	end

	def do_get_availables_circles(ignore_last_moved)
		circles = []
		get_all_top_circles.each {|v|
			if ignore_last_moved
				circles << v if !v.last_moved
			else
				circles << v
			end
		}
		# remove the circles that are on the his final position
		destiny_tower = get_destiny_tower (@towers)
		ind_to_remove = []
		# 1 - the destiny tower must have biggest game circle
		if destiny_tower.tower_circles.index {|x| @game_circles[0].size == x.size} != nil
			#puts "has biggest at destiny_tower"
			circles.each_with_index{|c, i|
				#puts "circle size #{c.size}"
				# treat the biggest one circle
				if c.biggest_one(@game_circles[0])
						ind_to_remove << i
						next
				else
					if destiny_tower.tower_circles.index {|x| c.size == x.size} != nil
						if c.size + 1 == circles[i - 1].size
							ind_to_remove << i
							next
						end
					end
				end
			}
			# remove the circles
			if !ind_to_remove.empty?
				#puts "has items to remove: #{ind_to_remove}"
				ind_to_remove.each{|v| circles.delete_at(v)}
			end
		end
		return circles
	end

	def get_availables_circles
			circles = do_get_availables_circles(true)
			if circles.empty?
				circles = do_get_availables_circles(false)
			end
			return circles.sort {|a,b| a.size <=> b.size}
	end

	def get_towers_available_from_circle(p_towers, circle)
		towers = []
		p_towers.each{ |t|
			if !t.tower_circles.empty?
				towers << t if t.get_top_circle.size > circle.size
			end
		}
		if !towers.empty?
			towers = towers.sort! { |a, b|
				b.get_top_circle.size <=> a.get_top_circle.size
			}
		end
		return towers
	end

	def get_all_tower_with_empty_circles(towers, return_empty)
		towers_temp = []
		if towers.kind_of?(Array)
			towers.each {|value|
				if return_empty
					towers_temp << value if value.tower_circles.empty?
				else
					towers_temp << value if !value.tower_circles.empty?
				end
			}
		else
			towers.each {|key, value|
				if return_empty
					towers_temp << value if value.tower_circles.empty?
				else
					towers_temp << value if !value.tower_circles.empty?
				end
			}
		end
	return towers_temp
	end


	def treat_destiny_towers(towers, circles, move)
		is_circle_changed = false
		destiny_tower = get_destiny_tower towers
		if !destiny_tower.nil?
			temp_circle = contains_circles_by_size circles, @game_circles[0].size
			if destiny_tower.tower_circles.empty? && !temp_circle.nil?
				destiny_tower.change_circle temp_circle
				is_circle_changed = true
				new_move if move
			else
				if !destiny_tower.tower_circles.empty?
					next_size = destiny_tower.get_top_circle.size - 1
					circle = contains_circles_by_size circles, next_size
					if !circle.nil?
						destiny_tower.change_circle circle
						is_circle_changed = true
						new_move if move
					end
				end
			end
		end
		return is_circle_changed
	end

	def contains_circles_by_size(circles, size)
		ind = circles.index{|v| v.size == size}
		return circles[ind] if ind != nil
	end	

end