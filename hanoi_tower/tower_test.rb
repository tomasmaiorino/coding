require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class TowerTest < Test::Unit::TestCase

	def test_tower_initialize
		tower = Tower.new(1, 3)
		assert_equal(tower.id, 1)
		assert_empty(tower.circles)
		assert_equal(tower.towers_max, 3)
	end

	def test_tower_is_destiny
		tower = Tower.new(3, 3)
		assert tower.is_destiny
	end

	def test_tower_is_not_destiny
		tower = Tower.new(2, 3)
		assert !tower.is_destiny
	end

	def test_get_first_circle
		tower = Tower.new(1, 3)
		circles = [Circle.new(1, tower), Circle.new(2, Tower.new(2,2)), Circle.new(3, Tower.new(3,3))]
		tower.circles = circles
		assert_equal(tower.get_first_circle.size, 3)
	end
end
