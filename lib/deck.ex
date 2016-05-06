defmodule TwentyOne.Deck do
	alias TwentyOne.Card
	
	def new do
		for suit <- ["Club", "Diamond", "Heart", "Spade"],
		face <- [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"],
		values <- [valuesForFace(face)], # would make two versions of Ace if not wrapped in array
		do: %Card{suit: suit, face: face, values: values}
	end

	defp valuesForFace(face) do
		case face do
			"J" -> [10]
			"Q" -> [10]
			"K" -> [10]
			"A" -> [1,11]
			f when is_number(f) -> [face]
		end
	end
end
