#require 'minitest/autorun'
require "test-unit"
require_relative 'poker'
 
class PokerTest < Test::Unit::TestCase

	def setup
		@cards = ['2','3','4','5','6','7','8','9','10','J','Q','K', 'A']
		@deck = ['D','H','S','C']
		@p = Poker.new
		@d = @p.create_cards('D', @cards)
		@h = @p.create_cards('H', @cards)
		@s = @p.create_cards('S', @cards)
		@c = @p.create_cards('C', @cards)
		@all_cards = @d + @h + @s + @c
	end

	def test_create_cards_should_have_13_cards()		
		c = @p.create_cards('D', @cards)
		assert_equal(13, c.length)
	end

	def test_create_cards_should_have_all_suit()		
		c = @p.create_cards('D', @cards)
		none = ''
		c.each{|v|
			if v[v.length-1] != 'D'
				none = v
				break
			end
		}
		assert_equal(none, '')
	end

	def test_get_higher_card
		cards = ["JD", "AA", "AF", "4D", "QA"]
		h = @p.get_higher_card(cards)
		assert_equal('AF', h)
	end

	def test_get_higher_card_2
		cards = ["2D", "KA", "4F", "jD", "QA"]
		h = @p.get_higher_card(cards)
		assert_equal('KA', h)
	end	

	def test_get_higher_card_3
		cards = ["2D", "3A", "7F", "10D", "9A"]
		h = @p.get_higher_card(cards)
		assert_equal('10D', h)
	end	

	def test_get_higher_card_4
		cards = ["2A", "4A", "4F", "2D", "JA"]
		h = @p.get_higher_card(cards)
		assert_equal('JA', h)
	end		

	def test_check_only_letters_false
		cards = ["JD", "AA", "AF", "4D", "QA"]
		h = @p.check_only_letters(cards)				
		assert !h
	end

	def test_check_only_letters
		cards = ["JD", "AA", "AF", "KD", "QA"]
		h = @p.check_only_letters(cards)	
		assert h
	end

	def test_check_only_numbers
		cards = ["2D", "3A", "5F", "6D", "QA"]
		h = @p.check_only_numbers(cards)
		assert !h
	end

	def test_check_only_numbers_2
		cards = ["10D", "3A", "5F", "6D", "7A"]
		h = @p.check_only_numbers(cards)
		assert h
	end

	def test_check_only_numbers_false
		cards = ["JD", "AA", "AF", "KD", "QA"]
		h = @p.check_only_numbers(cards)
		assert !h
	end
	
	def test_check_only_numbers_false_2
		cards = ["2D", "3A", "5F", "KD", "QA"]
		h = @p.check_only_numbers(cards)
		assert !h
	end	

	def test_create_cards_should_return_nil_passing_nil_card_type()		
		c = @p.create_cards(nil, @cards)
		puts c
		assert_nil(c)
	end

	def test_create_cards_should_return_nil_passing_empty_card_type()		
		c = @p.create_cards('', @cards)
		puts c
		assert_nil(c)
	end

	def test_create_cards_should_return_nil_passing_empty_cards		
		c = @p.create_cards('D', [])
		puts c
		assert_nil(c)
	end

	def test_create_cards_should_return_nil_passing_nil_cards
		c = @p.create_cards('D', nil)
		puts c
		assert_nil(c)
	end	

	def test_create_game		
		c = @p.create_game(@all_cards)
		assert_equal(5, c.length)
	end

	def test_create_game_passing_nil_all_cards		
		c = @p.create_game(nil)
		assert_empty(c)
	end

	def test_create_game_passing_empty_cards		
		all = []
		c = @p.create_game(all)
		assert_empty(c)
	end

	def test_sort_cards()		
		model = ["2", "3", "4", "5", "J", "Q"]
		cards = ["5D", "3A", "QF", "4D"]
		order_card = ["3A", "4D", "5D", "QF"]
		ordered = @p.sort_cards(model, cards)
		assert_equal(order_card, ordered)
	end

	def test_remove_n
		cards = ["5D", "3A", "QF", "4D"]
		cards_without_n = ["5", "3", "Q", "4"]		
		c = @p.remove_n(cards)
		assert_equal(c, cards_without_n)
	end

	def test_remove_n_passing_empty_cards		
		c = @p.remove_n(nil)
		assert_empty(c)
	end

	def test_remove_n_passing_nil_cards
		cards = []		
		c = @p.remove_n(cards)
		assert_empty(c)
	end

	def test_check_pair		
		cards = ["5D", "AA", "5F", "4D", "3B"]
		pair = @p.check_pair(cards)
		assert_equal(2, pair["5"].length)
	end

	def test_check_pair_not_found			
		cards = ["5D", "AA", "2F", "4D", "3B"]
		pair = @p.check_pair(cards)
		assert_empty(pair)
	end

	def test_check_pair_passing_nil		
		pair = @p.check_pair(nil)
		assert_empty(pair)
	end

	def test_check_pair_passing_empty		
		cards = []
		pair = @p.check_pair(cards)
		assert_empty(pair)
	end

	def test_dual_check_pair		
		cards = ["5D", "AA", "5F", "AD", "3B"]
		pair = @p.check_pair(cards)
		assert_equal(2, pair["5"].length)
		assert_equal(2, pair["A"].length)
		assert_equal(2, pair.length)
	end

	def test_check_three		
		cards = ["10A", "AA", "10B", "QA", "10S"]
		three = @p.check_three(cards)
		assert_equal(3, three["10"].length)
	end

	def test_check_three_not_found		
		cards = ["5D", "5A", "AF", "AD", "3B"]
		three = @p.check_three(cards)
		assert_empty(three)
	end

	def test_check_three_passing_nil		
		three = @p.check_three(nil)
		assert_empty(three)
	end

	def test_check_three_passing_empty		
		cards = []
		three = @p.check_three(cards)
		assert_empty(three)
	end

	def test_check_four		
		cards = ["5D", "5A", "5F", "5B", "3B"]
		four = @p.check_four(cards)
		assert_equal(4, four["5"].length)
	end

	def test_check_four_not_found		
		cards = ["5D", "5A", "2F", "5B", "3B"]
		four = @p.check_four(cards)
		assert_empty(four)
	end

	def test_is_full_house		
		cards = ["5D", "5A", "5F", "AB", "AC"]
		assert @p.is_full_house(cards)
	end

	def test_is_full_house_not_found		
		cards = ["5D", "5A", "5F", "2B", "AC"]
		assert !@p.is_full_house(cards)
	end

	def test_is_flush		
		cards = ["5A", "3A", "4A", "JA", "AA"]
		assert @p.is_flush(cards)
	end

	def test_is_flush_false		
		cards = ["5A", "3A", "4A", "JA", "AD"]
		assert !@p.is_flush(cards)
	end

	def test_check_all_cards_not_in_sequence_2		
		cards = ["5A", "3A", "4A", "7A", "10D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert !s
	end

	def test_check_all_cards_not_in_sequence_1		
		cards = ["9A", "AA", "QA", "JA", "10D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert !s
	end

	def test_check_all_cards_not_in_sequence_3		
		cards = ["AA", "AA", "QA", "JA", "10D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert !s
	end	

	def test_check_all_cards_not_in_sequence_4	
		cards = ["8A", "AA", "QA", "JA", "10D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert !s
	end	

	def test_check_all_cards_not_in_sequence_5		
		cards = ["7A", "2A", "3A", "4A", "5D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert !s
	end	

	def test_check_all_cards_not_in_sequence_6		
		cards = ["2A", "2B", "2B", "4A", "5D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert !s
	end	

	def test_check_all_cards_not_in_sequence_7		
		cards = ["8A", "9B", "10B", "JA", "KD"]
		s = @p.check_all_cards_in_sequence(cards)
		assert !s
	end

	def test_check_all_cards_in_sequence		
		cards = ["5A", "3A", "4A", "6A", "2D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert s
	end

	def test_check_all_cards_in_sequence_1		
		cards = ["8A", "9A", "10A", "JA", "QD"]
		s = @p.check_all_cards_in_sequence(cards)
		assert s
	end	

		def test_check_all_cards_in_sequence_2		
		cards = ["AA", "KA", "10A", "JA", "QD"]
		s = @p.check_all_cards_in_sequence(cards)
		assert s
	end	

	def test_check_all_cards_in_sequence_3		
		cards = ["7A", "9B", "8D", "JA", "10D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert s
	end

	def test_check_all_cards_in_sequence_4		
		cards = ["JA", "9B", "8D", "QA", "10D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert s
	end	

	def test_check_all_cards_in_sequence_5		
		cards = ["JA", "9B", "KD", "QA", "10D"]
		s = @p.check_all_cards_in_sequence(cards)
		assert s
	end

	def test_check_all_cards_in_sequence_and_same_suit		
		cards = ["JA", "9A", "KA", "QA", "10A"]
		assert @p.check_all_cards_in_sequence(cards)
		assert @p.is_flush(cards)
	end

	def test_check_all_cards_in_sequence_and_not_same_suit		
		cards = ["JA", "9B", "KA", "QD", "10A"]
		assert @p.check_all_cards_in_sequence(cards)
		assert !@p.is_flush(cards)
	end

	def test_check_all_cards_is_not_sequence_and_is_same_suit		
		cards = ["2A", "9A", "KA", "QA", "10A"]
		assert !@p.check_all_cards_in_sequence(cards)
		assert @p.is_flush(cards)
	end	

	def test_is_full_house		
		cards = ["2A", "2B", "3A", "2B", "3C"]
		assert @p.is_full_house(cards)
	end

	def test_is_full_house_2		
		cards = ["KA", "KB", "3A", "KC", "3C"]
		assert @p.is_full_house(cards)
	end		

	def test_is_not_full_house		
		cards = ["2A", "AB", "3A", "2B", "3C"]
		assert !@p.is_full_house(cards)
	end	

	def test_is_straight		
		cards = ["2B", "3A", "4C", "5B", "6C"]
		assert @p.is_straight(cards)
	end

	def test_is_not_straight		
		cards = ["9B", "3A", "4C", "5D", "6B"]
		assert !@p.is_straight(cards)
	end	

	def test_is_straight_flush		
		cards = ["2A", "3A", "4A", "5A", "6A"]
		assert @p.is_straight_flush(cards)
	end

	def test_is_straight_flush_2		
		cards = ["JA", "8A", "7A", "9A", "10A"]
		assert @p.is_straight_flush(cards)
	end

	def test_is_not_straight_flush		
		cards = ["8A", "3A", "4A", "5A", "6A"]
		assert !@p.is_straight_flush(cards)
	end	

	def test_is_not_straight_flush_2
		cards = ["7A", "3A", "4B", "5A", "6A"]
		assert !@p.is_straight_flush(cards)
	end	

	def test_is_royal_flush
		cards = ["10A", "AA", "KA", "QA", "JA"]
		assert @p.is_royal_flush(cards)
	end

	def test_is_royal_flush_2
		cards = ["10B", "AB", "KB", "QB", "JB"]
		assert @p.is_royal_flush(cards)
	end	

	def test_is__not_royal_flush
		cards = ["10B", "9B", "KB", "QB", "JB"]
		assert !@p.is_royal_flush(cards)
	end		

	def test_is__not_royal_flush_2
		cards = ["10B", "AZ", "KB", "QB", "JB"]
		assert !@p.is_royal_flush(cards)
	end	

	def test_is_not_royal_flush_passing_empty_cards
		cards = []
		assert !@p.is_royal_flush(cards)
	end		

	def test_initialize_all_cards
		assert_equal((@deck.length * @cards.length),  @p.initialize_all_cards(@cards, @deck).length )
	end

	def test_initialize_all_cards_2
		cards = ['2','3','4','5','6','7','8','9','10','J','Q','K', 'A']
		deck = ['D','H']
		assert_equal((@deck.length * @cards.length),  @p.initialize_all_cards(@cards, @deck).length )
	end	

	def test_initialize_all_cards_3
		cards = ['4','5','6','7','8','9','10','J','Q','K', 'A']
		deck = ['D','H','B']
		assert_equal((@deck.length * @cards.length),  @p.initialize_all_cards(@cards, @deck).length )
	end

	def test_create_game_using_players
		players = @p.create_game_using_players(2)
		assert_equal(2, players.length)
		assert_equal(5, players[0].length)
		assert_equal(5, players[1].length)
	end

	def test_create_game_using_players_2
		players = @p.create_game_using_players(3)
		assert_equal(3, players.length)
		assert_equal(5, players[0].length)
		assert_equal(5, players[1].length)
		assert_equal(5, players[2].length)
	end	

	def test_get_points_3
		cards = ["10A", "10D", "10C", "QA", "10S"]
		h = @p.get_points(cards)
		assert_equal(h, 9)
	end

	def test_get_points
		cards = ["10A", "AA", "KA", "QA", "10S"]
		h = @p.get_points(cards)
		assert_equal(h, 3)
	end

	def test_get_points_2
		cards = ["2A", "3A", "4A", "5A", "6A"]
		h = @p.get_points(cards)
		assert_equal(h, 10)
	end

	def test_get_points_4
		cards = ["3C", "3A", "4A", "4C", "6A"]
		h = @p.get_points(cards)
		assert_equal(h, 4)
	end

	def test_get_points_5
		cards = ["2B", "3A", "4A", "5A", "6A"]
		h = @p.get_points(cards)
		assert_equal(h, 6)
	end
			
	def test_get_points_6
		cards = ["5D", "5A", "5F", "AB", "AC"]
		h = @p.get_points(cards)
		assert_equal(h, 8)
	end

	def test_get_points_7
		cards = ["5D", "5A", "5F", "9B", "8C"]
		h = @p.get_points(cards)
		assert_equal(h, 5)
	end

=begin		

		if is_straight(cards)
			return 10
		elsif !check_four(cards).empty?
			return 9
		elsif is_full_house(cards)
			return 8
		elsif is_flush(cards)
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