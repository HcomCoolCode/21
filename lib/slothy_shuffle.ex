defmodule TwentyOne.SlothyShuffle do
	@behaviour TwentyOne.Shuffler

	def shuffle(decks) do
		decks
		|> Enum.concat
		|> cut
	end

	defp cut(deck) do
		:random.seed(:erlang.now())
		splitter = :random.uniform(length(deck))
		{top, bottom} = Enum.split(deck, splitter)
		bottom ++ top
	end
end
