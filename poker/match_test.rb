#require 'minitest/autorun'
require_relative 'match'
require_relative 'player'
require "test-unit"

class MatchTest < Test::Unit::TestCase

	def setup
		@card_1 = ['AH', 'AD', 'KS', 'KQ', 'QS']
		@card_2 = ["2D", "2A", "AF", "KD", "QA"]

		@players = []
		@players << Player.new(@cards_1, 1)
		@players << Player.new(@cards_2, 2)
	end

	def test_initialize
		puts "players #{@players}"
		m = Macth.new(@players)
		assert m.players.length == 2
		assert_equal(m.players[])
	end

	def get_players_cards
		m = Macth.new(@players)
		assert_equal(@card_1, m.players[1].cards)
		assert_equal(@card_2, m.players[1].cards)
		assert_equal(2, m.players.size)
	end

end
