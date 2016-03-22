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
    card_1 = ['AH', 'AD', 'KS', 'KS', 'QS']
    card_2 = ["2D", "2A", "AF", "KD", "QA"]

    players = {}
    players[0] = card_1
    players[1] = card_2

    result = @pp.play(players)
    assert_equal(4, result[0])
  end

  def test_play_2
    #@deck = ['D','H','S','C']
    card_2 = ['AC', 'KH', 'KC', 'KS', 'KD']
    card_1 = ["2D", "2A", "2H", "KD", "QA"]

    players = {}
    players[0] = card_1
    players[1] = card_2

    result = @pp.play(players)
    assert_equal(9, result[1])
  end

def test_play_3
    #@deck = ['D','H','S','C']

    card_1 = ["2D", "2A", "2H", "KD", "QA"]
    card_2 = ['AC', 'KH', 'KC', 'KS', 'KD']
    card_3 = ['10C', 'JH', 'QC', 'KS', 'AD']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    result = @pp.play(players)
    assert_equal(9, result[1])
  end

 def test_play_4
    #@deck = ['D','H','S','C']
    card_1 = ["2D", "2A", "AH", "KD", "QA"]
    card_2 = ['10C', 'KH', 'AC', '2S', '6D']
    card_3 = ['2C', '6H', '3C', '10S', '5D']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    result = @pp.play(players)
    assert_equal(3, result[0])
  end

  def test_play_5
    card_1 = ["2D", "2A", "2H", "KD", "QA"]
    card_2 = ['10C', '10H', '10B', '10A', '6D']
    card_3 = ['2C', '6H', '3C', '10S', '5D']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    result = @pp.play(players)
    assert_equal(1, result.keys.first)
    assert_equal(9, result[result.keys.first])
  end

   def test_play_6
    card_1 = ["2D", "2A", "2H", "KD", "QA"]
    card_2 = ['10C', '10H', '10B', '10A', '6D']
    card_3 = ['8D', '9D', '10D', 'JD', 'QD']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    result = @pp.play(players)
    assert_equal(2, result.keys.first)
    assert_equal(10, result[result.keys.first])
  end

  def test_play_7
    card_1 = ["2D", "2A", "3H", "KD", "QA"]
    card_2 = ['9C', '4H', '2B', '4A', 'QD']
    card_3 = ['2C', '6H', '3C', '10S', '5D']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    result = @pp.play(players)
    assert_equal(0, result.keys.first)
    assert_equal(3, result[result.keys.first])
  end

  def test_get_winner
  	 card_1 = ["2D", "2A", "3H", "KD", "QA"]
    card_2 = ['9C', '4H', '2B', '4A', 'QD']
    card_3 = ['2C', '6H', '3C', '10S', '5D']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    winner = @pp.get_winner(players)
    assert_equal(card_1, winner)

  end

  def test_get_winner_2
  	card_1 = ["2D", "2A", "2H", "KD", "QA"]
    card_2 = ['10C', '10H', '10B', '10A', '6D']
    card_3 = ['8D', '9D', '10D', 'JD', 'QD']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    winner = @pp.get_winner(players)
    assert_equal(card_3, winner)
  end

  def test_get_winner_3
  	card_1 = ["2D", "2A", "JH", "KD", "QA"]
    card_2 = ['10C', '10H', 'JB', 'JA', '6D']
    card_3 = ['8D', '9DJ', '10D', '3D', 'QD']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    winner = @pp.get_winner(players)
    assert_equal(card_2, winner)
  end

  def test_get_winner_4
  	card_1 = ["2D", "2A", "JH", "KD", "QA"]
    card_2 = ['10C', '10H', 'JB', 'JA', '6D']
    card_3 = ['8D', '9D', '10D', '3D', 'QD']

    players = {}
    players[0] = card_1
    players[1] = card_2
    players[2] = card_3

    winner = @pp.get_winner(players)
    assert_equal(card_3, winner)
  end

  def test_is_a_tie
  	results = {'2'=> 7, '1'=> 7, '0'=>3}
  	ret = @pp.is_a_tie(results)
	assert_equal(2, ret.size)
  end
end
