class Tower

	attr_accessor :id, :circles, :towers_max
	def initialize(id, towers_max)
		@id = id
		@circles = []
		@towers_max = towers_max
	end

	def is_destiny
		id == towers_max
	end

	def get_top_circle
		circles[circles.size - 1]
	end

	def get_bottom_circle
		circles[0]
	end

	def add_circle(circle)
		circle.changing_tower(self)
		@circles << circle
		@circles.length
	end
end
