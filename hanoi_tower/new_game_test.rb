require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'new_game'
class NewGameTest < Test::Unit::TestCase

	#
	# game_initialize
	#
	def test_game_initialize
		game = NewGame.new
		assert !game.towers.nil? && game.towers.empty?
		assert !game.game_circles.nil? && game.game_circles.empty?
		assert game.actual_move == 0
	end

	#
	# load_towers
	#
	def test_load_towers
		game = NewGame.new
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
		game = NewGame.new
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
	# get_all_towers_available
	#
	def test_get_all_towers_available
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		towers = game.get_all_towers_available

		assert_not_empty towers
		assert_equal 3, towers.size
		assert_not_nil towers
	end

	#
	# get_all_towers_available
	#
	def test_get_destiny_tower
		circles_length = 3
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		
		tower = game.get_destiny_tower(game.towers)

		assert_not_nil tower
		assert_equal 4, tower.id
		assert_empty tower.tower_circles
	end


	#
	# get_all_top_circles
	#
	def test_get_all_top_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		
		circles = game.get_all_top_circles

		assert_not_nil circles
		assert_not_empty circles
		assert_equal 1, circles.size

		game.towers[2].change_circle game.game_circles[2]

		circles = game.get_all_top_circles

		assert_not_nil circles
		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 2, circles[0].size
		assert_equal 1, circles[1].size

	end

	#
	# contains_circles_by_size
	#
	def test_contains_circles_by_size
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)

		assert game.contains_circles_by_size(circles, 2)
		assert game.contains_circles_by_size(circles, 1)
		assert game.contains_circles_by_size(circles, 3)

		circles.pop

		assert game.contains_circles_by_size(circles, 2)
		assert !game.contains_circles_by_size(circles, 1)
		assert game.contains_circles_by_size(circles, 3)

		circles.pop

		assert !game.contains_circles_by_size(circles, 2)
		assert !game.contains_circles_by_size(circles, 1)
		assert game.contains_circles_by_size(circles, 3)
	end

	#
	# get_all_tower_with_empty_circles
	#
	def test_get_all_tower_with_empty_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		game.load_game(circles_length, towers_length)

		towers = game.get_all_tower_with_empty_circles(game.towers, true)

		assert_not_empty towers
		assert_equal 2, towers.size
		assert_equal 2, towers[0].id

		towers = game.get_all_tower_with_empty_circles(game.towers, false)

		assert_not_empty towers
		assert_equal 1, towers.size


		game.towers[2].change_circle game.game_circles[2]

		towers = game.get_all_tower_with_empty_circles(game.towers, true)

		assert_not_empty towers
		assert_equal 1, towers.size
		assert_equal 3, towers[0].id

		towers = game.get_all_tower_with_empty_circles(game.towers, false)

		assert_not_empty towers
		assert_equal 2, towers.size
		assert_equal 1, towers[0].id
		assert_equal 2, towers[1].id

	end

	#
	# get_towers_available_from_circle
	#
	def test_get_towers_available_from_circle
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		towers = game.get_towers_available_from_circle(game.towers, circles[2])

		assert_empty towers

		game.towers[2].change_circle game.game_circles[2]

		towers = game.get_towers_available_from_circle(game.towers, circles[2])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 1, towers.size

		game.towers[3].change_circle game.game_circles[1]

		towers = game.get_towers_available_from_circle(game.towers, circles[2])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 2, towers.size

		towers = game.get_towers_available_from_circle(game.towers, circles[1])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 1, towers.size
	end

	#
	# do_get_availables_circles
	#
	def test_do_get_availables_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		game.load_game(circles_length, towers_length)

		game.towers[2].change_circle game.game_circles[2]

		circles = game.do_get_availables_circles true

		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 2, circles[0].size

		circles = game.do_get_availables_circles false

		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 2, circles[0].size
		assert_equal 1, circles[1].size

		game.towers[3].change_circle game.game_circles[1]
		game.towers[3].change_circle game.game_circles[2]

		circles = game.do_get_availables_circles true

		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 3, circles[0].size
		
		circles = game.do_get_availables_circles false

		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 3, circles[0].size
		assert_equal 1, circles[1].size

	end

	#
	# get_availables_circles
	#
	def test_get_availables_circles
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		game.load_game(circles_length, towers_length)

		circles = game.get_availables_circles
		
		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 1, circles[0].size

		game.towers[2].change_circle game.game_circles[2]

		circles = game.get_availables_circles
		
		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 1, circles[0].size

		game.towers[3].change_circle game.game_circles[0]

		circles = game.get_availables_circles
		
		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 1, circles[0].size
		assert_equal 2, circles[1].size

	end

	#
	# treat_destiny_towers
	#
	def test_treat_destiny_towers
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)

		circles_temp = [circles[2], circles[1]]
		move =  game.treat_destiny_towers(game.towers, circles_temp)
		assert_nil move

		circles_temp = [circles[2], circles[0]]
		move =  game.treat_destiny_towers(game.towers, circles_temp)
		assert_not_nil move
		assert_equal 4, move.tower.id
		assert_equal 4, move.circle.size

		game.towers[4].change_circle circles[0]
		circles_temp = [circles[3], circles[1]]
		move =  game.treat_destiny_towers(game.towers, circles_temp)

		assert_not_nil move
		assert_equal 4, move.tower.id
		assert_equal 3, move.circle.size

		game.towers[4].change_circle circles[1]
		circles_temp = [circles[3], circles[2]]
		move =  game.treat_destiny_towers(game.towers, circles_temp)

		assert_not_nil move
		assert_equal 4, move.tower.id
		assert_equal 2, move.circle.size

	end

	#
	# get_next_move
	#
	def test_get_next_move
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)

		game.towers[1].change_circle(circles[0])
		game.towers[1].change_circle(circles[1])

		game.towers[2].change_circle(circles[2])
		game.towers[2].change_circle(circles[3])
		
		#first set
		move = game.get_next_move(circles[3], circles)

		assert_not_nil move
		assert_equal 1, move.next_tower.id
		assert_equal 2, move.next_circle.size
		assert_equal move.next_tower.get_top_circle.size - 1, move.next_circle.size
		assert_nil move.tower
		assert_nil move.circle
		assert_not_nil move.game

		#second set
		game.towers[4].change_circle(circles[1])
		
		move = game.get_next_move(circles[3], circles)

		assert_not_nil move
		assert_equal 4, move.next_tower.id
		assert_equal 2, move.next_circle.size
		assert_equal move.next_tower.get_top_circle.size - 1, move.next_circle.size
		assert_nil move.tower
		assert_nil move.circle
		assert_not_nil move.game

		#third set
		game.towers[4].change_circle(circles[1])
		game.towers[4].change_circle(circles[3])
				
		move = game.get_next_move(circles[3], circles)

		assert_not_nil move
		assert_equal 1, move.next_tower.id
		assert_equal 3, move.next_circle.size
		assert_equal move.next_tower.get_top_circle.size - 1, move.next_circle.size
		assert_nil move.tower
		assert_nil move.circle
		assert_not_nil move.game

		#fourth set		
		game.towers[3].change_circle(circles[0])
		game.towers[3].change_circle(circles[1])
		game.towers[3].change_circle(circles[2])
		game.towers[3].change_circle(circles[3])

		
		game.towers[4].change_circle(circles[0])
		game.towers[4].change_circle(circles[2])
		game.towers[4].change_circle(circles[3])
		
				
		move = game.get_next_move(circles[3], circles)

		assert_not_nil move
		assert_equal 3, move.next_tower.id
		assert_equal 2, move.next_circle.size
		assert_equal move.next_tower.get_top_circle.size - 1, move.next_circle.size
		assert_nil move.tower
		assert_nil move.circle
		assert_not_nil move.game

	end

	#
	# get_next_move with empty towers
	#
	def test_get_next_move_with_empty
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
			
		move = game.get_next_move(circles[3], circles, false)

		assert_not_nil move
		assert_equal 2, move.next_tower.id
		assert_equal 2, move.next_circle.size
		assert_nil move.next_tower.get_top_circle
		assert_empty move.next_tower.tower_circles
		assert_nil move.tower
		assert_nil move.circle
		assert_not_nil move.game
	end

	#
	# get_next_tower_with_closest_circle
	#
	def test_get_next_tower_with_closest_circle
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)

		#first set
		towers = game.get_next_tower_with_closest_circle(game.towers, game.game_circles[4])

		assert_empty towers

		#second set
		game.towers[2].change_circle circles[3]
		towers = game.get_next_tower_with_closest_circle(game.towers, circles[3])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 1, towers.size

		#third set
		game.towers[2].change_circle circles[3]
		game.towers[3].change_circle circles[2]

		towers = game.get_next_tower_with_closest_circle(game.towers, circles[3])

		assert_not_empty towers
		assert_equal 3, towers[0].id
		assert_equal 2, towers.size

		#fourth set
		game.towers[2].change_circle circles[3]
		game.towers[3].change_circle circles[2]

		towers = game.get_next_tower_with_closest_circle(game.towers, circles[2])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 1, towers.size


		#fourth set
		game.towers[2].change_circle circles[3]
		game.towers[3].change_circle circles[2]
		game.towers[4].change_circle circles[1]

		towers = game.get_next_tower_with_closest_circle(game.towers, circles[2])

		assert_not_empty towers
		assert_equal 4, towers[0].id
		assert_equal 1, towers[1].id
		assert_equal 2, towers.size

		#fifth set
		towers = game.get_next_tower_with_closest_circle(game.towers, circles[3])

		assert_not_empty towers
		assert_equal 3, towers[0].id
		assert_equal 4, towers[1].id
		assert_equal 1, towers[2].id
		assert_equal 3, towers.size

		#sixth set
		towers = game.get_next_tower_with_closest_circle(game.towers, circles[1])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 1, towers.size

		#sevenh set
		game.towers[3].change_circle circles[3]
		towers = game.get_next_tower_with_closest_circle(game.towers, circles[3])

		assert_not_empty towers
		assert_equal 4, towers[0].id
		assert towers[0].get_top_circle.size > circles[3].size
		assert_equal 1, towers[1].id
		assert_equal 2, towers.size

	end

	#
	# treat_next_move_conflict
	#
	def test_treat_next_move_conflict
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circle_to_move_1 = circles[2]
		circle_to_move_2 = circles[3]

		#first set
		move = Move.new(nil, nil, game.towers[2], circle_to_move_1, nil)
		towers_temp = [game.towers[2]]

		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_nil move.tower
		assert_nil move.circle
		assert_equal 2, move.next_tower.id

		game.treat_next_move_conflict(move, towers_temp, circle_to_move_2, nil)

		assert_equal 2, move.tower.id
		assert_nil move.next_tower
		assert_nil move.next_circle
		assert_not_nil move.tower
		assert_not_nil move.circle

		#second set
		move = Move.new(nil, nil, game.towers[2], circle_to_move_1, nil)
		towers_temp = [game.towers[2], game.towers[3], game.towers[4]]

		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_nil move.tower
		assert_nil move.circle
		assert_equal 2, move.next_tower.id

		game.treat_next_move_conflict(move, towers_temp, circle_to_move_2, nil)

		assert_equal 3, move.tower.id	
		assert_not_nil move.circle
		assert_not_nil move.tower
		assert_equal circle_to_move_2.size, move.circle.size
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_equal circle_to_move_1.size, move.next_circle.size
		assert_equal game.towers[2].id, move.next_tower.id

		#third set
		move = Move.new(nil, nil, game.towers[3], circle_to_move_1, nil)
		towers_temp = [game.towers[3], game.towers[1], game.towers[4]]

		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_nil move.tower
		assert_nil move.circle
		assert_equal 3, move.next_tower.id

		game.treat_next_move_conflict(move, towers_temp, circle_to_move_2, nil)

		assert_equal 1, move.tower.id	
		assert_not_nil move.circle
		assert_not_nil move.tower
		assert_equal circle_to_move_2.size, move.circle.size
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_equal circle_to_move_1.size, move.next_circle.size
		assert_equal game.towers[3].id, move.next_tower.id
	end

	#
	# get_move
	#
	def test_get_move_four_circle_three_towers
		circles_length = 4
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count
		#first move
		move = game.get_move
		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.actual_tower.id

		move.does_move
		
		assert_equal 3, move.circle.actual_tower.id
		#second move
		move = game.get_move
		assert_equal 2, move.circle.size
		assert_equal 2, move.tower.id

		assert_equal 1, move.circle.actual_tower.id

		move.does_move

		#third move
		assert_equal 2, move.circle.actual_tower.id

		move = nil
		move = game.get_move

		assert_equal 1, move.circle.size
		assert_equal 2, move.tower.id
		assert_equal 3, move.circle.actual_tower.id

		move.does_move

		assert_equal 2, move.circle.actual_tower.id
		assert_equal 2, move.tower.id

		move = nil
		move = game.get_move
		
		assert_equal 3, move.circle.size
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.actual_tower.id

		move.does_move

		assert_equal 3, move.circle.actual_tower.id
		
		move = nil
		move = game.get_move
		
		assert_equal 1, move.circle.size
		assert_equal 1, move.tower.id
		assert_equal 2, move.circle.actual_tower.id

		assert_not_nil move.next_tower
		assert_not_nil move.next_circle

		assert_equal 2, move.next_circle.size
		assert_equal 3, move.next_tower.id
		assert_equal 1, move.circle.size
		assert_equal 1, move.tower.id
		assert_equal 2, move.circle.actual_tower.id

		move.does_move
		move.does_next_move

		assert_equal 3, move.next_circle.actual_tower.id
		assert_equal move.next_circle.size, move.next_tower.get_top_circle.size
		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.tower.get_top_circle.size

		move = nil
		move = game.get_move		

		assert_nil move.next_tower
		assert_nil move.next_circle
		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 2, move.tower.id
		assert_equal 4, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 2, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 1, move.tower.id
		assert_equal 2, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 1, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move
		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 2, move.tower.id
		assert_equal 3, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.size
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_equal 2, move.next_tower.id
		assert_equal 2, move.next_circle.size

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 1, move.next_circle.actual_tower.id
		assert_equal move.circle.size, move.next_circle.actual_tower.get_top_circle.size

		move.does_move
		move.does_next_move

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 2, move.next_circle.actual_tower.id
		assert_equal move.next_circle.size, move.next_circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 2, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 1, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 2, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle


		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 1, move.tower.id
		assert_equal 3, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size


		move = nil
		#circle 1 tower 2
		#circle 2 tower 1
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 2, move.tower.id
		assert_equal 1, move.circle.size
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_equal 1, move.next_tower.id
		assert_equal 2, move.next_circle.size

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 3, move.next_circle.actual_tower.id
		assert_equal move.circle.size, move.next_circle.actual_tower.get_top_circle.size

		move.does_move
		move.does_next_move

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 1, move.next_circle.actual_tower.id
		assert_equal move.next_circle.size, move.next_circle.actual_tower.get_top_circle.size

		#circle 1 tower 1
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 1, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		move.does_move

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size

		#circle 4 tower 3
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 4, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 4, game.towers[3].get_top_circle.size

		#circle 1 tower 3
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 1, game.towers[3].get_top_circle.size

		#circle 2 tower 2
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 2, move.tower.id
		assert_equal 2, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 2, game.towers[2].get_top_circle.size

		#circle 1 tower 2
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 2, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		assert_equal 2, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 1, game.towers[2].get_top_circle.size

		#circle 3 tower 3
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 3, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		assert_equal 3, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 3, game.towers[3].get_top_circle.size

		#circle 1 tower 1
		#circle 2 tower 3
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 1, move.tower.id
		assert_equal 1, move.circle.size
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_equal 3, move.next_tower.id
		assert_equal 2, move.next_circle.size

		move.does_move
		move.does_next_move

		assert_equal 1, move.circle.actual_tower.id
		assert_equal move.circle.size, move.circle.actual_tower.get_top_circle.size
		assert_equal 1, game.towers[1].get_top_circle.size

		assert_equal 3, move.next_circle.actual_tower.id
		assert_equal move.next_circle.size, move.next_circle.actual_tower.get_top_circle.size
		assert_equal 2, game.towers[3].get_top_circle.size

		assert !game.finished
		move = nil
		move = game.get_move

		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.size
		assert_nil move.next_tower
		assert_nil move.next_circle

		move.does_move

		assert game.finished

	end

	#
	# finished
	#
	def test_finished
		circles_length = 4
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)

		assert !game.finished
		
		game.towers[3].change_circle circles[0]

		assert !game.finished

		game.towers[3].change_circle circles[3]

		assert !game.finished

		game.towers[2].change_circle circles[3]
		assert !game.finished
		game.towers[3].change_circle circles[1]
		assert !game.finished
		game.towers[3].change_circle circles[2]
		assert !game.finished
		game.towers[3].change_circle circles[3]
		assert game.finished

	end

	#
	# get_move
	#
	def test_get_move_three_circle_three_towers
		circles_length = 3
		towers_length = 3
		game = NewGame.new		
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count	
		#circle 1 tower 3
		move = game.get_move
		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.actual_tower.id

		move.does_move
		
		assert_equal 3, move.circle.actual_tower.id
		assert !game.finished

		#circle 2 tower 2
		move = game.get_move
		assert_equal 2, move.circle.size
		assert_equal 2, move.tower.id
		assert_nil move.next_circle
		assert_nil move.next_tower

		move.does_move
		assert_equal 2, game.towers[2].get_top_circle.size
		assert !game.finished

		#circle 1 tower 2
		move = game.get_move
		assert_equal 1, move.circle.size
		assert_equal 2, move.tower.id
		assert_nil move.next_circle
		assert_nil move.next_tower

		move.does_move
		assert_equal 1, game.towers[2].get_top_circle.size
		assert !game.finished

		#circle 3 tower 3
		move = game.get_move
		assert_equal 3, move.circle.size
		assert_equal 3, move.tower.id
		assert_nil move.next_circle
		assert_nil move.next_tower

		move.does_move
		assert_equal 3, game.towers[3].get_top_circle.size
		assert !game.finished

		#circle 1 tower 1
		#circle 2 tower 3
		move = game.get_move
		assert_equal 1, move.circle.size
		assert_equal 1, move.tower.id
		assert_not_nil move.next_circle
		assert_not_nil move.next_tower
		assert_equal 2, move.next_circle.size
		assert_equal 3, move.next_tower.id
		
		move.does_move
		move.does_next_move

		assert_equal 1, game.towers[1].get_top_circle.size
		assert_equal 2, game.towers[3].get_top_circle.size
		assert !game.finished

		#circle 1 tower 1
		move = game.get_move
		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id
		assert_nil move.next_circle
		assert_nil move.next_tower

		assert !game.finished
		move.does_move
		assert game.finished

	end

	#
	# move
	#
	def test_move
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count
		#circle 1 tower 3
		move = game.move(nil)

		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.actual_tower.id

		#circle 2 tower 2
		move = game.move(move)

		#check move does results
		assert_equal 3, circles[2].actual_tower.id
		assert_equal 1, game.towers[3].get_top_circle.size
		#check get_move results
		assert_equal 2, move.circle.size
		assert_equal 2, move.tower.id

		#circle 1 tower 2
		move = game.move(move)

		#check move does results
		assert_equal 2, circles[1].actual_tower.id
		assert_equal 2, game.towers[2].get_top_circle.size
		#check get_move results
		assert_equal 1, move.circle.size
		assert_equal 2, move.tower.id

		#circle 3 tower 3
		move = game.move(move)

		#check move does results
		assert_equal 2, circles[2].actual_tower.id
		assert_equal 1, game.towers[2].get_top_circle.size
		#check get_move results
		assert_equal 3, move.circle.size
		assert_equal 3, move.tower.id

		#circle 1 tower 1
		move = game.move(move)

		#check move does results
		assert_equal 3, circles[0].actual_tower.id
		assert_equal 3, game.towers[3].get_top_circle.size

		#check get_move results
		assert_equal 1, move.circle.size
		assert_equal 1, move.tower.id
		#check get_move results
		assert_equal 2, move.next_circle.size
		assert_equal 3, move.next_tower.id

		#circle 1 tower 3
		move = game.move(move)
		assert_nil move.moves_count

		#check move does results
		assert_equal 3, circles[1].actual_tower.id
		assert_equal 2, game.towers[3].get_top_circle.size
		assert_equal 1, circles[2].actual_tower.id
		assert_equal 1, game.towers[1].get_top_circle.size

		#check get_move results
		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id

		#circle 1 tower 3
		move = game.move(move)
		assert_not_nil move.moves_count
		assert_equal Circle.moves_count, move.moves_count

		move = game.move(nil)
		assert_not_nil move.moves_count
		assert_equal Circle.moves_count, move.moves_count
	end

	#
	# parse_game
	#
	def test_parse_game
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count

		parsed_game = game.parse_game
		assert_not_nil parsed_game
		assert_not_empty parsed_game
		assert_equal '1-3:0:0|2:0:0|1:0:0;2-0:0:0;3-0:0:0@0', parsed_game

		game.towers[2].change_circle circles[2]

		parsed_game = game.parse_game
		assert_not_nil parsed_game
		assert_not_empty parsed_game
		assert_equal '1-3:0:0|2:0:0;2-1:1:1;3-0:0:0@1', parsed_game

		game.towers[3].change_circle circles[1]

		parsed_game = game.parse_game
		assert_not_nil parsed_game
		assert_not_empty parsed_game
		assert_equal '1-3:0:0;2-1:1:1;3-2:1:2@2', parsed_game

		game.towers[3].change_circle circles[2]

		parsed_game = game.parse_game
		assert_not_nil parsed_game
		assert_not_empty parsed_game
		assert_equal '1-3:0:0;2-0:0:0;3-2:1:2|1:2:3@3', parsed_game

		game.towers[2].change_circle circles[0]

		parsed_game = game.parse_game
		assert_not_nil parsed_game
		assert_not_empty parsed_game
		assert_equal '1-0:0:0;2-3:1:4;3-2:1:2|1:2:3@4', parsed_game
	end

	#
	# parse_circles
	#
	def test_parse_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count

		parsed_circles = game.parse_circles(nil)
		assert_not_nil parsed_circles
		assert_equal '0:0:0', parsed_circles

		parsed_circles = game.parse_circles([])
		assert_not_nil parsed_circles
		assert_equal '0:0:0', parsed_circles

		parsed_circles = game.parse_circles(circles)
		assert_not_nil parsed_circles
		assert_equal '3:0:0|2:0:0|1:0:0', parsed_circles

		parsed_circles = game.parse_circles([circles[1], circles[2]])
		assert_not_nil parsed_circles
		assert_equal '2:0:0|1:0:0', parsed_circles
	end 

	#
	# load_circles
	#
	def test_load_circles		
		game = NewGame.new
		tower = Tower.new(1, 3)
		tower_2 = Tower.new(2, 3)

		#first test set
		parsed_circles = '3:0:0|2:0:0|1:0:0'
		circles = game.load_circles(parsed_circles, tower)

		assert_not_empty circles
		assert_equal 3, circles.size
		assert_equal 3, circles[0].size
		assert_equal tower.id, circles[0].actual_tower.id
		assert_equal 0, circles[0].circle_move_count

		assert_equal 2, circles[1].size
		assert_equal tower.id, circles[1].actual_tower.id
		assert_equal 0, circles[1].circle_move_count

		assert_equal 1, circles[2].size
		assert_equal tower.id, circles[2].actual_tower.id
		assert_equal 0, circles[2].circle_move_count

		#second test set
		parsed_circles = '2:1:1|1:2:2'
		circles = game.load_circles(parsed_circles, tower_2)

		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 2, circles[0].size
		assert_equal tower_2.id, circles[0].actual_tower.id
		assert_equal 1, circles[0].circle_move_count
		assert_equal 1, circles[0].circle_last_move

		assert_equal 1, circles[1].size
		assert_equal tower_2.id, circles[1].actual_tower.id
		assert_equal 2, circles[1].circle_move_count
		assert_equal 2, circles[1].circle_last_move

	end

	#
	# load_towers_from_parsed_game
	#
	def test_load_towers_from_parsed_game
		game = NewGame.new
		parsed_game = '1-3:0:0|2:0:0|1:0:0;2-0:0:0;3-0:0:0@0'

		towers = game.load_towers_from_parsed_game(parsed_game)
		assert_not_empty towers
		assert_equal 1, towers[1].id
		assert_equal 3, towers[1].tower_circles.size

		assert_equal 2, towers[2].id
		assert_empty towers[2].tower_circles

		assert_equal 3, towers[3].id
		assert_empty towers[3].tower_circles

		parsed_game = '1-3:0:0;2-1:0:0;3-2:1:1@4'

		towers = game.load_towers_from_parsed_game(parsed_game)
		assert_not_empty towers
		assert_equal 1, towers[1].id
		assert_equal 1, towers[1].tower_circles.size

		assert_equal 2, towers[2].id
		assert_equal 1, towers[2].tower_circles.size

		assert_equal 3, towers[3].id
		assert_equal 1, towers[3].tower_circles.size

		parsed_game = '1-0:0:0;2-2:0:0;3-3:1:1|1:0:0@4'

		towers = game.load_towers_from_parsed_game(parsed_game)
		assert_not_empty towers
		assert_equal 1, towers[1].id
		assert_empty towers[1].tower_circles

		assert_equal 2, towers[2].id
		assert_equal 1, towers[2].tower_circles.size

		assert_equal 3, towers[3].id
		assert_equal 2, towers[3].tower_circles.size

	end

	#
	# get_game_circles
	#
	def test_get_game_circles
		game = NewGame.new
		parsed_game = '1-3:0:0|2:0:0;2-1:0:0;3-0:0:0@0'

		towers = game.load_towers_from_parsed_game(parsed_game)
		
		assert_empty game.game_circles

		game.get_game_circles(towers)

		assert_equal game.game_circles[1].size, towers[1].get_top_circle.size
		assert_not_equal game.game_circles[1].object_id, towers[1].get_top_circle.object_id
		assert_equal game.game_circles[2].size, towers[2].get_top_circle.size
		assert_not_equal game.game_circles[2].object_id, towers[2].get_top_circle.object_id
		assert_not_empty game.game_circles
		assert_equal 3, game.game_circles.size

		assert_equal 3, game.game_circles[0].size
		assert_equal 2, game.game_circles[1].size
		assert_equal 1, game.game_circles[2].size

	end


	#
	# load_game_from_parsed
	#
	def test_load_game_from_parsed
		game = NewGame.new
		parsed_game = '1-3:0:0|2:0:0|1:0:0;2-0:0:0;3-0:0:0@0'

		game.load_game_from_parsed(parsed_game)
		
		assert_not_equal game.game_circles[1].object_id, game.towers[1].get_top_circle.object_id
		assert_equal game.game_circles[2].size, game.towers[1].get_top_circle.size
		assert_not_equal game.game_circles[2].object_id, game.towers[2].get_top_circle.object_id
		assert_not_empty game.game_circles
		assert_equal 3, game.game_circles.size

		assert_equal 3, game.game_circles[0].size
		assert_equal 2, game.game_circles[1].size
		assert_equal 1, game.game_circles[2].size
	end


=begin
	#
	# get_game_circle_with_move
	#
	def test_get_game_circle_with_move
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count
		#circle 1 tower 3
		move = game.move(nil)

		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.actual_tower.id

		parsed_game = game.parse_game

		assert_not_empty parsed_game

		assert 3, game.towers[1].tower_circles.size
		assert_empty game.towers[2].tower_circles
		assert_empty game.towers[3].tower_circles
		
		assert_equal '1-3:0:0|2:0:0|1:0:0;2-0:0:0;3-0:0:0@0', parsed_game

		game_2 = NewGame.new
		game_2.
	end
=end	
end