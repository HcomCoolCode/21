defmodule TwentyOne.Hand do
	alias TwentyOne.Card
	
	def value(hand) do
		values = Enum.reduce(hand, [0], fn(card, acc) ->
			case card.values do
				[i] ->
					Enum.map(acc, &(i + &1))
				ace ->
				for i <- acc,
					j <- ace,
						do: i + j	
			end
		end)
		|> Enum.filter(&(21 >= &1))
		case values do
			[] -> {:busted, 0}
			_ -> {:ok, Enum.max(values)}
		end
	end
end
