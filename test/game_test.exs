defmodule TwentyOne.GameTest do
	use ExUnit.Case, async: true
	alias TwentyOne.{Game, Player, Card}

	test "can get cards" do
		cards = Game.new_cards
		assert is_list cards
		assert length(cards) >= 52
	end

	test "cards are dealt to players" do
		cards = Game.new_cards
		Player.start_link(:mo)
		Player.start_link(:cheeks)
		players = [:mo, :cheeks]
		rest = Game.discard(players, cards)
		assert rest != cards
		assert length(rest) == length(cards) - 2
		assert Player.reveal(:mo) == [hd(cards)]
		assert Player.reveal(:cheeks) == [Enum.at(cards, 1)]
	end

	test "discard twice gives each player two cards" do
		cards = Game.new_cards
		Player.start_link(:john)
		Player.start_link(:cole)
		Player.start_link(:train)
		players = [:john, :cole, :train]
		rest = Game.discard(players, cards)
		Game.discard(players, rest)
		assert Enum.all?(players, &(length(Player.reveal(&1)) == 2))
	end

	test "players with extra cards cannot win" do
		Player.start_link(:lion)
		Player.start_link(:witch)
		players = [:lion, :witch]
		Enum.each(players, &(Player.card(&1,%Card{values: [10]})))
		Enum.each(players, &(Player.card(&1,%Card{values: [10]})))
		Enum.each(players, &(Player.card(&1,%Card{values: [10]})))
		# busted for sure
		winners = Game.play(players, self, 1, [])
		IO.inspect winners
		assert Enum.empty?(hd(winners))
	end
end
