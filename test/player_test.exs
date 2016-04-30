defmodule TwentyOne.PlayerTest do
	use ExUnit.Case, async: true

	setup do
		{:ok, player} = TwentyOne.Player.start_link
		{:ok, player: player}
	end
	
	test "players gonna play", %{player: player} do
		assert :ok == TwentyOne.Player.play(player)
	end

	test "players can join games", %{player: player} do
		
	end

	test "players can see their cards", %{player: player} do

	end

	test "players can hit", %{player: player} do

	end
end
