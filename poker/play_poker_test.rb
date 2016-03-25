require_relative 'play_poker'
require_relative 'player'
require_relative 'match'
require "test-unit"

class PlayPokerTest < Test::Unit::TestCase
	def setup
    @pp = PlayPoker.new
	end

	def test_initialize_game
		players = [Player.new([], 1), Player.new([], 2)]
		players = @pp.create_game_using_players(players)
		assert_equal(2, players.length)
		assert_equal(5, players[0].cards.length)
		assert_equal(5, players[1].cards.length)
		assert_not_same(players[0].cards, players[1].cards)
	end

  def test_play
    #@deck = ['D','H','S','C']
    card_1 = ['AH', 'AD', 'KS', 'KS', 'QS']
    card_2 = ["2D", "2A", "AF", "KD", "QA"]

		players = [Player.new(card_1, 1), Player.new(card_2, 2)]
		m = Match.new(0, players)

    result = @pp.play(m.players)
    assert_equal(4, result[1].points)
		assert_equal(3, result[2].points)
  end

  def test_play_2
    #@deck = ['D','H','S','C']
    card_2 = ['AC', 'KH', 'KC', 'KS', 'KD']
    card_1 = ["2D", "2A", "2H", "KD", "QA"]

		players = [Player.new(card_1, 1), Player.new(card_2, 2)]
		m = Match.new(0, players)

    result = @pp.play(m.players)
    assert_equal(9, result[2].points)
		assert_equal(5, result[1].points)
  end

def test_play_3
    #@deck = ['D','H','S','C']

    card_1 = ["2D", "2A", "2H", "KD", "QA"]
    card_2 = ['AC', 'KH', 'KC', 'KS', 'KD']
    card_3 = ['10C', 'JH', 'QC', 'KS', 'AD']

		players = [Player.new(card_1, 1), Player.new(card_2, 2), Player.new(card_3, 3)]
		m = Match.new(0, players)

    result = @pp.play(m.players)
    assert_equal(9, result[2].points)
		assert_equal(5, result[1].points)
		assert_equal(6, result[3].points)
  end

 def test_play_4
    #@deck = ['D','H','S','C']
    card_1 = ["2D", "2A", "AH", "KD", "QA"]
    card_2 = ['10C', 'KH', 'AC', '2S', '6D']
    card_3 = ['2C', '6H', '3C', '10S', '5D']

		players = [Player.new(card_1, 1), Player.new(card_2, 2), Player.new(card_3, 3)]
		m = Match.new(0, players)

    result = @pp.play(m.players)
    assert_equal(3, result[1].points)
  end

  def test_play_5
    card_1 = ["2D", "2A", "2H", "KD", "QA"]
    card_2 = ['10C', '10H', '10B', '10A', '6D']
    card_3 = ['2C', '6H', '3C', '10S', '5D']

		players = [Player.new(card_1, 1), Player.new(card_2, 2), Player.new(card_3, 3)]
		m = Match.new(0, players)

    result = @pp.play(m.players)
    assert_equal(9, result[2].points)
		assert_equal(5, result[1].points)
		assert_equal(2, result[3].points)
  end

   def test_play_6
    card_1 = ["2D", "2A", "2H", "KD", "QA"]
    card_2 = ['10C', '10H', '10B', '10A', '6D']
    card_3 = ['8D', '9D', '10D', 'JD', 'QD']

		players = [Player.new(card_1, 1), Player.new(card_2, 2), Player.new(card_3, 3)]
		m = Match.new(0, players)

    result = @pp.play(m.players)
    assert_equal(5, result[1].points)
    assert_equal(9, result[2].points)
		assert_equal(10, result[3].points)
  end

  def test_play_7
    card_1 = ["2D", "2A", "3H", "KD", "QA"]
    card_2 = ['9C', '4H', '2B', '4A', 'QD']
    card_3 = ['2C', '6H', '3C', '10S', '5D']
    players = [Player.new(card_1, 1), Player.new(card_2, 2), Player.new(card_3, 3)]
	m = Match.new(0, players)
    result = @pp.play(m.players)
    assert_equal(3, result[1].points)
    assert_equal(3, result[2].points)
		assert_equal(2, result[3].points)
  end

  def test_is_a_tie
  	results = {'2'=> 7, '3'=> 7, '0'=>3}
  	ret = @pp.is_a_tie(results)
		assert ret
  end
end
