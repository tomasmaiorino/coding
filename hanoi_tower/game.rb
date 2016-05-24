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

<<<<<<< HEAD
	def get_all_towers_available
     towers = []
     @towers.each {|key, value|
        towers << value
     }
     return towers
 end

	 def move
	 	#put the first circle into destiny tower
		if Circle.moves_count == 0
			destiny_tower = get_destiny_tower get_all_towers_available
			destiny_tower.change_circle game_circles[game_circles.size - 1]
			#new_move
		end
		is_finished = finished

	 	while !is_finished
	 		#retrrieve all circles availables
			circles = get_availables_circles
			if !circles.empty?
				circles.each {|c|

				#check if there is circle that has not been moved
				if Circle.moves_count > 4 && game_circles.size > 4
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
				#concat all towers content
				towers.each{ |t|
					towers_temp_one << t
				}
				empty_towers.each{ |t|
					towers_temp_one << t
				}
				#treat the destiny tower
				is_circle_changed = treat_destiny_towers towers_temp_one, circles, false

				if is_circle_changed
					is_finished = finished
					next
				end

				#check if there is only empty towers
				if !empty_towers.empty? && towers.empty?
					empty_towers[0].change_circle c
					#new_move
				#check if there is not empty towers
				elsif empty_towers.empty? && !towers.empty?
					tower_to_ignore = nil
					actual_tower = c.actual_tower
					#check if the actual towers has more then one circle
					if c.actual_tower.tower_circles.size > 1 #1
						#check if some of the circles above the  actual circle, are the next circle to be add as next into 
						# any availables circles
						get_all_towers_available.each {|t_2|
							if actual_tower.tower_circles[actual_tower.tower_circles.size - 2].size == t_2.get_top_circle.size - 1
								tower_to_ignore = t_2
								break
							end
						}
					end
					#order the towers by circles size
					new_towers =  towers.sort! { |a, b|
						a.get_top_circle.size <=> b.get_top_circle.size
					}				
					if !tower_to_ignore.nil?
						new_towers.each{|t|
							if t.id != tower_to_ignore
								#get any towers different from tower_to_ignore
								#and add the circle into it.
								t.change_circle c
								#take the circle above the actual circle and
								#add it int tower_ the has been ignored
								tower_to_ignore.change_circle actual_tower.get_top_circle
							end
						}
					else
						#add the circle into the tower with the closest circle
						new_towers[0].change_circle c								
					end
					#new_move
				else
					#at this point both empty and towers aren't empty
					if c.actual_tower.tower_circles.size > 1 #1
						actual_tower = c.actual_tower
						destiny_tower = get_destiny_tower get_all_towers_available
						if !destiny_tower.nil? && !destiny_tower.tower_circles.empty?
							if actual_tower.tower_circles[actual_tower.tower_circles.size - 2].size == destiny_tower.get_top_circle.size - 1
								empty_towers[0].change_circle c
								destiny_tower.change_circle actual_tower.get_top_circle
								#new_move
							end
						end
					else #else 1
						if !get_destiny_tower(towers).nil?
							empty_towers[0].change_circle c
							#new_move
						else
							new_towers =  towers.sort! { |a, b|
								a.get_top_circle.size <=> b.get_top_circle.size
							}
							new_towers[0].change_circle c
							#new_move
						end
					end #end 1
					new_towers =  towers.sort! { |a, b|
						a.get_top_circle.size <=> b.get_top_circle.size
					}
					new_towers[0].change_circle c
					#new_move
				end
				}
			end		
		 	is_finished = finished
		 	puts "is_finished #{is_finished}"
		 end
		puts "-------------- FINISHED ----------------"
		puts "TOTAL MOVEMENTS: #{Circle.moves_count}"
		destiny_tower = get_destiny_tower(@towers)
		puts "Tower #{destiny_tower.id}"
		destiny_tower.tower_circles.each_with_index{| c, i|
			print	"Circle #{c.size} "
		}
		puts ""
		puts "----------------------------------------"
		return Circle.moves_count
	 end

=begin
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
						if Circle.moves_count > 4
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

						if !empty_towers.empty? && towers.empty?
							empty_towers[0].change_circle c
							new_move
						elsif empty_towers.empty? && !towers.empty?
							tower_to_ignore = nil
							actual_tower = c.actual_tower
							if c.actual_tower.tower_circles.size > 1 #1								
								get_all_towers_available.each {|t_2|
									if actual_tower.tower_circles[actual_tower.tower_circles.size - 2].size == t_2.get_top_circle.size - 1
										tower_to_ignore = t_2
										break
									end
								}
							end
							new_towers =  towers.sort! { |a, b|
								a.get_top_circle.size <=> b.get_top_circle.size
							}
							if !tower_to_ignore.nil?
								puts "tower_to_ignore #{tower_to_ignore}"
								new_towers.each{|t|
									if t.id != tower_to_ignore
										t.change_circle c
										puts "adding"
										tower_to_ignore.change_circle actual_tower.get_top_circle
									end
								}
							else
								new_towers[0].change_circle c								
=======
def get_all_towers_available
	 towers = []
	 @towers.each {|key, value|
		towers << value
	 }
	 return towers
 end

 def new_move_2
 	#check if it is the first move, if it true, move the first circle to last tower

 	# if the game is not finished,
 	#retrieve all availables circles ( a circle will be available if it wasn't move on the last move and if among all towers, one of them have bigger circles)

 	#get all available towers through a specific circle
 	# get all empty towers available
 end

	def new_move
		#put the first circle into destiny tower
	  if Circle.moves_count == 0
		 destiny_tower = get_destiny_tower get_all_towers_available
		 destiny_tower.change_circle game_circles[game_circles.size - 1]
		 #new_move
	  end

		is_finished = finished

		while !is_finished
			#retrrieve all circles availables
			circles = get_availables_circles
			puts "circles #{circles.size}"
#			puts "circles #{circles}"
			if !circles.empty?
				circles.each{|c|
					#check if there is circle that has not been moved
					if Circle.moves_count > 4 && game_circles.size > 4
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
					#concat all towers content
					towers.each{ |t|
						towers_temp_one << t
					}
					empty_towers.each{ |t|
						towers_temp_one << t
					}
					#treat the destiny tower
					is_circle_changed = treat_destiny_towers towers_temp_one, circles, false

					if is_circle_changed
						is_finished = finished
						next
					end

					if !empty_towers.empty? && towers.empty?
						# order the empty_towers by id
						empty_towers = empty_towers.sort! { |a, b|
							b.id <=> a.id
						}
						break unless c.is_at_top
						empty_towers[0].change_circle(c)
					elsif empty_towers.empty? && !towers.empty?
						#check if the current circle is in a tower with more than one circle
						actual_circle_tower = c.actual_tower
						if actual_circle_tower.tower_circles.size > 1
							# check if the circle under the top circle can fit exacly on any other tower
							tmp_tower = get_next_tower_available_from_under_circle(@towers, c, true)
							tmp_tower = get_next_tower_available_from_under_circle(@towers, c, false) if tmp_tower == nil
							if !tmp_tower.nil?
								towers.each{|t|
									if t.id != tmp_tower
										#set the top circle in any tower but tmp_tower
										puts "doing double call"
										t.change_circle c
										break
										#tmp_tower.change_circle actual_circle_tower.get_top_circle
										#break
									end
								}
							else
								#look for a tower where the actual  circle can fit on any tower
								#order the towers by circles size
								towers =  towers.sort! { |a, b|
									a.get_top_circle.size <=> b.get_top_circle.size
								}
								towers[0].change_circle c
>>>>>>> 98990f10da439066cebbf87a43249db2f92c279f
							end
							new_move
						else
<<<<<<< HEAD
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
=end
=======
							#look for a tower where the actual  circle can fit on any tower
							#order the towers by circles size
							towers =  towers.sort! { |a, b|
								a.get_top_circle.size <=> b.get_top_circle.size
							}
							towers[0].change_circle c
						end
					# there are both empty_tower and not empty_tower
					elsif !empty_towers.empty? && !towers.empty?
						#check if the current circle is in a tower with more than one circle
						actual_circle_tower = c.actual_tower
						if actual_circle_tower.tower_circles.size > 1
							# check if the circle under the top circle can fit exacly on any other tower
							tmp_tower = get_next_tower_available_from_under_circle(@towers, c, true)
							#tmp_tower = get_next_tower_available_from_under_circle(@towers, c, false) if tmp_tower == nil
							if !tmp_tower.nil?
								#check if should change to empty or not
								empty_towers[0].change_circle c
								tmp_tower.change_circle actual_circle_tower.get_top_circle
							else
								empty_towers[0].change_circle c
							end
						else
							#to give  preference to destiny tower
							if !get_destiny_tower(towers).nil?
								empty_towers[0].change_circle c
								#new_move
							else
								new_towers =  towers.sort! { |a, b|
									a.get_top_circle.size <=> b.get_top_circle.size
								}
								new_towers[0].change_circle c
							end
						end
					end
					#check if the game is over
					puts "checking"
					is_finished = finished
				}
			end
		end
		return Circle.moves_count
	end


	 def move
		#put the first circle into destiny tower
		if Circle.moves_count == 0
			destiny_tower = get_destiny_tower get_all_towers_available
			destiny_tower.change_circle game_circles[game_circles.size - 1]
			#new_move
		end
		is_finished = finished

		while !is_finished
			#retrrieve all circles availables
			circles = get_availables_circles
			if !circles.empty?
				circles.each {|c|
					puts "available circle #{c.size}"
				#check if there is circle that has not been moved
				if Circle.moves_count > 4 && game_circles.size > 4
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
				#concat all towers content
				towers.each{ |t|
					towers_temp_one << t
				}
				empty_towers.each{ |t|
					towers_temp_one << t
				}
				#treat the destiny tower
				is_circle_changed = treat_destiny_towers towers_temp_one, circles, false

				if is_circle_changed
					is_finished = finished
					next
				end

				#check if there is only empty towers
				if !empty_towers.empty? && towers.empty?
					empty_towers[0].change_circle c
					#new_move
				#check if there is not empty towers
				elsif empty_towers.empty? && !towers.empty?
					tower_to_ignore = nil
					actual_tower = c.actual_tower
					#check if the actual towers has more then one circle
					if c.actual_tower.tower_circles.size > 1 #1
						#check if some of the circles above the  actual circle, are the next circle to be add as next into
						# any availables circles
						get_all_towers_available.each {|t_2|
							if actual_tower.tower_circles[actual_tower.tower_circles.size - 2].size == t_2.get_top_circle.size - 1
								tower_to_ignore = t_2
								break
							end
						}
					end
					#order the towers by circles size
					new_towers =  towers.sort! { |a, b|
						a.get_top_circle.size <=> b.get_top_circle.size
					}
					puts "towers t #{towers}"
					if !tower_to_ignore.nil?
						puts "to ignore #{tower_to_ignore.id}"
						puts "towers t #{t}"
						towers.each{|t|
							puts "---------- id #{t.id}"
							if t.id != tower_to_ignore# && t.get_top_circle.size > c.size
								#get any towers different from tower_to_ignore
								#and add the circle into it.
								t.change_circle c
								#take the circle above the actual circle and
								#add it int tower_ the has been ignored
								puts "tower to ignore #{tower_to_ignore.id}"
								tower_to_ignore.change_circle actual_tower.get_top_circle
								is_finished = finished
								next
							end
						}
					else
						#add the circle into the tower with the closest circle
						new_towers[0].change_circle c
					end
					#new_move
				else
					if  towers.empty? && empty_towers.empty?


					end
					#at this point both empty and towers aren't empty
					if c.actual_tower.tower_circles.size > 1 #1
						actual_tower = c.actual_tower
						destiny_tower = get_destiny_tower get_all_towers_available
						if !destiny_tower.nil? && !destiny_tower.tower_circles.empty?
							if actual_tower.tower_circles[actual_tower.tower_circles.size - 2].size == destiny_tower.get_top_circle.size - 1
								empty_towers[0].change_circle c
								destiny_tower.change_circle actual_tower.get_top_circle
								#new_move
							end
						end
					else #else 1
						if !get_destiny_tower(towers).nil?
							empty_towers[0].change_circle c
							#new_move
						else
							new_towers =  towers.sort! { |a, b|
								a.get_top_circle.size <=> b.get_top_circle.size
							}
							new_towers[0].change_circle c
							#new_move
						end
					end #end 1
					new_towers =  towers.sort! { |a, b|
						a.get_top_circle.size <=> b.get_top_circle.size
					}
					new_towers[0].change_circle c
					#new_move
				end
				}
			end
			is_finished = finished
			puts "is_finished #{is_finished}"
		 end
		puts "-------------- FINISHED ----------------"
		puts "TOTAL MOVEMENTS: #{Circle.moves_count}"
		destiny_tower = get_destiny_tower(@towers)
		puts "Tower #{destiny_tower.id}"
		destiny_tower.tower_circles.each_with_index{| c, i|
			print	"Circle #{c.size} "
		}
		puts ""
		puts "----------------------------------------"
		return Circle.moves_count
	 end

	 def get_next_tower_available_from_under_circle(towers, circle, match_size)

		actual_circle_tower = circle.actual_tower
		towers_def = []

		if towers.kind_of?(Array)
			towers_def = towers
		else
			towers.each {|key, value|
					towers_def << value
			}
		end

		if actual_circle_tower.tower_circles.size > 1 && actual_circle_tower.get_top_circle.size == circle.size
			under_circle = actual_circle_tower.tower_circles[actual_circle_tower.tower_circles.size - 2]
			towers_def.each{|t|
				if match_size
					if !t.get_top_circle.nil? && t.get_top_circle.size == under_circle.size + 1
						return t
					end
				else
					if !t.get_top_circle.nil? && t.get_top_circle.size > under_circle.size
						return t
					end
				end
			}
		end
		return nil
	 end


>>>>>>> 98990f10da439066cebbf87a43249db2f92c279f
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
<<<<<<< HEAD
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

=======
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

>>>>>>> 98990f10da439066cebbf87a43249db2f92c279f
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
<<<<<<< HEAD

	#to_test
	def contains_circles_by_size(circles, size)
		ind = circles.index{|v| v.size == size}
		return circles[ind] if ind != nil
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
=======
>>>>>>> 98990f10da439066cebbf87a43249db2f92c279f

	#to_test
	def contains_circles_by_size(circles, size)
		ind = circles.index{|v| v.size == size}
		return circles[ind] if ind != nil
	end

	def treat_destiny_towers(towers, circles, move)
		is_circle_changed = false
		destiny_tower = get_destiny_tower towers
		if !destiny_tower.nil?
			temp_circle = contains_circles_by_size circles, @game_circles[0].size
			if destiny_tower.tower_circles.empty? && !temp_circle.nil?
				destiny_tower.change_circle temp_circle
				is_circle_changed = true
				#des
				#new_move if move
			else
				if !destiny_tower.tower_circles.empty?
					next_size = destiny_tower.get_top_circle.size - 1
					circle = contains_circles_by_size circles, next_size
					if !circle.nil?
						destiny_tower.change_circle circle
						is_circle_changed = true
				#		new_move if move
					end
				end
			end
		end
		return is_circle_changed
	end
end
