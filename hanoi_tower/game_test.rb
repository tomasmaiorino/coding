require "test-unit"
require_relative 'circle'
class GameTest < Test::Unit::TestCase

	def test_load_game(
		circles = game.load_game(3)
		
		circles = []
		for i 0..pieces - 1
			circles << Circle.new(i + 1)
		end
	end

end

