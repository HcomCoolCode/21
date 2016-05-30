defmodule TwentyOne.Dealer do
	use GenServer

	def start_link do
		GenServer.start_link __MODULE__, %{:players => [], :games => []}
	end

	def addPlayer(dealer, player) do
		GenServer.call(dealer, {:addPlayer, player})
	end
	
	def players(dealer) do
		GenServer.call(dealer, :players)
	end

	#
	
	def handle_call({:addPlayer, player}, _from, state) do
		players = [ player | state[:players]]
		newState = %{ state | :players => players}
		{:reply, :ok, newState}
	end

	def handle_call(:players, _from, state) do
		{:reply, state[:players], state}
	end
end
