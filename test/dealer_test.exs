
defmodule TwentyOne.DealerTest do
	use ExUnit.Case, async: true

	test "dealer collects players" do
		{:ok, dealer} = TwentyOne.Dealer.start_link
		assert TwentyOne.Dealer.players(dealer) == []
	end

end
