defmodule TwentyOne.Game do
	defstruct cards: [], players: [], winners: []
	alias TwentyOne.{Deck, Game, Player, SlothyShuffle, Hand}
	
	def play(_players, _from, 0, winners) do
		winners
	end
	
	def play(players, from, rounds, winners) do
		# new game with shuffled cards
		names = Enum.map(players, &(Player.name(&1)))
		g = new(names)
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
		new_winners = Enum.filter(players, &(Hand.value(Player.reveal(&1)) > dealers_score))
		|> Enum.map(&(Player.name(&1)))
		send(from, {:ok, new_winners})
		play(players, from, rounds - 1, [new_winners | winners])
	end

	def new(players) do
		cards = Enum.map(players, fn(_p) -> Deck.new end)
		%Game{players: players, cards: cards}
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
