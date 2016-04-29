defmodule TwentyOne.Dealer do
	use GenServer

	def start_link do
		GenServer.start_link __MODULE__, nil
	end

	def players(dealer) do
		[]
	end
end
