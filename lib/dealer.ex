defmodule TwentyOne.Dealer do
	use GenServer
	alias TwentyOne.{Game, Player, Hand, SlothyShuffle}
	
	def start_link do
		GenServer.start_link __MODULE__, %{:players => [], :games => [], :rounds => 0}
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

	def handle_call({:play, rounds}, _from, %{players: players} = state) when length(players) > 0 do
		# new game with shuffled cards
		names = Enum.map(players, &(Player.name(&1)))
		g = Game.new(names)
		shuffled = SlothyShuffle.shuffle(g.cards)
		game = %Game{ g	| cards: shuffled }
		# deal first card
		Enum.each(players, &(Player.card(&1, hd(game.cards))))
		first_card = hd(game.cards)
		# deal second card
		Enum.each(players, &(Player.card(&1, hd(game.cards))))
		dealer_cards = [hd(game.cards), first_card]
		# check if each player wants more cards
		remaining_cards = Enum.reduce(players, game.cards, &(hit_or_stand(&1, &2)))
		# deal to dealer
		dealers_hand = dealer_deal(dealer_cards, remaining_cards)
		{_status, dealers_score} = Hand.value(dealers_hand) 
		winners = Enum.filter(players, &(Hand.value(Player.reveal(&1)) > dealers_score))
		|> Enum.map(&(Player.name(&1)))
		games = [%Game{game| winners: winners} | state.games]
		{:reply, Enum.map(games, &(&1.winners)), %{ state | games: games}}
	end

	#
	
	defp hit_or_stand(player, [hd | tl ] = cards) do
		busted? = case Hand.value(Player.reveal(player)) do
								{:busted, 0} -> true
								_ -> false
							end
		case Player.next_move(player) do
			:hit when not busted? ->
				Player.card(player, hd)
				hit_or_stand(player, tl)
			_ ->
				cards
		end
	end

	defp dealer_deal(my_cards, [hd | tl]) do
		case Hand.value(my_cards) do
			{:ok, i} when i < 17 ->
				dealer_deal([hd | my_cards], tl)
			_ ->
				my_cards
		end
	end
end


