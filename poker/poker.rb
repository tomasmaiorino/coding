class Poker

	def initialize
		@cards = ['2','3','4','5','6','7','8','9','10','J','Q','K', 'A']
		@deck = ['D','H','S','C']
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
	#	puts "model #{model}"
	#	puts "to_order #{to_order}"
		model.each_with_index do |item, index|
	  		#puts "current_index: #{index} value #{model[index.to_i]}"
	  		to_order.each_with_index do |val, ind|
	  			if model[index.to_i] == to_order[ind][0, to_order[ind].length - 1]
	  				#t[0, t.length - 1]
		  				#puts "has #{to_order[ind]}"
		  				n << to_order[ind]
	  			end	
	  			#puts "current_index to order: #{ind} value #{model[val.to_i]}"
	  			#puts "main index #{index}"
	  		end
	  		#if to_order.include?(model[index])
	  		#	puts "adding #{model[index]}"
	  		#	n << model[index]
	  		#end
	  	end
	  	return n
	end	

	def check_pair(cards)
		return get_sets(cards, 2)
	end

	def get_sets(cards, numbers_to_match)
		puts "Cards received: #{cards}"
		n = {}
		if cards != nil && !cards.empty?
			cards_without_n = remove_n(cards)
			puts "Cards without naipe: #{cards_without_n}"
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
		ordered_cards = sort_cards(@cards, cards)
		puts "ordered_cards #{ordered_cards}"
	end
end
=begin
#create all cards
d = create_cards('D', cards)
h = create_cards('H', cards)
s = create_cards('S', cards)
c = create_cards('C', cards)

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