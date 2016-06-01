require_relative 'play_poker'
require_relative 'player'
require_relative 'match'
require_relative 'cards_util'
require "test-unit"

class CardsUtilTest < Test::Unit::TestCase

	#
	# get_card_url
	#
	def test_get_card_url

		card = '5C'

		cards_util = CardsUtil.new
		url_image = cards_util.get_card_url(card)
		assert_not_empty url_image
		assert_equal 'images/club/' + card + '.png', url_image
		
		card = '10D'
		url_image = cards_util.get_card_url(card)
		assert_not_empty url_image
		assert_equal 'images/diamond/' + card + '.png', url_image

		card = 'JH'
		url_image = cards_util.get_card_url(card)
		assert_not_empty url_image
		assert_equal 'images/heart/' + card + '.png', url_image

		card = '6S'
		url_image = cards_util.get_card_url(card)
		assert_not_empty url_image
		assert_equal 'images/spade/' + card + '.png', url_image

		assert_nil cards_util.get_card_url(nil)
		assert_nil cards_util.get_card_url([])
	end

end
