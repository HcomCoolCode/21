defmodule TwentyOne.BasicPlayer do
	use GenServer
	alias TwentyOne.Hand
	
	def start_link(nick) do
		GenServer.start_link __MODULE__, %{cards: [], nick: nick}, name: nick
	end

	def play(_player) do
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

	def next_move(player) do
		GenServer.call(player, {:next_move})
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

	def handle_call({:next_move}, _from, %{cards: cards} = state) do
		next_move = case Hand.value(cards) do
									{:ok, i} when i < 17 -> :hit
									_ -> :stand
								end
		{:reply, next_move, state}
	end
end
