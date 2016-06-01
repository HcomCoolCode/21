defmodule TwentyOne.Game do
	defstruct cards: [], players: [], winners: []
	alias TwentyOne.{Deck, Player, Hand}

	def play(_players, _from, 0, winners) do
		winners
	end
	
	def play(players, from, rounds, winners) do
		# new game with shuffled cards
		all_cards = new_cards
		# deal first card
		[ first_card | after_first_round ] = discard(players, all_cards)
		# deal second card
		[ second_card | after_second_round ] = discard(players, after_first_round)
		# check if each player wants more cards
		remaining_cards = Enum.reduce(players, after_second_round, &(hit_or_stand(&1, &2)))
		# deal to dealer
		dealers_hand = dealer_deal([first_card, second_card], remaining_cards)
		{_status, dealers_score} = Hand.value(dealers_hand)
		new_winners = Enum.filter(players, &(Hand.value(Player.reveal(&1)) > dealers_score))
		|> Enum.map(&(Player.name(&1)))
		send(from, {:ok, new_winners})
		play(players, from, rounds - 1, [new_winners | winners])
	end

	def new_cards() do
		1..8
		|> Enum.map(fn(_i) -> Deck.new end)
		|> Enum.concat
		|> Enum.shuffle
	end

	def discard(players, cards) do
		Enum.zip(players, cards)
		|> Enum.each(&(Player.card(elem(&1,0), elem(&1,1))))

		Enum.drop(cards, length(players))
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
