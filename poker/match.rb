require_relative 'player'

class Match

	attr_accessor :players

	def initialize(players = [])
		if !players.nil? && players.length > 0
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
			cards.concat(value)
		}
		return cards
	end

end
