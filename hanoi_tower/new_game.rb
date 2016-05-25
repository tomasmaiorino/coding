require_relative 'move'

class NewGame

	attr_accessor :actual_move, :towers, :game_circles

  	def initialize
		@game_circles = []
		@towers = {}
		@actual_move = 0
	end

	#ok
	def load_towers(towers)
		for i in 0..towers - 1
	 		@towers[i +1] = Tower.new(i + 1, towers)
		end
		@towers = Hash[@towers.sort_by{|k, v| v.id}]
		return @towers
	end

	#ok
	def load_game(circles, towers)
		@towers = load_towers(towers)
		for i in 0..circles - 1
		  @game_circles << Circle.new(i + 1, @towers[1], nil)
		end
		#order circles
		#@circles.sort {|left, right| left.size <=> right.size}
			#add the circles into the initial tower
			@game_circles.each{|v|
				v.actual_tower = @towers[1]
				@towers[1].tower_circles << v
			}
		circles_ret = @game_circles.sort! { |a,b| b.size <=> a.size }
		return circles_ret
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
			move = new Move(destiny_tower, game_circles[game_circles.size - 1], nil, nil, self)
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
					if !empty_towers.empty? && towers.empty?
						#configure the move and return it
						move = new Move(empty_towers[empty_towers.size - 1], c)
						return move
					elsif empty_towers.empty? && !towers.empty?
						move = get_next_tower_with_closest_circle(get_all_towers_available, c)
						tower_temp = get_next_tower_with_closest_circle get_availables_circles, c
						if !move.next_tower.nil? && move.next_tower.id == tower_temp.id
							move.next_tower = nil
							move.next_circle = nil
						elsif
						end
							
					else
						move = get_next_tower_with_closest_circle(get_all_towers_available, c)
					end	

					return move
				}
		end
	end

	#ok
	def get_next_move(c, circles)
		actual_tower = c.actual_tower
		move = nil
		if actual_tower.tower_circles.size > 1
			get_all_towers_available.each {|t_2|
			if  !t_2.get_top_circle.nil? && actual_tower.tower_circles[actual_tower.tower_circles.size - 2].size == t_2.get_top_circle.size - 1
				move = Move.new(nil, nil, t_2, actual_tower.tower_circles[actual_tower.tower_circles.size - 2], self)
				return move
			end
			}
		end
		return move
	end

	#ok
	def get_next_tower_with_closest_circle(p_towers, circle)
		new_towers = []
		towers = []

		return towers if  p_towers.empty? || circle.nil?

		if !p_towers.kind_of?(Array)
			p_towers.each{|key, value|
				new_towers << value
			}
		end

		new_towers = p_towers if p_towers.kind_of?(Array)
				
		new_towers.each{|t|
			if !t.get_top_circle.nil? && t.get_top_circle.size > circle.size
				towers << t
			end
		}

		towers.sort! { |a, b|
			a.get_top_circle.size <=> b.get_top_circle.size
		}

		return towers
	end

	#ok
	def get_all_towers_available
     	towers = []
     	@towers.each {|key, value|
        	towers << value
     	}
    	return towers
 	end

 	#ok
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

	#ok
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
		# 1 - the destiny tower has the biggest game circle
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

	#ok
	def get_availables_circles
		circles = do_get_availables_circles(true)
		if circles.empty?
			circles = do_get_availables_circles(false)
		end
		return circles.sort {|a,b| a.size <=> b.size}
	end

	#ok
	def get_towers_available_from_circle(p_towers, circle)
		towers = []
		if p_towers.kind_of?(Array)		
			p_towers.each{ |t|
				if !t.tower_circles.empty?
					towers << t if t.get_top_circle.size > circle.size
				end
			}
		else
			p_towers.each{|key, value|
				if !value.tower_circles.empty?
					towers << value if value.get_top_circle.size > circle.size
				end
			}
		end
		if !towers.empty?
			towers = towers.sort! { |a, b|
				b.get_top_circle.size <=> a.get_top_circle.size
			}
		end
		return towers
	end

	#ok
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

	#ok
	def treat_destiny_towers(towers, circles)
		destiny_tower = get_destiny_tower towers
		if !destiny_tower.nil?
			temp_circle = contains_circles_by_size circles, @game_circles[0].size
			if destiny_tower.tower_circles.empty? && !temp_circle.nil?
				move = Move.new(destiny_tower, temp_circle, nil, nil, nil)
				return move
			else
				if !destiny_tower.tower_circles.empty?
					next_size = destiny_tower.get_top_circle.size - 1
					circle = contains_circles_by_size circles, next_size
					if !circle.nil?
						move = Move.new(destiny_tower, circle, nil, nil, self)
						return move
						#destiny_tower.change_circle circle
						#is_circle_changed = true
						#new_move if move
					end
				end
			end
		end
		return nil
	end

	#ok
	def contains_circles_by_size(circles, size)
		ind = circles.index{|v| v.size == size}
		return circles[ind] if ind != nil
	end

	#ok
	def get_all_top_circles
		circles = []
		@towers.each {|key, value|
			circles << value.get_top_circle if !value.tower_circles.empty?
		}
		return circles
	end

end