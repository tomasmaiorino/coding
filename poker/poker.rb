class Poker

	def initialize
		@cards = ['2','3','4','5','6','7','8','9','10','J','Q','K', 'A']
		@deck = ['D','H','S','C']
		@all_cards = initialize_all_cards(@cards, @deck)
	end

	def create_cards(type_card, cards)
		c = []
		return nil if type_card == nil || type_card.empty? || cards == nil || cards.empty?
		cards.each {|x|
			r = "#{x}#{type_card}"
			c.push(r)
		}
		return c
	end

	def create_game_using_players(p_players)
		players = {}
		if !p_players.nil? && p_players > 0
			car = []
			for i in 0..p_players - 1
				car = create_game(@all_cards, car)
				players[i] = car			
			end		
		end
		return players
	end

	def create_game(all_cards, c = [])
		g = []
		rand = Random.new
		if all_cards != nil && !all_cards.empty?
			while g.length < 5
				x = all_cards[rand.rand(0..all_cards.length - 1)]
				if !g.include?(x)
					if c.length == 0 || c.length > 0 && !c.include?(x)
						g << x
					end
				end
			end
		end
		return g
	end

	def sort_cards(model, to_order)
		n = []
		if to_order != nil && !to_order.empty?
			model.each_with_index do |item, index|
		  		to_order.each_with_index do |val, ind|
		  			if model[index.to_i] == to_order[ind][0, to_order[ind].length - 1]
			  				n << to_order[ind]
		  			end	
		  		end
		  	end
		  end
	  	return n
	end	

	def check_pair(cards)
		return get_sets(cards, 2)
	end

	def get_sets(cards, numbers_to_match)
		n = {}
		if cards != nil && !cards.empty?
			cards_without_n = remove_n(cards)			
			cards_without_n.each_with_index { |val, ind|
				if cards_without_n.count(val) == numbers_to_match				
					indexes = cards_without_n.size.times.select {|i| cards_without_n[i] == cards_without_n[ind.to_i]}
					n[val] = indexes
				end
			}
		end
		return n
	end

	def remove_n(cards)
		n = []
		if cards != nil && !cards.empty?
			cards.each {|v| 
				n << v[0, v.length - 1]
			}
		end
		return n
	end

	def check_three(cards)
		return get_sets(cards, 3)
	end

	def check_four(cards)
		return get_sets(cards, 4)
	end

	def check_full_house(cards)
		check_three(cards).length == 1 && check_pair(cards).length == 1
	end

	def check_all_cards_for_same_naipe(cards)
		v = true
		cards.each_with_index{|val, ind|
			cards.each_with_index{|ival, iind|
				if cards[ind][val.length - 1] != cards[iind][ival.length - 1]
					v = false
					break
				end
			}
		}
		return v
	end

	def check_all_cards_in_sequence(cards)
		cards_without_n = remove_n(sort_cards(@cards, cards))
		s = true
		cards_without_n.each_with_index{|val, ind|
			# check if the card is a number
			if val.match(/\d/) != nil
				# check if this is the last one
				if ind < cards_without_n.length - 1
					# check if the actual card is a 10
					if val.to_i == 10 
						if cards_without_n[ind + 1] != "J"
							s = false
						end
					elsif (val.to_i + 1 != cards_without_n[ind  + 1].to_i)
						s = false
					end
				end
			else
				if ind < cards_without_n.length - 1
					if val == 'J' && cards_without_n[ind + 1]  != 'Q' || val == 'Q' && cards_without_n[ind + 1] != 'K' ||  val == 'K' && cards_without_n[ind + 1] != 'A'
						s = false
					end
				end	
			end
		}
		return s
	end

	def if_full_house(cards)
		t = check_three(cards)
		p = check_pair(cards)
		!t.empty? && t.length == 1 and !p.empty? && p.length == 1
	end

	def is_straight(cards)
		check_all_cards_in_sequence(cards)
	end

	def is_straight_flush(cards)
		check_all_cards_in_sequence(cards) && check_all_cards_for_same_naipe(cards)
	end

	def is_royal_flush(cards)
		sorted_cards = sort_cards(@cards, cards)
		is_straight_flush(cards) && !sorted_cards.empty? && sorted_cards[0][0,2] == '10'
	end

	def initialize_all_cards(cards, deck)
		all_cards = []
		if !cards.nil? && !cards.empty? && !deck.nil?  && !deck.empty?
			deck.each{ |val|
				#puts  create_cards(val, cards_without_n)	
				all_cards.concat create_cards(val, cards)
			}
		end
		return all_cards
	end

	def get_higher_card(cards)
		h = nil
		if !cards.nil? && !cards.empty?
			cards.each_with_index{|val, ind|
				if val.match(/\d/) != nil
					h ||= val
					h = val unless h > val
				else
	 #(x & c) == c
				end
			}
		end
	end
end
=begin
#create all cards
all_cards = d + h + s + c

#get player_one cards
player_one = create_game(all_cards)
#get player_two cards
player_two = create_game(all_cards, player_one)
#get player_tree cards
player_tree = create_game(all_cards, player_one + player_two)
#get player_four cards
player_four = create_game(all_cards, player_one + player_two + player_tree)

puts "player_one #{player_one}"
puts "player_two #{player_two}"
puts "player_tree #{player_tree}"
puts "player_four #{player_four}"

puts "UnOrdered player_two #{player_one}"
player_one = sort_cards(cards, player_one)
puts "Ordered player_one #{player_one}"

puts "UnOrdered player_two #{player_two}"
player_two = sort_cards(cards, player_two)
puts "Ordered player_two #{player_two}"

puts "UnOrdered player_two #{player_tree}"
player_tree = sort_cards(cards, player_tree)
puts "Ordered player_two #{player_tree}"

puts "UnOrdered player_two #{player_four}"
player_four = sort_cards(cards, player_four)
puts "Ordered player_two #{player_four}"

one = check_pair(player_one)
puts "One has pair: #{one.length > 0}"
puts "One has two pairs: #{one.length == 2}"

one = check_three(player_one)

#winner = gets_winner(player_one, player_two, player_tree, player_four)
=end

#puts "The winner is #{winner}"
=begin
Carta Alta: A carta de maior valor.
Um Par: Duas cartas do mesmo valor.
Dois Pares: Dois pares diferentes.
Trinca: Três cartas do mesmo valor e duas de valores diferentes.
Straight (seqüência): Todas as carta com valores consecutivos.
Flush: Todas as cartas do mesmo naipe.
Full House: Um trinca e um par.
Quadra: Quatro cartas do mesmo valor.
Straight Flush: Todas as cartas são consecutivas e do mesmo naipe.
Royal Flush: A seqüência 10, Valete, Dama, Rei, Ás, do mesmo naipe.
As cartas são, em ordem crescente de valor: 2, 3, 4, 5, 6, 7, 8, 9, 10, Valete, Dama, Rei, Ás.
Os naipes são: Ouro (D), Copa (H), Espadas (S), Paus (C)
=end