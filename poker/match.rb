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
		#return PlayerPoker.new.
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
		return players
	end
end

print 'Type the numbers of the players: '
players_number = gets.to_i
while players_number > 4
	print 'We can choose only four players. If want to stop, type 0: '
	players_number = gets.to_i
end
m = Match.new(players_number, [])
puts "get_players_cards #{m.get_players_cards}"
