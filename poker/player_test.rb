#require 'minitest/autorun'
require "test-unit"
require_relative 'player'

class PlayerTest < Test::Unit::TestCase

	def setup
			@cards = ["JD", "AA", "AF", "4D", "QA"]
	end

	def test_playes_initialize
		player = Player.new(@cards, 1)
		assert_equal(player.id, 1)
		assert_equal(player.cards, @cards)
  end

	def test_playes_initialize_2
		player = Player.new([], 1)
		assert_equal(player.id, 1)
		assert_equal(player.cards.length, 1)
	end
end
