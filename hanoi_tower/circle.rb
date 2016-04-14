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
			return true if @actual_tower.circles.length == 1
			if @actual_tower.get_top_circle.size == @size && @size + 1 == @actual_tower.circles[@actual_tower.circles.length - 2].size
				return true
			elsif @size - 1 == @actual_tower.circles[get_circle_position_from_circles(circles) + 1].size
				return true
			end
		end
	return false
	end

	def get_circle_from_circles(circles)
		if !circles.nil? && !circles.empty?
			circles.each { |e|
				return e if e.size == @size
		  }
		end
	end

	def get_circle_position_from_circles(circles)
		if !circles.nil? && !circles.empty?
			circles.each_with_index { |e, ind|
				return ind if e.size == @size
		  }
		end
	end

	def changing_tower(tower)
		@@moves_count += 1
		@previous_tower = @actual_tower
		@actual_tower = tower
		@circle_move_count += 1
		@circle_last_move = @@moves_count
		@never_played = false
	end

	def self.moves_count
    @@moves_count
  end

	def moved_before
		@circle_last_move == @@moves_count - 1
	end
end
