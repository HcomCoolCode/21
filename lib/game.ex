defmodule TwentyOne.Game do
	defstruct cards: [], players: [], winners: [], active: true
	alias TwentyOne.{Deck, Game}
	
	def new(players) do
		cards = Enum.map(players, fn(_p) -> Deck.new end)
		%Game{players: players, cards: cards}
	end
end
