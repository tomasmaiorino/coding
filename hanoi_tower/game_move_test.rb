require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class GameTest < Test::Unit::TestCase
	#
	# move
	#
	def test_move
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
		#puts "moves count #{game.game_circles[0].moves_count}"
	 	game.new_move
		#puts "=============== moves count #{count}"
	end
end
