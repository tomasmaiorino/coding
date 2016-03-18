require_relative 'poker'
class PlayPoker
	attr_accessor :p

	def initialize
		@p = Poker.new
	end

	def play(players)
		#
		result = {}
		players.each {|key, value|
  			result[key] = @p.get_points(value)
		}
		puts Hash[result.sort_by{|k, v| v}.reverse]
		return result
	end

	def create_game_using_players(players)
		return @p.create_game_using_players(players)
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
