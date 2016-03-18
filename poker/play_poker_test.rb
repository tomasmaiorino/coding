#require 'minitest/autorun'
require_relative 'play_poker'
require "test-unit"

class PlayPokerTest < Test::Unit::TestCase
	def setup
    @pp = PlayPoker.new
	end

	def test_initialize_game
		players = @pp.create_game_using_players(2)
		assert_equal(2, players.length)
		assert_equal(5, players[0].length)
		assert_equal(5, players[1].length)
		assert_not_same(players[0], players[1])
	end

  def test_play
    #@deck = ['D','H','S','C']
    card_1 = ['AH', 'AD', 'AS', 'KS', 'QS']
    card_2 = ["2D", "2A", "AF", "KD", "QA"]
    
    players = {}
    players[0] = card_1
    players[1] = card_2

    result = @pp.play(players)
    assert_equal(5, result[0])
  end

=begin        

        if is_straight(cards)
            return 10
        elsif !check_four(cards).empty?
            return 9
        elsif check_full_house(cards)
            return 8
        elsif check_all_cards_for_same_suit(cards)
            return 7
        elsif is_straight(cards)
            return 6
        elsif check_three(cards)
            return 5
        elsif check_pair(cards).length == 2
            return 4
        elsif check_pair(cards).length == 1
            return 3
        end
    end
=end

end
