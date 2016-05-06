defmodule TwentyOne.SlothyShuffleTest do
	use ExUnit.Case, async: true
	alias TwentyOne.{SlothyShuffle, Deck, Card}

	test "card count consistent" do
		deck1 = Deck.new
		deck2 = Deck.new
		shuffled = SlothyShuffle.shuffle([deck1, deck2])
		assert length(shuffled) == 104
	end

	test "shuffled deck is not equal th original deck" do
		deck = Deck.new
		shuffled = SlothyShuffle.shuffle([deck])
		refute deck == shuffled
	end
end
