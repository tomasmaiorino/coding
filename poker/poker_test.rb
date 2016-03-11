require 'minitest/autorun'
require_relative 'poker'
 
class PokerTest < Minitest::Test

	def setup
		@cards = ['2','3','4','5','6','7','8','9','10','J','Q','K', 'A']
		@deck = ['D','H','S','C']
		p = Poker.new
		@d = p.create_cards('D', @cards)
		@h = p.create_cards('H', @cards)
		@s = p.create_cards('S', @cards)
		@c = p.create_cards('C', @cards)
		@all_cards = @d + @h + @s + @c
	end

	def test_create_cards_should_have_13_cards()
		p = Poker.new
		c = p.create_cards('D', @cards)
		assert_equal(13, c.length)
	end

	def test_create_cards_should_have_all_naipe()
		p = Poker.new
		c = p.create_cards('D', @cards)
		none = ''
		c.each{|v|
			if v[v.length-1] != 'D'
				none = v
				break
			end
		}
		assert_equal(none, '')
	end

	def test_create_cards_should_return_nil_passing_nil_card_type()
		p = Poker.new
		c = p.create_cards(nil, @cards)
		puts c
		assert_nil(c)
	end

	def test_create_cards_should_return_nil_passing_empty_card_type()
		p = Poker.new
		c = p.create_cards('', @cards)
		puts c
		assert_nil(c)
	end

	def test_create_cards_should_return_nil_passing_empty_cards()
		p = Poker.new
		c = p.create_cards('D', [])
		puts c
		assert_nil(c)
	end

	def test_create_cards_should_return_nil_passing_nil_cards()
		p = Poker.new
		c = p.create_cards('D', nil)
		puts c
		assert_nil(c)
	end	

	def test_create_game()
		p = Poker.new
		c = p.create_game(@all_cards)
		assert_equal(5, c.length)
	end

	def test_create_game_passing_nil_all_cards()
		p = Poker.new
		c = p.create_game(nil)
		assert_empty(c)
	end

	def test_create_game_passing_empty_cards()
		p = Poker.new
		all = []
		c = p.create_game(all)
		assert_empty(c)
	end

	def test_sort_cards()
		p = Poker.new
		model = ["2", "3", "4", "5", "J", "Q"]
		cards = ["5D", "3A", "QF", "4D"]
		order_card = ["3A", "4D", "5D", "QF"]
		ordered = p.sort_cards(model, cards)
		assert_equal(order_card, ordered)
	end

	def test_remove_n
		cards = ["5D", "3A", "QF", "4D"]
		cards_without_n = ["5", "3", "Q", "4"]
		p = Poker.new
		c = p.remove_n(cards)
		assert_equal(c, cards_without_n)
	end

	def test_remove_n_passing_empty_cards
		p = Poker.new
		c = p.remove_n(nil)
		assert_empty(c)
	end

	def test_remove_n_passing_nil_cards
		cards = []
		p = Poker.new
		c = p.remove_n(cards)
		assert_empty(c)
	end

	def test_check_pair
		p = Poker.new
		cards = ["5D", "AA", "5F", "4D", "3B"]
		pair = p.check_pair(cards)
		assert_equal(2, pair["5"].length)
	end

	def test_check_pair_not_found
			p = Poker.new
		cards = ["5D", "AA", "2F", "4D", "3B"]
		pair = p.check_pair(cards)
		assert_empty(pair)
	end

	def test_check_pair_passing_nil
		p = Poker.new
		pair = p.check_pair(nil)
		assert_empty(pair)
	end

	def test_check_pair_passing_empty
		p = Poker.new
		cards = []
		pair = p.check_pair(cards)
		assert_empty(pair)
	end

	def test_dual_check_pair
		p = Poker.new
		cards = ["5D", "AA", "5F", "AD", "3B"]
		pair = p.check_pair(cards)
		assert_equal(2, pair["5"].length)
		assert_equal(2, pair["A"].length)
		assert_equal(2, pair.length)
	end

	def test_check_three
		p = Poker.new
		cards = ["5D", "5A", "5F", "AD", "3B"]
		three = p.check_three(cards)
		assert_equal(3, three["5"].length)
	end

	def test_check_three_not_found
		p = Poker.new
		cards = ["5D", "5A", "AF", "AD", "3B"]
		three = p.check_three(cards)
		assert_empty(three)
	end

	def test_check_three_passing_nil
		p = Poker.new
		three = p.check_three(nil)
		assert_empty(three)
	end

	def test_check_three_passing_empty
		p = Poker.new
		cards = []
		three = p.check_three(cards)
		assert_empty(three)
	end

	def test_check_four
		p = Poker.new
		cards = ["5D", "5A", "5F", "5B", "3B"]
		four = p.check_four(cards)
		assert_equal(4, four["5"].length)
	end

	def test_check_four_not_found
		p = Poker.new
		cards = ["5D", "5A", "2F", "5B", "3B"]
		four = p.check_four(cards)
		assert_empty(four)
	end

	def test_check_full_house
		p = Poker.new
		cards = ["5D", "5A", "5F", "AB", "AC"]
		assert p.check_full_house(cards)
	end

	def test_check_full_house_not_found
		p = Poker.new
		cards = ["5D", "5A", "5F", "2B", "AC"]
		assert !p.check_full_house(cards)
	end

	def test_check_all_cards_for_same_naipe
		p = Poker.new
		cards = ["5A", "3A", "4A", "JA", "AA"]
		assert p.check_all_cards_for_same_naipe(cards)
	end

	def test_check_all_cards_for_same_naipe_false
		p = Poker.new
		cards = ["5A", "3A", "4A", "JA", "AD"]
		assert !p.check_all_cards_for_same_naipe(cards)
	end

	def test_check_all_cards_not_in_sequence_2
		p = Poker.new
		cards = ["5A", "3A", "4A", "7A", "10D"]
		s = p.check_all_cards_in_sequence(cards)
		assert !s
	end

	def test_check_all_cards_not_in_sequence_1
		p = Poker.new
		cards = ["9A", "AA", "QA", "JA", "10D"]
		s = p.check_all_cards_in_sequence(cards)
		assert !s
	end

	def test_check_all_cards_not_in_sequence_3
		p = Poker.new
		cards = ["AA", "AA", "QA", "JA", "10D"]
		s = p.check_all_cards_in_sequence(cards)
		assert !s
	end	

	def test_check_all_cards_in_sequence
		p = Poker.new
		cards = ["5A", "3A", "4A", "6A", "2D"]
		s = p.check_all_cards_in_sequence(cards)
		assert s
	end

	def test_check_all_cards_in_sequence_1
		p = Poker.new
		cards = ["8A", "9A", "10A", "JA", "QD"]
		s = p.check_all_cards_in_sequence(cards)
		assert s
	end	
end