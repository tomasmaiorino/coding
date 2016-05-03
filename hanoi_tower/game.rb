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
					if c.biggest_one(@game_circles[0])
						puts "++++ circle ok #{c.size}"
						next
					end
					if c.actual_tower.tower_circles.size > 1
						biggest_circle = @game_circles[0]
						destiny_tower_circles = c.actual_tower.tower_circles
						#check if the destiny tower contains the biggest circle
						if destiny_tower_circles.index { |x| x.size == biggest_circle.size } != nil
							is_ordered = true
							destiny_tower_circles.each_with_index {|v, i|
								# check if is the last circle
								if (i < c.actual_tower.tower_circles.size - 1)
									if (v.size - 1 != destiny_tower_circles[i + 1].size)
										is_ordered = false
									end
								end
							}
						end
					end
					puts "is_ordered #{is_ordered}"
					if is_ordered
						if is_ordered && destiny_tower_circles.index { |x| x.size == c.size } != nil
							puts "++++ circle ok #{c.size}"
							next
						end
#						actual_circle_ind = c.actual_tower.tower_circles.index { |x| x.size == c.size }
#						next if c.size + 1 == c.actual_tower.tower_circles[actual_circle_ind - 1].size
					end
					new_circles << c
				else
					new_circles << c
				end
		}
		return new_circles
	end

	def get_all_towers_available
     towers = []
     @towers.each {|key, value|
                             towers << value
     }
     return towers
 end

	def new_move
		puts "Move count: #{Circle.moves_count}"
		while !finished
			circles = get_availables_circles
			if !circles.empty?
				circles.each {|c|
					towers = get_towers_available_from_circle get_all_towers_available, c
					#check first move
					if Circle.moves_count == 0
						empty_towers = get_all_tower_with_empty_circles(towers, true)
						destiny_tower = get_destiny_tower empty_towers
						if destiny_tower != nil
							destiny_tower.change_circle c
							new_move
						end
					end
					# treat the destiny tower
					treat_destiny_towers towers, circles
					# retrieve all empty towers
					empty_towers = get_all_tower_with_empty_circles(towers, true)

					destiny_tower = get_destiny_tower empty_towers
					if !destiny_tower.nil?
						destiny_tower_ind = empty_towers.index{|i| i.id == destiny_tower.id}
						not_destiny = nil
						towers.each{|n|
							if n.id != destiny_tower.id
								not_destiny = n
							end
						}
						if !not_destiny.nil?
								not_destiny.change_circle c
								new_move
						end
					else
						if !empty_towers.empty?
							others_towers_with_more_than_circle = get_towers_with_more_than_one_circles(towers_2)
							if !others_towers_with_more_than_circle.empty?
									others_towers_with_more_than_circle.each{|t|
										top_circle_ind = t.tower_circles.index {|x| x.size == c.size}
										if !top_circle_ind.nil? && !get_destiny_tower(towers).tower_circles.empty?
											if t.tower_circles[top_circle_ind - 1].size < get_destiny_tower.tower_circles.size
												empty_towers[0].change_circle c
												next
											end
										end
									}
							else
								new_towers = configure_tower towers, c
								if new_towers.empty?
									empty_towers[0].change_circle c
									new_move
								else
									new_towers[0].change_circle c
									new_move
								end
							end
						end
						destiny_tower = get_destiny_tower towers
					end
				}
			end
		end
	end



=begin
					others_towers = get_all_tower_with_empty_circles(towers_configured, false)
					#others_towers_with_more_than_circle = get_towers_with_more_than_one_circles(towers_configured)
					towers_2 = nil
					# 1 - start
					if !empty_towers.empty?
							if !towers_configured.empty?
								others_towers_with_more_than_circle = get_towers_with_more_than_one_circles(towers_configured)
								if !others_towers_with_more_than_circle.empty?
									others_towers_with_more_than_circle.each{|t|
										top_circle_ind = t.tower_circles.index {|x| x.size == c.size}
										if !top_circle_ind.nil? && !get_destiny_tower(towers).tower_circles.empty?
											if t.tower_circles[top_circle_ind - 1].size < get_destiny_tower.tower_circles.size
												empty_towers[0].change_circle c
												new_move
												#next
											end
										end
									}
									if towers_configured.size > 1
										# get the tower with the smallest circle
										tower_temp = get_towers_with_smaller_circles(towers_configured).actual_tower
									else
										tower_temp = towers_configured[0]
									end
									tower_temp.change_circle(c)
									#next
									new_move
								else
									empty_towers[0].change_circle c
								end

							else
								empty_towers[0].change_circle c
								new_move
							end
					else
						if !towers_configured.empty?
							if towers_configured.size > 1
								# get the tower with the smallest circle
								tower_temp = get_towers_with_smaller_circles(towers_configured).actual_tower
							else
								tower_temp = towers_configured[0]
							end
							tower_temp.change_circle(c)
							new_move
							#next
						end
					end
				}
			end
		end
	end
	=end
=begin
				towers = get_all_towers_available
				circles.each {|c|
					if Circle.moves_count == 0
						empty_towers = get_all_tower_with_empty_circles(towers, true)
						empty_towers[0].change_circle c
						next
					end
					destiny_tower = get_destiny_tower towers
					#checking destiny tower - start
					if !destiny_tower.nil?
						if destiny_tower.tower_circles.empty?
							if c.biggest_one(@game_circles[0])
								destiny_tower.change_circle c
								next
							end
						else
							if destiny_tower.get_top_circle.size - 1 == c.size
								destiny_tower.change_circle c
								next
							end
						end
					end
					#checking destiny tower - end
					empty_towers = get_all_tower_with_empty_circles(towers, true)
					towers_configured = get_towers_available_from_circle(towers, c)
					others_towers = get_all_tower_with_empty_circles(towers_configured, false)
					#others_towers_with_more_than_circle = get_towers_with_more_than_one_circles(towers_configured)
					towers_2 = nil
					if !empty_towers.empty?
						if !towers_configured.empty?
							others_towers_with_more_than_circle = get_towers_with_more_than_one_circles(towers_configured)
							if !others_towers_with_more_than_circle.empty?
								others_towers_with_more_than_circle.each{|t|
									top_circle_ind = t.tower_circles.index {|x| x.size == c.size}
									if !top_circle_ind.nil? && !get_destiny_tower(towers).tower_circles.empty?
										if t.tower_circles[top_circle_ind - 1].size < get_destiny_tower.tower_circles.size
											empty_towers[0].change_circle c
											next
										end
									end
								}
							end
							if towers_configured.size > 1
								# get the tower with the smallest circle
								tower_temp = get_towers_with_smaller_circles(towers_configured).actual_tower
							else
								tower_temp = towers_configured[0]
							end
							tower_temp.change_circle(c)
							next
						else
							empty_towers.change_circle[c]
							next
						end
					else
						if !towers_configured.empty?
							if towers_configured.size > 1
								# get the tower with the smallest circle
								tower_temp = get_towers_with_smaller_circles(towers_configured).actual_tower
							else
								tower_temp = towers_configured[0]
							end
							tower_temp.change_circle(c)
							next
						end
					end

=end
=begin
					puts "others_towers_with_more_than_circle #{others_towers_with_more_than_circle}"
					if !others_towers_with_more_than_circle.empty?
						puts "has more than one circle"
						if !empty_towers.empty
							#configure the towers
							towers_2 = get_towers_available_from_circle(others_towers_with_more_than_circle, c)
							towers_2.each {|t|
								#check if the available tower has more than one circle - start
								# if true, check if the circle above the top circle can fit at the destiny tower
							top_circle_ind = t.tower_circles.index {|x| x.size == c.size}
							if !top_circle_ind.nil? && !get_destiny_tower(towers).tower_circles.empty?
								if t.tower_circles[top_circle_ind - 1].size < get_destiny_tower.tower_circles.size
									empty_towers[0].change_circle c
									next
								end
							end
						}
					end
				else
					if !towers_configured.nil? && !towers_configured.empty?
						if towers_configured.size > 1
							# get the tower with the smallest circle
							tower_temp = get_towers_with_smaller_circles(towers_configured).actual_tower
						else
							tower_temp = towers_configured[0]
						end
						tower_temp.change_circle(c)
						next
					else
						empty_towers[0].change_circle c
						next
					end
				end
				}
=end

	def move
		puts "Move count: #{Circle.moves_count}"
		while !finished
			circles = get_next_circles_available_to_move
			circles = remove_circles_at_final_position circles
			puts "circles to move #{circles.size}"
			if !circles.nil?
				circles.each{|c|
					#check if the circle is at final place
					@towers.each {|key, value|
						if c.biggest_one(@game_circles[0]) && value.is_destiny && value.tower_circles.empty?
									value.change_circle(c)
									next
						elsif value.is_destiny
							if !value.tower_circles.empty? && c.size == value.get_top_circle.size + 1
									value.change_circle(c)
									next
							end
						end
					}
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
						next#move
					else
						if contain_only_empty_towers towers_2
							towers_2[0].change_circle c
							next#move
						end
						puts "dont contain only empty_towers"
						tower_temp = nil
						if Circle.moves_count == 0
							tower_temp = towers_2[0]
						else
							tower_temp = get_towers_with_smaller_circles(towers_2).actual_tower
						end

						if !@towers[3].get_top_circle.nil?
							if tower_temp.get_top_circle.size < @towers[3].get_top_circle.size
								puts "chosing empty tower over other"
								towers_2.each {|x|
									if x.tower_circles.empty?
										x.change_circle c
										next#move
									end
								}
							else
								tower_temp.change_circle c
								next
							end
						else
							tower_temp.change_circle c
							next
						end
					end
				}
			end
		end
			puts "finished "
			puts "tower 3 #{@towers[3].print_tower}"
			#abort("end")
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

=begin
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
=end
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

	def get_destiny_tower(towers)
		if towers.kind_of?(Array)
			towers.each {|value|
				return value if value.is_destiny
			}
		else
			towers.each {|key, value|
				 return value if value.is_destiny
			}
		end
	end

	def get_towers_but_one(tower)
		towers = []
		@towers.each {|key, value|
				towers << value if value.id != tower.id
		}
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
		if Circle.moves_count == 0
			return get_towers_but_one(circle.actual_tower)
		end
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
		if Circle.moves_count == 0
			circles << game_circles[game_circles.size - 1]
			return circles
		end
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
			puts "has biggest at destiny_tower"
			circles.each_with_index{|c, i|
				puts "circle size #{c.size}"
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
				puts "has items to remove: #{ind_to_remove}"
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

	#to test
	def treat_destiny_towers(towers, circles)
		destiny_tower = get_destiny_tower towers
		if !destiny_tower.nil?
			temp_circle = contains_circles_by_size circles, @game.game_circles[0].size
			if destiny_tower.tower_circles.empty? && !temp_circle.nil?
				destiny_tower.change_circle temp_circle
				move
			else
				if !destiny_tower.tower_circles.empty?
					next_size = destiny_tower.get_top_circle.size - 1
					circle = contains_circles_by_size circles, next_size
					if !circle.nil?
						destiny_tower.change_circle circle
						move
					end
				end
			end
		end
	end

end
