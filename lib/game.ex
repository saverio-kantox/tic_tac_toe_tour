require Integer

defmodule TicTacToeTour.Game do
  @moduledoc """
  The game definitions.

  Performs moves, checking for validity and winning conditions
  """
  alias TicTacToeTour.{Board, Utils, Game}

  @spec move!(Board.t(), {integer(), integer()}) :: Board.t()
  def move!(%Board{list: list} = board, {x, y}) do
    board
    |> Map.put(:list, [{x, y} | list])
    |> Utils.normalize()
    |> validate!
  end

  @spec valid?(Board.t()) :: boolean
  def valid?(%Board{list: list}) do
    valid?(list)
  end

  @spec valid?(list) :: boolean
  def valid?([]), do: true
  def valid?([h | t]), do: h not in t

  @spec winning?(list) :: boolean
  defp winning?([]), do: false

  defp winning?([{x, y} | _] = moves) do
    own_moves =
      moves
      |> Enum.chunk_every(2)
      |> Enum.map(&Enum.at(&1, 0))

    [{1, 0}, {0, 1}, {1, 1}, {-1, 1}]
    |> Enum.any?(fn {dx, dy} ->
      -4..4
      |> Enum.map(&({x + &1 * dx, y + &1 * dy} in own_moves))
      |> Enum.chunk_by(& &1)
      |> Enum.member?(List.duplicate(true, 5))
    end)
  end

  defp validate!(board) do
    IO.inspect(board.list, label: "list")

    cond do
      not valid?(board.list) -> %Board{board | status: :error}
      winning?(board.list) -> %Board{board | status: :win}
      true -> board
    end
  end
end
