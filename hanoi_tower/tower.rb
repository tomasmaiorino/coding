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

	def change_circle(circle)
		puts "removing circle #{circle.size} from actual_tower #{circle.actual_tower.id}"
		circle_removed = circle.actual_tower.remove_circle(circle)
		if !circle_removed.nil?
			puts "adding to tower #{@id}"
			return add_circle(circle)
		else
			return nil
		end
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

	def print_tower
		puts "|Tower: #{id}|"
		@tower_circles.each{|x|
			print "|circle #{x.size}|"
		}
	end

end
