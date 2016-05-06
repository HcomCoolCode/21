defmodule TwentyOne.Shuffler do
	alias TwentyOne.Card
	
	@type deck :: [%Card{}]
	@callback shuffle([deck]) :: [%Card{}]
end
