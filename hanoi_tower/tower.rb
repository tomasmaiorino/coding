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

	def is_right_place(pieces, actual_piece)
		#!@circles.nil? && !@circles.empty? && get_bottom_circle.size ==
	end
end
