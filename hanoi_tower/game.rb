class Game

	attr_accessor :actual_move, :towers, :game_circles
  def initialize
    @game_circles = []
    @towers = {}
    @actual_move = 0
  end

  def load_towers(towers)
    for i in 0..towers - 1
      @towers[i +1] = Tower.new(i + 1, towers)
    end
    @towers = Hash[@towers.sort_by{|k, v| v.id}]
    return @towers
  end

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

  def get_next_empty_tower(towers)
    towers.each {|key, value|
      return value if value.tower_circles.empty?
    }
		return nil
  end

	def get_next_circles_available_to_move
		circles = []
		if Circle.moves_count == 0
			circles << game_circles[game_circles.size - 1]
			return circles
		end
		get_all_top_circles.each {|v|
				circles << v if !v.last_moved
		}
		return circles.sort {|a,b| a.size <=> b.size}
	end

	def remove_circles_at_final_position(circles)
		new_circles = []
		circles.each_with_index {|c, i|
				if c.actual_tower.is_destiny
					# skip in order to ignore the biggest one at the destiny tower
					# which means that this is it final position
					next if c.bigger_one(@game_circles[0])
					if c.actual_tower.tower_circles.size > 1
						actual_circle_ind = c.actual_tower.tower_circles.index { |x| x.size == c.size }
						next if c.size + 1 == c.actual_tower.tower_circles[actual_circle_ind - 1].size
					end
					new_circles << c
				else
					new_circles << c
				end
		}
		return new_circles
	end

	def move
		puts "Move count: #{Circle.moves_count}"
		if !finished
			circles = get_next_circles_available_to_move
			circles = remove_circles_at_final_position circles
			puts "circles to move #{circles.size}"
			if !circles.nil?
				circles.each{|c|
					@towers.each {|key, value|
						if c.bigger_one(@game_circles[0]) && value.is_destiny && value.tower_circles.empty?
									value.change_circle(c)
									move
						elsif value.is_destiny
							if !value.tower_circles.empty? && c.size == value.get_top_circle.size + 1
									value.change_circle(c)
									move
							end
						end
						# configure all availables towers
						towers_2 = configure_tower(get_all_towers_available, c)
						#puts "towers_2 #{towers_2}"
						if !contain_empty_towers(towers_2)
							tower_temp = nil
							if towers_2.size > 1
								# get the tower with the smallest circle
								tower_temp = get_towers_with_smaller_circles(towers_2).actual_tower
							else
								tower_temp = towers_2[0]
							end
							tower_temp.change_circle(c)
							move
						else
							if contain_only_empty_towers towers_2
								towers_2[0].change_circle c
								move
							end
							tower_temp = nil
							if Circle.moves_count == 0
								tower_temp = towers_2[0]
							else
								tower_temp = get_towers_with_smaller_circles(towers_2).actual_tower
							end
							new_tower_temp = Tower.new(1, 1)
							# concat the smallest tower circles
							new_tower_temp.tower_circles.concat tower_temp.tower_circles
							new_tower_temp.tower_circles << c
							if is_all_games_circles_ordered new_tower_temp
								towers_2.each{|t3|
									if t3.tower_circles.empty?
										t3.change_circle c
										move
									end
								}
							else
								towers_2[0].change_circle c
								move
							end
						end
					}
				}
			end
		else
			puts "finished "
			puts "tower 3 #{@towers[3].print_tower}"
			abort("end")
		end
	end

	def configure_tower(p_towers, circle)
		towers = []
		empty_towers = []
		if Circle.moves_count == 0
			return get_towers_but_one(circle.actual_tower)
		end
		p_towers.each{ |t|
			if !t.tower_circles.empty?
				if t.get_top_circle.size > circle.size
					towers << t
				end
			else
				empty_towers << t
			end
		}
		if !towers.empty?
			towers = towers.sort! { |a,b|
				b.get_top_circle.size <=> a.get_top_circle.size
			}
		end
		towers.concat empty_towers unless empty_towers.empty?
		return towers
	end

	def get_circle_from_circles_by_size(circles, size)
		if !circles.nil? && !circles.empty?
			circles.each { |e|
				return e if e.size == size
		  }
		end
		return nil
	end

	def finished
		# retrieve the destiny tower
		destiny_tower = nil
		@towers.each {|key, value|
      if value.is_destiny
				destiny_tower = value
				break
			end
    }
		finished = true
		if !destiny_tower.tower_circles.nil? && !destiny_tower.tower_circles.empty? && destiny_tower.tower_circles.size == @game_circles.size
			destiny_tower.tower_circles.each_with_index{|v, i|
				if i < destiny_tower.tower_circles.size - 1
					if v.size - 1 != destiny_tower.tower_circles[i + 1].size
						finished = false
					end
				end
			}
		else
			finished = false
		end
		return finished
	end

	def get_all_top_circles
		circles = []
		@towers.each {|key, value|
				circles << value.get_top_circle if !value.tower_circles.empty?
		}
		return circles
	end

	def get_all_towers_available
		towers = []
		@towers.each {|key, value|
					towers << value
		}
		return towers
	end

	def get_towers_with_smaller_circles(towers)
		smaller_circle = nil
		towers.each {|value|
			if !value.tower_circles.empty?
				if smaller_circle.nil?
					smaller_circle = value.get_top_circle
					next
				else
					if value.get_top_circle.size < smaller_circle.size
						smaller_circle = value.get_top_circle
						next
					end
				end
			end
		}
		return smaller_circle
	end

	def contain_empty_towers(towers)
		contain_empty = false
		 if towers.kind_of?(Array)
			 towers.each {|value|
					 contain_empty = value.tower_circles.empty?
					 return 	contain_empty if contain_empty
			 }
		 else
			 towers.each {|key, value|
					 contain_empty = value.tower_circles.empty?
					 return 	contain_empty if contain_empty
			 }
		 end
		return contain_empty
	end

	def contain_only_empty_towers(towers)
		contain_only_empty = true
		towers_temp = []
		 if towers.kind_of?(Array)
			 towers.each {|value|
				 towers_temp << value
			 }
		 else
			 towers.each {|key, value|
				  towers_temp << value
			 }
		 end
			 towers_temp.each {|v|
				 if !v.tower_circles.empty?
					 contain_only_empty = false
				 end
			 }
		return contain_only_empty
	end

	def is_all_games_circles_ordered(tower)
		return false if tower.tower_circles.size != @game_circles.size
		finished = true
		tower.tower_circles.each_with_index{|v, i|
			if i < tower.tower_circles.size - 1
				if v.size - 1 != tower.tower_circles[i + 1].size
					finished = false
				end
			end
		}
		return true
	end

	def get_towers_but_one(tower)
		towers = []
		@towers.each {|key, value|
				towers << value if value.id != tower.id
		}
		return towers
	end
=begin
		def get_next_circle_to_move(p_circle = nil)
			circle = nil
			get_all_top_circles.each {|v|
				if !p_circle.nil?
					return v if v.never_played && p_circle.size != v.size
				else
					return v if v.never_played
				end
				if !v.last_moved
					if circle.nil?
						circle = v
						next
					elsif v.size > circle.size
						if p_circle.nil? || (p_circle != nil && p_circle.size != v.size)
							circle = v
						end
					end
				end
			}
			return circle
		end
=end

end
