require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class GameTest < Test::Unit::TestCase

	#
	# game_initialize
	#
	def test_game_initialize
		game = Game.new
		assert !game.towers.nil? && game.towers.empty?
		assert !game.game_circles.nil? && game.game_circles.empty?
		assert game.actual_move == 0
	end

	#
	# load_towers
	#
	def test_load_towers
		game = Game.new
		towers = game.load_towers(3)
		assert_not_nil(towers)
		assert_not_empty(towers)
		assert_equal(towers.size, 3)
		assert_equal(towers[1].towers_max, 3)
		assert_equal(towers[2].id, 2)
		assert_equal(towers[3].id, 3)
	end

	#
	# load_game
	#
	def test_load_game
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
		assert_not_nil(circles)
		assert_not_empty(circles)
		assert_equal(circles.size, circles_length)
		assert_equal(circles[0].size, 3)

		assert_equal(circles[0].actual_tower.id, game.towers[1].id)
		assert_equal(circles[1].actual_tower.id, game.towers[1].id)
		assert_equal(circles[2].actual_tower.id, game.towers[1].id)

		assert_nil circles[0].previous_tower
		assert_nil circles[1].previous_tower
		assert_nil circles[2].previous_tower

		assert_equal(circles[circles.size - 1].size, 1)
		assert_equal(game.towers[1].tower_circles.size, circles.size)
		assert_equal(game.towers.size, towers_length)
		assert_equal(game.towers[1].tower_circles[0].size, circles[0].size)
		assert_equal(game.towers[1].get_top_circle.size , 1)
	end

	#
	# get_next_empty_tower
	#
	def test_get_next_empty_tower
		game = Game.new
		circles_length = 3
		towers_length = 3
		circles = game.load_game(circles_length, towers_length)
		actual_circle = circles[circles.length - 1]
		empty_tower = game.get_next_empty_tower(game.towers)
		assert_equal(game.towers[2].id, empty_tower.id)
		game.towers[2].add_circle(actual_circle)
		empty_tower = game.get_next_empty_tower(game.towers)
		assert_equal(game.towers[3].id, empty_tower.id)
	end

	def test_get_next_empty_tower_nil
		game = Game.new
		circles_length = 3
		towers_length = 3
		circles = game.load_game(circles_length, towers_length)
		game.towers[3].add_circle(game.game_circles[0])
		game.towers[2].add_circle(game.game_circles[1])
		game.towers[1].add_circle(game.game_circles[2])
		assert_nil game.get_next_empty_tower(game.towers)
	end

	#
	# is_finished
	#
	def test_is_finished_is_not_finished
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		assert !game.finished
	end

	def test_is_finished_is_not_finished_with_one_circle
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		tower_3.add_circle(game.game_circles[circles_length - 1])
		assert !game.finished
	end

	def test_is_finished_is_not_finished_with_two_circle_different_order
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		#add smaller circle
		tower_3.add_circle(game.game_circles[circles_length - 1])
		#add bigger circle
		tower_3.add_circle(game.game_circles[0])
		assert !game.finished
	end

	def test_is_finished_is_not_finished_with_two_circle_right_order
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		#add smaller circle
		tower_3.add_circle(game.game_circles[circles_length - 1])
		#add bigger circle
		tower_3.add_circle(game.game_circles[circles_length - 2])
		assert !game.finished
	end


	def test_is_finished_is_finished_with_two_circle_right_order
		game = Game.new
		circles_length = 3
		towers_length = 3
		game.load_game(circles_length, towers_length)
		tower_3 = game.towers[3]
		#add smaller circle
		tower_3.add_circle(game.game_circles[0])
		tower_3.add_circle(game.game_circles[1])
		tower_3.add_circle(game.game_circles[2])
		assert game.finished
	end

	#
	# get_circle_from_circles_by_size
	#
	def test_get_circle_from_circles_by_size
		game = Game.new
		circles = game.load_game(3,3)
		assert_equal(game.get_circle_from_circles_by_size(circles, 1).size, circles[2].size)
		assert_equal game.get_circle_from_circles_by_size(circles, 2).size, circles[1].size
		assert_equal game.get_circle_from_circles_by_size(circles, 3).size, circles[0].size
	end

=begin
	def test_get_circle_from_circles_by_size_returning_nil
		game = Game.new
		circles = game.load_game(3,3)
		assert_nil(game.get_circle_from_circles_by_size(circles, 4))
		assert_nil game.get_circle_from_circles_by_size(nil, 4)
		assert_nil game.get_circle_from_circles_by_size([], 4)
	end

	def test_get_next_circle_to_move_return_nerver_played_circle
		game = Game.new
		circles = game.load_game(3,3)
		# remove circles from tower_1
		circle_2_removed = game.towers[1].remove_circle(circles[2])
		circle_1_removed = game.towers[1].remove_circle(circles[1])
		#add new circle into each empty tower
		game.towers[2].add_circle(circles[2])
		game.towers[3].add_circle(circles[1])

		circle = game.get_next_circle_to_move

		assert_not_nil circle
		assert_equal circle.size, 3
		assert circle.never_played

		#move the circle 1 to tower 3
		game.towers[3].add_circle(circles[2])
		# move the circle 3 to tower 2
		game.towers[2].add_circle(circles[0])
		# check if the circle 3 moves
		assert !circle.never_played

		#circle = game.get_next_circle_to_move
		#assert_equal circle.size, 1
	end

	def test_get_next_circle_to_move_passing_circle
		game = Game.new
		circles = game.load_game(3,3)

		# remove circles from tower_1
		circle_2_removed = game.towers[1].remove_circle(circles[2])
		circle_1_removed = game.towers[1].remove_circle(circles[1])
		#add new circle into each empty tower
		game.towers[2].add_circle(circles[2])
		game.towers[3].add_circle(circles[1])
		circle_3 = circles[0]

		circle_2 = game.get_next_circle_to_move(circle_3)
		assert_not_nil circle_2
		#assert !circle_2.never_played
		assert_equal circles[2].size, circle_2.size
		assert_equal circle_2.actual_tower.id, game.towers[2].id
		assert !circle_2.last_moved
	end
=end


	#
	# get_next_circles_available_to_move
	#
	def test_get_next_circles_available_to_move
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)

		circle_1_removed = game.towers[1].remove_circle(circles[1])
		circle_1_removed = game.towers[1].remove_circle(circles[2])

		#add circle size 1
		game.towers[2].add_circle(circles[2])
		#add circle size 2
		game.towers[3].add_circle(circles[1])

		circles_available = game.get_next_circles_available_to_move

		assert_not_empty circles_available
		assert_equal 2, circles_available.size
		assert_equal 3, circles_available[0].size
		assert circles_available[0].never_played
		assert_equal 1, circles_available[1].size

		#add circle size 1
		game.towers[2].add_circle(circles[2])

		circles_available = game.get_next_circles_available_to_move

		assert_not_empty circles_available
		assert_equal 2, circles_available.size
		assert_equal 3, circles_available[0].size
		assert circles_available[0].never_played
		assert_equal 2, circles_available[1].size

	end

	def test_get_next_circles_available_to_move_empty
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
		circles_available = game.get_next_circles_available_to_move

		assert_not_empty circles_available
		assert_equal 1, circles_available.size
		assert_equal 1, circles_available[0].size

	end

		#
		# get_all_top_circles_empty
		#
	def test_get_all_top_circles_empty
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)

		circle_1_removed = game.towers[1].remove_circle(circles[0])
		circle_1_removed = game.towers[1].remove_circle(circles[1])
		circle_1_removed = game.towers[1].remove_circle(circles[2])

		circles_top = game.get_all_top_circles

		assert_empty circles_top
	end

	def test_get_all_top_circles
		game = Game.new
		circles = game.load_game(3,3)
		circles_top = game.get_all_top_circles
		assert !circles_top.empty?
		assert_equal circles_top.size, 1
		assert_equal circles_top[0].size, 1

		# remove circle 1 from tower 1 and add into tower 2
		circle_1_removed = game.towers[1].remove_circle(circles[2])
		game.towers[2].add_circle(circles[2])

		circles_top = game.get_all_top_circles

		assert_equal circles_top.size, 2
		assert_equal circles_top[0].size, 2
		assert_equal circles_top[1].size, 1

		# remove circle 1 from tower 1 and add into tower 2
		circle_1_removed = game.towers[1].remove_circle(circles[1])
		game.towers[3].add_circle(circles[1])

		circles_top = game.get_all_top_circles

		assert_equal 3, circles_top.size
		assert_equal 3, circles_top[0].size
		assert_equal 1, circles_top[1].size
		assert_equal 2, circles_top[2].size

	end

	#
	# configure_tower
	#
	def test_configure_tower
		game = Game.new

		game = Game.new
		game.load_game(3,3)

		tower_3 = game.towers[3]
		tower_2 = game.towers[2]
		tower_1 = game.towers[1]

		circle_1 = game.game_circles[2]
		circle_2 = game.game_circles[1]
		circle_3 = game.game_circles[0]

		tower_1.change_circle circle_3
		tower_1.change_circle circle_2
		#tower_2.add_circle circle_2
		tower_2.change_circle circle_1

		#check tower 2 top circle
		assert tower_1.get_top_circle.size == 2
		#check tower 2 top circle
		assert tower_2.get_top_circle.size == 1

		assert circle_1.last_moved
		temp_towers = game.get_all_towers_available
		towers = game.configure_tower(temp_towers, circle_2)

		assert_not_empty towers
		assert_equal 3, towers[0].id

		tower_3.change_circle circle_2

		puts "-------------------"
		puts tower_3.to_s
		puts tower_2.to_s
		puts tower_1.to_s

		towers =  game.configure_tower(temp_towers, circle_1)

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 3, towers[1].id

		tower_3.change_circle circle_1

		towers =  game.configure_tower(temp_towers, circle_3)
		puts "-------------------"
		puts tower_3.to_s
		puts tower_2.to_s
		puts tower_1.to_s

		assert towers.size == 1
		assert_equal 2, towers[0].id
		assert_empty towers[0].tower_circles

		tower_2.change_circle circle_1

		puts "-------------------"
		puts tower_3.to_s
		puts tower_2.to_s
		puts tower_1.to_s

		towers =  game.configure_tower(temp_towers, circle_3)



		assert_empty towers

	end

	#
	# move
	#
	def test_move
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
		#puts "moves count #{game.game_circles[0].moves_count}"
	 	game.move
		#puts "=============== moves count #{count}"
	end

	#
	# contain_empty_towers
	#
	def test_contain_empty_towers
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)
		assert game.contain_empty_towers(game.towers)

		tower_2 = game.towers[2]
		tower_3 = game.towers[3]

		tower_2.change_circle game.game_circles[1]
		tower_3.change_circle game.game_circles[2]

		assert !game.contain_empty_towers(game.towers)
	end

	#
	# get_towers_with_smaller_circles
	#
	def test_get_towers_with_smaller_circles
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)

		tower_2 = game.towers[2]
		tower_3 = game.towers[3]

		tower_2.change_circle game.game_circles[1]
		tower_3.change_circle game.game_circles[2]

		towers = [tower_2, tower_3]
		smaller_circle = game.get_towers_with_smaller_circles(towers)

		towers = [tower_2, game.towers[1]]
		smaller_circle = game.get_towers_with_smaller_circles(towers)
		assert_equal game.game_circles[1].size, smaller_circle.size

		towers = [tower_3, game.towers[1]]
		smaller_circle = game.get_towers_with_smaller_circles(towers)
		assert_equal game.game_circles[2].size, smaller_circle.size
	end

	#
	# is_all_games_circles_ordered
	#
	def test_is_all_games_circles_ordered
		circles_length = 3
		towers_length = 3
		game = Game.new
		circles = game.load_game(circles_length, towers_length)

		assert game.is_all_games_circles_ordered(game.towers[1])

		tower_1 = game.towers[1]
		tower_2 = game.towers[2]
		tower_3 = game.towers[3]

		tower_2.change_circle game.game_circles[2]

		assert !game.is_all_games_circles_ordered(game.towers[1])

		tower_3.change_circle game.game_circles[0]
		tower_3.change_circle game.game_circles[1]
		tower_3.change_circle game.game_circles[2]

		assert !game.is_all_games_circles_ordered(game.towers[1])
		assert game.is_all_games_circles_ordered(game.towers[3])

		tower_2.change_circle game.game_circles[2]

		assert !game.is_all_games_circles_ordered(game.towers[3])
	end
end
