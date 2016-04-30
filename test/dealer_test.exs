
defmodule TwentyOne.DealerTest do
	use ExUnit.Case, async: true

	setup do
		{:ok, dealer} = TwentyOne.Dealer.start_link
		{:ok, dealer: dealer}
	end
	
	test "dealer collects players", %{dealer: dealer} do
		assert TwentyOne.Dealer.players(dealer) == []
		TwentyOne.Dealer.addPlayer(dealer, dealer)
		assert TwentyOne.Dealer.players(dealer) == [dealer]
	end

end
