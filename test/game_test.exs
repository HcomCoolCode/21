defmodule TwentyOne.GameTest do
	use ExUnit.Case, async: true
	alias TwentyOne.Game
	
	test "a game can start" do
		players = [:peter, :paul, :mary]
		game = Game.new(players)
		assert game.players == players
	end

	test "a game has cards" do
		game = Game.new([:huey, :dewey, :louie])
		assert is_list(game.cards)
	end
end
