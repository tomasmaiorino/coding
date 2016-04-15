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
    @towers[1].tower_circles = @game_circles
		circles_ret = @game_circles.sort! { |a,b| b.size <=> a.size }
    return circles_ret
  end

  def get_next_empty_tower(towers)
    towers.each {|key, value|
      return value if value.tower_circles.empty?
    }
		return nil
  end

	def get_next_circle_to_move
		circle = nil
		@game_circles.each {|v|
			return v if v.never_played
			if !v.moved_before
				if circle == nil
					circle = v
					next
				elsif v.size > circle.size
					circle = v
				end
			end
		}
		return circle
	end

	def move
		first_tower = @towers[1]
		if !finished
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

end
