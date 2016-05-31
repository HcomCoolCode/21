defmodule TwentyOne.DealerTest do
	use ExUnit.Case, async: true
	alias TwentyOne.{Dealer, Player}
	
	setup do
		{:ok, dealer} = TwentyOne.Dealer.start_link
		{:ok, player} = Player.start_link(:dealer_test_player)
		{:ok, dealer: dealer, player: player}
	end
	
	test "dealer collects players", %{dealer: dealer, player: player} do
		assert Dealer.players(dealer) == []
		Dealer.addPlayer(dealer, player)
		assert Dealer.players(dealer) == [player]
	end

	test "adding player, start game, then cards", %{dealer: dealer, player: player} do
		Dealer.addPlayer(dealer, player)
		cards = Player.reveal(player)
		assert is_list(cards)
		assert Enum.empty?(cards)
		playing = Dealer.play(dealer)
		assert playing == :new_game
		cards = Player.reveal(player)
		refute Enum.empty?(cards)
	end
end
