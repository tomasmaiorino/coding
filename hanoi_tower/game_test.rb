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
		assert_equal(towers[1].towers_max, 3)
		assert_equal(towers[2].id, 2)
		assert_equal(towers[3].id, 3)
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
		assert_equal(game.towers[3].id, empty_tower.id)
	end

	def test_is_finished_is_not_finished
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		assert !game.finished
	end

	def test_is_finished_is_not_finished_with_one_circle
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		tower_3.add_circle(game.circles[circles_length - 1])
		assert !game.finished
	end

	def test_is_finished_is_not_finished_with_two_circle_different_order
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		#add smaller circle
		tower_3.add_circle(game.circles[circles_length - 1])
		#add bigger circle
		tower_3.add_circle(game.circles[0])
		assert !game.finished
	end

	def test_is_finished_is_not_finished_with_two_circle_right_order
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		#add smaller circle
		tower_3.add_circle(game.circles[circles_length - 1])
		#add bigger circle
		tower_3.add_circle(game.circles[circles_length - 2])
		assert !game.finished
	end

	def test_is_finished_is_finished_with_two_circle_right_order
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		#add smaller circle
		tower_3.add_circle(game.circles[0])
		tower_3.add_circle(game.circles[1])
		tower_3.add_circle(game.circles[2])
		assert game.finished
	end
end
