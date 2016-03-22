#require 'minitest/autorun'
require_relative 'match'
require_relative 'player'
require "test-unit"

class MatchTest < Test::Unit::TestCase

	def setup
		@card_1 = ['AH', 'AD', 'KS', 'KQ', 'QS']
		@card_2 = ["2D", "2A", "AF", "KD", "QA"]

		@players = []
		@players << Player.new(['AH', 'AD', 'KS', 'KQ', 'QS'], 1)
		@players << Player.new(["2D", "2A", "AF", "KD", "QA"], 2)
	end

	def test_initialize
		m = Match.new(@players)
		assert m.players.length == 2
		assert_equal(10, m.get_players_cards.length)
	end

	def test_get_players_cards
		m = Match.new(@players)
		assert_equal(@card_1, m.players[1].cards)
		assert_equal(@card_2, m.players[2].cards)
		assert_equal(2, m.players.size)
	end

end
