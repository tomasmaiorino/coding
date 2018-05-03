require_relative 'player'
require_relative 'play_poker'
require_relative 'poker'
require_relative 'match'

print 'Type the numbers of the players: '
players_number = gets.to_i
while players_number > 4 || players_number <= 1
	print 'You must choose between two until four players. If want to abort, type 0: '
	players_number = gets.to_i
	if players_number == 0
	  abort("Bye !! Thanks for play :)")
	end
end
m = Match.new(players_number, [])
result = m.play
m.print_players
player = [result[result.keys.first]]
if m.is_a_tie(result)
	players = []
	result.each{|key, value|
		players << value
	}
	player = m.get_higher_player(players)
end
puts "The winner is player:"
puts "Player #{player[0].id} with a #{player[0].game_name} and this cards #{player[0].cards}"
