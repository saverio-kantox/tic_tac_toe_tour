defmodule TicTacToeTour.Player do
  @moduledoc """
  The default behaviour for all the players.
  """

  @doc "Performs a move"
  @callback move!(TicTacToeTour.Board.t) :: TicTacToeTour.Board.t

  @doc "Returns a name to represent this player in the tournament"
  @callback name() :: String.t
end
