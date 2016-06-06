require_relative 'move'
require_relative 'const_class'

class NewGame

	attr_accessor :actual_move, :towers, :game_circles

  	def initialize
		@game_circles = []
		@towers = {}
		@actual_move = 0
	end

	#tested
	def load_towers(towers)
		for i in 0..towers - 1
	 		@towers[i +1] = Tower.new(i + 1, towers)
		end
		@towers = Hash[@towers.sort_by{|k, v| v.id}]
		return @towers
	end

	#tested
	def load_game_from_parsed(parsed_game)
		towers = load_towers_from_parsed_game(parsed_game)
		@towers = towers
		get_game_circles(towers)
	end

	#tested
	def get_game_circles(towers)
		circles = []
		towers.each{|key, value|
			if !value.tower_circles.empty?
				value.tower_circles.each{|c|
					circles << c.clone
				}
			end
		}
		@game_circles = circles.sort { |a,b| b.size <=> a.size }
	end

	#tested
	def load_towers_from_parsed_game(parsed_game)
		towers_ret = {}
		towers = parsed_game.split(ConstClass::TOWER_SEPARATOR)
		game_count = parsed_game.split('@')
		towers.each{|t|
			tower_content = t.split(ConstClass::TOWER_CIRCLE_SEPARATOR)
			tower_content[1] = tower_content[1].sub(/@[\d]/, '')
			tower = Tower.new(tower_content[0].to_i, towers.size.to_i)
			tower.tower_circles = []
			tower.tower_circles = load_circles(tower_content[1], tower)
			towers_ret[tower_content[0].to_i] = tower
		}
		return towers_ret
	end

	#tested
	def load_circles(parsed_circles, tower)
		circles = []
		return [] if parsed_circles == ConstClass::DEFAULT_PARSED_CIRCLE
		parsed_circles = parsed_circles.split(ConstClass::CIRCLES_SEPARATOR)
		parsed_circles.each{|c|
			if c.to_i > 0
				circle_content = c.split(ConstClass::CIRCLES_CONTENT_SEPARATOR)
				circle = Circle.new(circle_content[0].to_i, tower, nil)
				circle.circle_move_count = circle_content[1].to_i
				circle.circle_last_move = circle_content[2].to_i
				circles << circle
			end
		}
		return circles
	end

	#tested
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

	#tested
	def move(move)
		#check if the game is finished
		if finished
			move = Move.new(nil, nil, nil, nil, self) if move.nil?
			move.moves_count = Circle.moves_count
			return move
		end
		if !move.nil?
			#treat the game's move
			if !move.tower.nil? && !move.circle.nil?
				move.does_move
			end
			if !move.next_tower.nil? && !move.next_circle.nil?
				move.does_next_move
			end
			#check if the game is finished
			if finished
				move.moves_count = Circle.moves_count
				return move
			end
		end
		#if the game isnot over, get next move
		move = nil
		move = get_move
		#configure the move to be showed at the view layer
		#move.parsed_move = parse_move(move)
		return move
	end

	#tested
	def get_move
		move = nil
		if Circle.moves_count == 0
			destiny_tower = get_destiny_tower get_all_towers_available
			move = Move.new(destiny_tower, game_circles[game_circles.size - 1], nil, nil, self)
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
					move = treat_destiny_towers towers_temp_one, circles
					return move unless move.nil?
					#get the last tower as destination tower
					if !empty_towers.empty? && towers.empty?
						#configure the move and return it					
						move = Move.new(empty_towers[0], c, nil, nil, self)
						break
					elsif empty_towers.empty? && !towers.empty?
						move = get_next_move(c, circles, get_all_towers_available)
						tower_temp = get_next_tower_with_closest_circle get_all_towers_available, c
						if !move.nil? && move.has_next_move && !tower_temp.nil? && !tower_temp.empty?
							move = treat_next_move_conflict(move, tower_temp,c)
							break
						else
							move = Move.new(tower_temp[0], c, nil, nil, self)
							break
						end
					else
						tower_temp = get_next_tower_with_closest_circle(get_all_towers_available, c)
						tower_temp.concat(empty_towers)
						move = get_next_move(c, circles, get_all_towers_available)						

						if !move.nil? && move.has_next_move && !tower_temp.nil? && !tower_temp.empty?
							move = treat_next_move_conflict(move, tower_temp,c)
							break
						else
							move = Move.new(tower_temp[0], c, nil, nil, self)
							break
						end
					end
				}
		end
		return move
	end

	#tested
	def treat_next_move_conflict(move, towers_temp, c, has_emptY_towers = nil)		
		if towers_temp.size == 1
			if move.next_tower.id == towers_temp[0].id
				move.tower = move.next_tower
				move.circle = move.next_circle
				move.next_tower = nil
				move.next_circle = nil
				return move
			end
		else
			towers_temp.each{|t|
				if t.id != move.next_tower.id
					move.circle = c
					move.tower = t
					return move
				end
			}
		end
	end

	#tested
	def get_next_move(c, circles, ignore_empty = nil)
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
		if move.nil? && !ignore_empty.nil? && !ignore_empty
			get_all_towers_available.each {|t_2|
			if  t_2.tower_circles.empty?
				move = Move.new(nil, nil, t_2, actual_tower.tower_circles[actual_tower.tower_circles.size - 2], self)
				return move
			end
			}
		end
		return move
	end

	#tested
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

	#tested
	def get_all_towers_available
     	towers = []
     	@towers.each {|key, value|
        	towers << value
     	}
    	return towers
 	end

 	#tested
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

	#tested
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

	#tested
	def get_availables_circles
		circles = do_get_availables_circles(true)
		if circles.empty?
			circles = do_get_availables_circles(false)
		end
		return circles.sort {|a,b| a.size <=> b.size}
	end

	#tested
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

	#tested
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

	#tested
	def treat_destiny_towers(towers, circles)
		destiny_tower = get_destiny_tower towers
		if !destiny_tower.nil?
			temp_circle = contains_circles_by_size circles, @game_circles[0].size
			if destiny_tower.tower_circles.empty? && !temp_circle.nil?
				move = Move.new(destiny_tower, temp_circle, nil, nil, self)
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

	#tested
	def contains_circles_by_size(circles, size)
		ind = circles.index{|v| v.size == size}
		return circles[ind] if ind != nil
	end

	#tested
	def get_all_top_circles
		circles = []
		@towers.each {|key, value|
			circles << value.get_top_circle if !value.tower_circles.empty?
		}
		return circles
	end

	#tested
	def finished
		# retrieve the destiny tower
		destiny_tower = get_destiny_tower get_all_towers_available
		finished = false
		if !destiny_tower.nil? && !destiny_tower.tower_circles.empty? && destiny_tower.tower_circles.size == @game_circles.size
			is_ordered = true
			destiny_tower.tower_circles.each_with_index{ |v, i|
				if (i < destiny_tower.tower_circles.size - 1)
					if (v.size - 1 != destiny_tower.tower_circles[i + 1].size)
						is_ordered = false
					end
				end
			}
			finished = is_ordered
		end
		return finished
	end

	#tested
	def parse_game		
		parsed_value = ''
		towers.each {|key, value|
			if key > 1
				parsed_value << ConstClass::TOWER_SEPARATOR
			end
			parsed_value << value.id.to_s
			parsed_value << ConstClass::TOWER_CIRCLE_SEPARATOR
			parsed_value << parse_circles(value.tower_circles)
		}
		parsed_value << '@' + Circle.moves_count.to_s
		return parsed_value
	end

	#tested
	def parse_circles(circles)
		parsed_value = ''
		return '0:0:0' if circles.nil? || circles.empty?
		circles.each_with_index{|c, i|
			if i > 0
				parsed_value << ConstClass::CIRCLES_SEPARATOR
			end
			circle = c.size.to_s << ConstClass::CIRCLES_CONTENT_SEPARATOR << c.circle_move_count.to_s << ConstClass::CIRCLES_CONTENT_SEPARATOR
			parsed_value << circle
			parsed_value << c.circle_last_move.to_s
			
		}
		return parsed_value
	end

	#tested
	def get_game_circle_by_size(circle_size)
		i = @game_circles.index{|x| x.size == circle_size}
		return @game_circles[i]
	end

end