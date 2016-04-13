require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class GameTest < Test::Unit::TestCase

	def test_game_initialize
		game = Game.new
		assert !game.towers.nil? && game.towers.empty?
		assert !game.circles.nil? && game.circles.empty?
		assert game.actual_move == 0
	end

	def test_load_towers
		game = Game.new
		towers = game.load_towers(3)
		assert_not_nil(towers)
		assert_not_empty(towers)
		assert_equal(towers.size, 3)
	end

	def test_load_game
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
		assert_not_nil(circles)
		assert_not_empty(circles)
		assert_equal(circles.size, circles_length)
		assert_equal(circles[0].size, 1)
		assert_equal(circles[circles.size - 1].size, circles.size)
		assert_equal(game.towers[1].circles.size, circles.size)
		assert_equal(game.towers.size, towers_length)
		assert_equal(game.towers[1].circles[0].size, circles[0].size)
		assert_equal(game.towers[1].get_top_circle.size , circles_length)
	end

	def test_get_next_empty_tower
		game = Game.new
		circles_length = 3
		towers_length = 3
		circles = game.load_game(circles_length, towers_length)
		actual_circle = circles[circles.length - 1]
		empty_tower = game.get_next_empty_tower(game.towers, actual_circle)
		assert_equal(game.towers[2].id, empty_tower.id)
		game.towers[2].add_circle(actual_circle)
		empty_tower = game.get_next_empty_tower(game.towers, actual_circle)
		assert_equal(game.towers[2].id, empty_tower.id)
	end
end
