defmodule TwentyOne.Dealer do
	use GenServer
	alias TwentyOne.Game
	
	def start_link do
		GenServer.start_link __MODULE__, %{:players => []}
	end

	def addPlayer(dealer, player) do
		GenServer.call(dealer, {:addPlayer, player})
	end
	
	def players(dealer) do
		GenServer.call(dealer, :players)
	end

	def play(dealer, rounds \\ 1) do
		GenServer.call(dealer, {:play, rounds})
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

	def handle_call({:play, rounds}, {from, _ref}, %{players: players} = state) when length(players) > 0 do
		winners = Game.play(players, from, rounds, [])
		{:reply, winners, state}
	end
end


