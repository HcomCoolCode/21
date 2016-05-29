defmodule TwentyOne.PlayerTest do
	use ExUnit.Case, async: true
	alias TwentyOne.{Card, Player}

	@player_name :test_player
	
	setup do
		{:ok, player} = TwentyOne.Player.start_link(@player_name)
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
		card = %Card{}
		TwentyOne.Player.card(player, card)
		[first | _rest]  = TwentyOne.Player.reveal(player)
		assert card == first
	end

	test "players have nicknames", %{player: player} do
		nick = Player.name(player)
		assert nick == @player_name
	end

	test "player can decide on next move", %{player: player} do
		next_move = Player.next_move(player)
		assert Enum.any?([:hit, :stand, :split], &(next_move == &1))
	end
end
