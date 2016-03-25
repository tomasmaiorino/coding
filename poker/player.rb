class Player

	attr_accessor :cards, :id, :points, :points_cards, :game_name

	def initialize(cards, id, points = 0)
		@cards = cards
		@id = id
		@points = points
		@points_cards = {}
		@game_name = ''
	end

	def to_s
		puts "Player #{@id} cards: #{@cards} points: #{@points}"
	end

	def get_cards_fit(points_cards)
		cards_fit = []
		points_cards.each{|key, value|
			value.each{|i|
				cards_fit << @cards[i]
			}
		}
		return cards_fit
	end

end
