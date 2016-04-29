defmodule TwentyOne.PlayerTest do
	use ExUnit.Case, async: true

	test "players gonna play" do
		{:ok, player} = TwentyOne.Player.start_link
		assert :ok == TwentyOne.Player.play(player)
	end

	test "players can join games via a dealer" do

	end

	test "players can see their cards" do

	end

	test "players can hit" do

	end
end
