require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class GameTest < Test::Unit::TestCase
	#
	# move
	#
	def test_move
		circles_length = 4
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
	 	#count = game.move
		count = game.new_move
	 	assert_not_nil count
	 	assert_equal 7, count
	end
end
