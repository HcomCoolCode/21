defmodule TwentyOne.BasicPlayerTest do
	use ExUnit.Case, async: true
	alias TwentyOne.{Card, BasicPlayer, Dealer}

	@player_name :test_player
	
	setup do
		{:ok, player} = BasicPlayer.start_link(@player_name)
		{:ok, dealer} = Dealer.start_link
		{:ok, player: player, dealer: dealer}
	end
	
	test "players gonna play", %{player: player} do
		assert :ok == BasicPlayer.play(player)
	end

	test "players can join games", %{player: player, dealer: dealer} do
		Dealer.add_player(dealer, player)
		players = Dealer.players(dealer)
		assert Enum.any?(players, &(&1 === player))
	end

	test "players can get cards", %{player: player} do
		card = %Card{}
		BasicPlayer.card(player, card)
		[first | _rest]  = BasicPlayer.reveal(player)
		assert card == first
	end

	test "players have nicknames", %{player: player} do
		nick = BasicPlayer.name(player)
		assert nick == @player_name
	end

	test "player can decide on next move", %{player: player} do
		next_move = BasicPlayer.next_move(player)
		assert Enum.any?([:hit, :stand], &(next_move == &1))
	end

	test "stand at 17", %{player: player} do
		BasicPlayer.card(player, %Card{values: [10]})
		BasicPlayer.card(player, %Card{values: [7]})
		next_move = BasicPlayer.next_move(player)
		assert next_move == :stand
	end

	test "hit at less than 17", %{player: player} do
		BasicPlayer.card(player, %Card{values: [7]})
		BasicPlayer.card(player, %Card{values: [7]})
		next_move = BasicPlayer.next_move(player)
		assert next_move == :hit
	end
end
