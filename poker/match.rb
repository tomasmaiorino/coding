require_relative 'player'
require_relative 'play_poker'

class Match

	attr_accessor :players

	def initialize(players = [])
		if !players.nil? && players.length > 0
			@players = {}
			players.each{|v|
				@players[v.id] = v
			}
		else
			@players = {}
		end
	end

	def get_players_cards
		cards = []
		@players.each{|key, value|
			cards.concat(value.cards)
		}
		return cards
	end

	def load_game
		players = []
		for i in 0..p - 2
				players << Player.new([], i + 1)
		end
		return players
	end
end
#players = Match.new().load_game
#m = Match.new(players)
#p = PlayPoker.new
#p.lets_play(m)
