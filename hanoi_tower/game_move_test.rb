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
<<<<<<< HEAD
		towers_length = 4
		game = Game.new
		circles = game.load_game(circles_length, towers_length)		
	 	count = game.move
	 	assert_not_nil count
	 	assert_equal 7, count		
=======
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
	 	#count = game.move
		count = game.new_move
	 	assert_not_nil count
	 	assert_equal 7, count
>>>>>>> 98990f10da439066cebbf87a43249db2f92c279f
	end
end
