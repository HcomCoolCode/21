defmodule TwentyOne.Player do
	use GenServer
	
	def start_link do
		GenServer.start_link __MODULE__, %{}
	end

	def play(player) do
		:ok
	end

	
end
