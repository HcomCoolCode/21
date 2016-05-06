defmodule TwentyOne.DeskTest do
	use ExUnit.Case, async: true
	alias TwentyOne.Deck

	setup do
		deck = Deck.new
		{:ok, deck: deck}
	end
	
	test "52 cards in a deck", %{deck: deck} do
		assert is_list(deck)
		assert length(deck) == 52
	end

	test "aces can have value 1 or 21", %{deck: deck} do
		aces = Enum.filter(deck, &("A" == &1.face))
		assert is_list(aces)
		assert Enum.all?(aces, &([1,11] == &1.values))
	end
end
