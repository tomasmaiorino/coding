#require 'minitest/autorun'
require_relative 'poker'
require "test-unit"
 
class PokerTest < Test::Unit::TestCase
	def setup
		@p = Poker.new
	end

	def test_initialize_game
		players = @p.create_game_using_players(2)
		assert_equal(2, players.length)
		assert_equal(5, players[0].length)
		assert_equal(5, players[1].length)
		assert_not_same(players[0], players[1])
	end

end