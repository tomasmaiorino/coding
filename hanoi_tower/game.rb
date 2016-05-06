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

	def get_all_towers_available
     towers = []
     @towers.each {|key, value|
        towers << value
     }
     return towers
 end

 def move (finished)

 	if !finished
 		return Circle.moves_count
 	else
 		move(finished)
 	end

 	
 end

	def new_move
		v_finished = finished
		if v_finished
			puts "--------- FINISHED -----------"
			puts "TOTAL MOVEMENTS: #{Circle.moves_count}"
			destiny_tower = get_destiny_tower(@towers)
			puts "Tower #{destiny_tower.id}"
			destiny_tower.tower_circles.each_with_index{| c, i|
				print	"Circle #{c.size} "
			}
			puts ""
			puts "------------------------------"
			return Circle.moves_count
		else		
			#puts "Move count: #{Circle.moves_count}"
			#first move
			if Circle.moves_count == 0
					destiny_tower = get_destiny_tower get_all_towers_available
					destiny_tower.change_circle game_circles[game_circles.size - 1]
					new_move
			end
			if !v_finished
				circles = get_availables_circles
				if !circles.empty?
					circles.each {|c|
						if Circle.moves_count > 10
							circles.each{|c_2|
								if c_2.never_played
									c = c_2
									break
								end
							}
						end
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
						treat_destiny_towers towers_temp_one, circles, true

						if finished
							return Circle.moves_count
						end

						if !empty_towers.empty? && towers.empty?
							empty_towers[0].change_circle c
							new_move
						elsif empty_towers.empty? && !towers.empty?
								new_towers =  towers.sort! { |a, b|
									a.get_top_circle.size <=> b.get_top_circle.size
								}
								new_towers[0].change_circle c
								new_move
						else
							if c.actual_tower.tower_circles.size > 1 #1
								actual_tower = c.actual_tower
								destiny_tower = get_destiny_tower get_all_towers_available
								if !destiny_tower.nil? && !destiny_tower.tower_circles.empty?
									if actual_tower.tower_circles[actual_tower.tower_circles.size - 2].size == destiny_tower.get_top_circle.size - 1
										empty_towers[0].change_circle c
										destiny_tower.change_circle actual_tower.get_top_circle
										new_move
									end	
								end							
							else #else 1
								if !get_destiny_tower(towers).nil?
									empty_towers[0].change_circle c
									new_move
								else
									new_towers =  towers.sort! { |a, b|
										a.get_top_circle.size <=> b.get_top_circle.size
									}
									new_towers[0].change_circle c
									new_move
								end
							end #end 1
								new_towers =  towers.sort! { |a, b|
									a.get_top_circle.size <=> b.get_top_circle.size
								}
								new_towers[0].change_circle c
								new_move
						end
					}
				end
			end
		end
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
		destiny_tower = get_destiny_tower get_all_towers_available
		finished = false
		if !destiny_tower.tower_circles.empty? && destiny_tower.tower_circles.size == @game_circles.size
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

	def get_all_top_circles
		circles = []
		@towers.each {|key, value|
				circles << value.get_top_circle if !value.tower_circles.empty?
		}
		return circles
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

	def get_towers_with_more_than_one_circles(towers)
		towers_temp = []
		if towers.kind_of?(Array)
			towers.each {|value|
				towers_temp << value if !value.tower_circles.empty? && value.tower_circles.size > 1
			}
		else
			towers.each {|key, value|
				towers_temp << value if !value.tower_circles.empty? && value.tower_circles.size > 1
			}
		end
		return towers_temp
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

	def get_circle_from_circles_by_size(circles, size)
		if !circles.nil? && !circles.empty?
			circles.each { |e|
				return e if e.size == size
		  }
		end
		return nil
	end

	#to_test
	def contains_circles_by_size(circles, size)
		ind = circles.index{|v| v.size == size}
		return circles[ind] if ind != nil
	end

	def treat_destiny_towers(towers, circles, move)
		destiny_tower = get_destiny_tower towers
		if !destiny_tower.nil?
			temp_circle = contains_circles_by_size circles, @game_circles[0].size
			if destiny_tower.tower_circles.empty? && !temp_circle.nil?
				destiny_tower.change_circle temp_circle
				new_move if move
			else
				if !destiny_tower.tower_circles.empty?
					next_size = destiny_tower.get_top_circle.size - 1
					circle = contains_circles_by_size circles, next_size
					if !circle.nil?
						destiny_tower.change_circle circle
						new_move if move
					end
				end
			end
		end
	end

end
