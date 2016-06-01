defmodule TwentyOne.HandTest do
	use ExUnit.Case, async: true
	alias TwentyOne.{Hand,Card}

	test "hand has blackjack" do
		hand = [%Card{values: [1, 11]}, %Card{values: [10]}]
		{:ok, value} = Hand.value(hand)
		assert value == 21
	end

	test "busted" do
		hand = [%Card{values: [10]}, %Card{values: [2]}, %Card{values: [10]}]
		assert {:busted, 0} == Hand.value(hand)
	end

	test "soft 17" do
		hand = [%Card{values: [9]}, %Card{values: [7]}, %Card{values: [1,11]}]
		assert {:ok, 17} = Hand.value(hand)
	end
end
