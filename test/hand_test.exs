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
		assert {:ok, 17} == Hand.value(hand)
	end

	test "a real hand" do
		hand = [%TwentyOne.Card{deck_id: 0, face: 7, suit: "Heart", values: [7]},
						%TwentyOne.Card{deck_id: 0, face: 2, suit: "Heart", values: [2]},
						%TwentyOne.Card{deck_id: 0, face: "Q", suit: "Heart", values: [10]}]
		assert {:ok, 19} == Hand.value(hand)
	end
end
