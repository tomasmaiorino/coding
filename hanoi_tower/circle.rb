class Circle

	attr_accessor :last_tower, :actual_tower, :size, :never_played

	def initialize(size = nil, actual_tower = nil, last_tower = {})
		@size = size
		@actual_tower = actual_tower
		@last_tower = last_tower
		@never_played = true
	end

	def is_right_place
		#actual_tower.is_destiny && 
	end
end
