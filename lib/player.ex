defmodule TwentyOne.Player do
	use GenServer
	
	def start_link(nick) do
		GenServer.start_link __MODULE__, %{cards: [], nick: nick}
	end

	def play(player) do
		:ok
	end

	def card(player, card) do
		GenServer.call(player, {:card, card})
	end

	def reveal(player) do
		GenServer.call(player, {:reveal})
	end

	def name(player) do
		GenServer.call(player, {:nick})
	end
	
	#

	def handle_call({:card, card}, _from, state) do
		cards = [ card | state[:cards]]
		newState = %{state | :cards => cards}
		{:reply, :ok, newState}
	end

	def handle_call({:reveal}, _from, state) do
		{:reply, state[:cards], state}
	end

	def handle_call({:nick}, _from, state) do
		{:reply, state[:nick], state}
	end
end
