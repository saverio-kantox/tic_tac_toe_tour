require Integer

defmodule TicTacToeTour.Utils do
  @moduledoc """
  The game definitions.

  Performs moves, checks for validity and winning conditions
  """

  alias TicTacToeTour.Board

  @spec normalize(Board.t()) :: Board.t()
  def normalize(%Board{} = board) do
    %Board{board | list: normalize(board.list)}
  end

  @spec normalize(list) :: list
  def normalize([]), do: []

  def normalize(list) do
    min_x = list |> Enum.map(fn {x, _} -> x end) |> Enum.min()
    min_y = list |> Enum.map(fn {_, y} -> y end) |> Enum.min()
    Enum.map(list, fn {x, y} -> {x - min_x, y - min_y} end)
  end

  def last_turn(%Board{list: list}) when length(list) == 0 do
    nil
  end

  def last_turn(%Board{list: list, chips: chips}) do
    case Integer.is_even(length(list)) do
      true -> chips.o
      false -> chips.x
    end
  end
end
