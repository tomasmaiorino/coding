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
		return Hash[result.sort_by{|k, v| v}.reverse]
	end

	def get_winner(players)
		result = play(players)
		puts "result #{result}"
		return players[result.keys.first]
	end

	def create_game_using_players(players)
		return @p.create_game_using_players(players)
	end

	def lets_play
		players = @p.create_game_using_players(2)
		winner = get_winner(players)
		puts ":) -- The Winner is #{winner} -- :)"
	end

	def is_a_tie(results)
		count = 0
		temp_list = {}
		results.each {|key, value| 
			if temp_list.has_key?[valeu]
				temp_list[valeu] = temp_list[value] + 1
			elsif 
				temp_list[value] = 1
			end
		}
		if results.size == temp_list.size
			return true
		end
		#puts "temp_list #{temp_list}"
		#return count
	end	

end

p = PlayPoker.new
p.lets_play
