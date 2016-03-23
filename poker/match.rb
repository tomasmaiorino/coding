require_relative 'player'
require_relative 'play_poker'
require_relative 'poker'

class Match

	attr_accessor :players

	def initialize(players_number = 0, players = [])
		@play_poker = PlayPoker.new
		load_game(players_number, players)
  	end

	def get_players_cards
		cards = []
		@players.each{|key, value|
			cards.concat(value.cards)
		}
		return cards
	end

	def play
		@players = @play_poker.play(@players)
		#puts "players #{@players}"
		#puts "Hash[@players.sort_by #{Hash[@players.sort_by{|k, v| v.points}.reverse]}"
		return Hash[@players.sort_by{|k, v| v.points}.reverse]
	end

	def load_game(players_number, players)
		#if the players number was informed, treat like a new game
		#create the players
		if players_number > 0
			for i in 0..players_number - 1
					players << Player.new([], i + 1)
			end
			#set the players cards
			players = @play_poker.create_game_using_players(players)
		end
		#configure Match object players
		if !players.nil? && players.length > 0
			@players = {}
			players.each{|v|
				@players[v.id] = v
			}
		else
			@players = {}
		end
		print "Players: #{players.size}\n"
		return players
	end

	def is_a_tie(players)
		points = {}
		players.each {|key, value|
			if points.has_key?(value.points)
				points[value.points] = points[value.points] + 1
			elsif
				points[value.points] = 1
			end
		}
		return false if points.size == players.size
		puts "points #{points}"

		# get higher point and check if there is more than one player with this point
		points = Hash[points.sort]
		if points[points.keys.first] == 1
			return false
		end
	end

	def get_players_by_point(point)
		players = []
		@players.each{|key, value|
			players << value if value.points == point
		}
		return players
	end

	def get_higher_player(players)
		points = players[0].points
		if points == ConstClass::A_PAIR
			h = nil
			players.each{|player|
				pair = @play_poker.p.check_pair(player.cards)
				cards = {}
				pair.each{|key, value|
					value.each{|i|
					player.points_cards << player.cards[i]	
					}
				}
			}
		elsif points == ConstClass::A_PAIR

		end
	end

end
=begin
print 'Type the numbers of the players: '
players_number = gets.to_i
while players_number > 4
	print 'We can choose only four players. If want to stop, type 0: '
	players_number = gets.to_i
	if players_number == 0
	  abort("Bye !! Thanks for play :)")
	end
end
m = Match.new(players_number, [])
puts "get_players_cards #{m.get_players_cards}"
=end
