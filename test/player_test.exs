defmodule TwentyOne.PlayerTest do
	use ExUnit.Case, async: true

	setup do
		{:ok, player} = TwentyOne.Player.start_link
		{:ok, dealer} = TwentyOne.Dealer.start_link
		{:ok, player: player, dealer: dealer}
	end
	
	test "players gonna play", %{player: player} do
		assert :ok == TwentyOne.Player.play(player)
	end

	test "players can join games", %{player: player, dealer: dealer} do
		TwentyOne.Dealer.addPlayer(dealer, player)
		players = TwentyOne.Dealer.players(dealer)
		assert Enum.any?(players, &(&1 === player))
	end

	test "players can get cards", %{player: player} do
		card = %{}
		TwentyOne.Player.card(player, card)
	end

	test "players have names", %{player: player} do

	end
end
