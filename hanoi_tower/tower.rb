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

	def get_first_circle
		circles[circles.size - 1]
	end

end
