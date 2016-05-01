defmodule TwentyOne.Player do
	use GenServer
	
	def start_link do
		GenServer.start_link __MODULE__, %{cards: []}
	end

	def play(player) do
		:ok
	end

	def card(player, card) do
		GenServer.call(player, {:card, card})
	end


	def handle_call({:card, card}, _from, state) do
		cards = [ card | state[:cards]]
		newState = %{state | :cards => cards}
		{:reply, :ok, newState}
	end
end
