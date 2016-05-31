defmodule TwentyOne.Dealer do
	use GenServer
	alias TwentyOne.{Game, Player}
	
	def start_link do
		GenServer.start_link __MODULE__, %{:players => [], :games => [], :cards => []}
	end

	def addPlayer(dealer, player) do
		GenServer.call(dealer, {:addPlayer, player})
	end
	
	def players(dealer) do
		GenServer.call(dealer, :players)
	end

	def play(dealer) do
		GenServer.call(dealer, :play)
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

	def handle_call(:play, _from, %{players: players, games: games} = state) when length(players) > 0 do
		case games do
			[] ->
				{:reply, :new_game, new_game_state(state)}
			[%Game{active: active} | _tl] when active == false ->
				{:reply, :new_game, new_game_state(state)}
			_ ->
				{:reply, :game_in_progress, state}
		end
	end

	#
	
	defp new_game_state(%{players: players} = state) do
		names = Enum.map(players, &(Player.name(&1)))
		game = %Game{ Game.new(names) | active: true }
		Enum.each(players, &(Player.card(&1, hd(game.cards))))
		%{state | games: [game]}
	end
end
