class Tower

	attr_accessor :id, :tower_circles, :towers_max
	def initialize(id, towers_max)
		@id = id
		@tower_circles = []
		@towers_max = towers_max
	end

	def is_destiny
		id == towers_max
	end

	def get_top_circle
		@tower_circles[@tower_circles.size - 1]
	end

	def get_bottom_circle
		@tower_circles[0]
	end

	def add_circle(circle)
		circle.changing_tower(self)
		@tower_circles << circle
		@tower_circles.length
	end

	def tower_circles
		@tower_circles.sort! { |a,b| b.size <=> a.size }
	end

	def remove_circle(circle)
		circle_to_return = nil
		ind = @tower_circles.index { |x| x.size == circle.size }
		if ind != nil
			circle_to_return = @tower_circles[ind]
			@tower_circles.delete_at(ind)
		end
		return circle_to_return
	end

end
