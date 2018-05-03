class Circle

	@@moves_count = 0

	attr_accessor :previous_tower, :actual_tower, :size, :never_played, :circle_move_count, :circle_last_move

	def initialize(size = nil, actual_tower = nil, previous_tower = nil)
		@size = size
		@actual_tower = actual_tower
		@previous_tower = previous_tower
		@never_played = true
		@circle_last_move = 0
		@circle_move_count = 0
	end

	def is_right_place(circles)
		if @actual_tower.is_destiny && !circles.nil? && !circles.empty? && @actual_tower.get_bottom_circle.size == circles[0].size
			return true if @actual_tower.tower_circles.length == 1
			if @actual_tower.get_top_circle.size == @size && @size + 1 == @actual_tower.tower_circles[@actual_tower.tower_circles.length - 2].size
				return true
			elsif @size - 1 == @actual_tower.tower_circles[get_circle_position_from_circles(circles, self) + 1].size
				return true
			end
		end
	return false
	end

	def get_circle_position_from_circles(circles, circle)
		if !circles.nil? && !circles.empty? && !circle != nil
				circles.index { |x| x.size == circle.size }
		else
			return nil
		end
	end

	def biggest_one(bigger_circle)
		@size == bigger_circle.size
	end


	def get_circle_from_circles(circles)
		if !circles.nil? && !circles.empty?
			circles.each { |e|
				return e if e.size == @size
		  }
		end
	end

	def changing_tower(tower)
		@@moves_count += 1
		@circle_last_move = @@moves_count
		@previous_tower = @actual_tower
		@actual_tower = tower
		@circle_move_count += 1
		@never_played = false
	end

	def self.moves_count
    	@@moves_count
  	end

  	def initialize_moves_count
  		@@moves_count = 0
  	end

  	def set_moves_count(moves_count)
  		@@moves_count = moves_count
  	end

	def last_moved
		@circle_last_move == @@moves_count
	end

	def is_at_top
		!actual_tower.nil? && !actual_tower.get_top_circle.nil? && actual_tower.get_top_circle.size == @size
	end
end
