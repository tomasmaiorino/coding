class Game

	attr_accessor :actual_move, :towers, :circles
  def initialize
    @circles = []
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
      @circles << Circle.new(i + 1)
    end
    #order circles
    #@circles.sort {|left, right| left.size <=> right.size}
		#add the circles into the initial tower
    @towers[1].circles = @circles

    return @circles
  end

  def get_next_empty_tower(towers, actual_circle)
    towers.each {|key, value|
      return value if value.circles.empty?
    }
  end

	def move


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
		if !destiny_tower.circles.nil? && !destiny_tower.circles.empty? && destiny_tower.circles.size == @circles.size
			destiny_tower.circles.each_with_index{|v, i|
				if i < destiny_tower.circles.size - 1
					if v.size - 1 != destiny_tower.circles[i + 1].size
						puts "- v #{v.size}  i #{i}"
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
