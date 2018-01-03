defmodule TicTacToeTour.Board do
  @moduledoc """
  The board definition.
  """

  alias TicTacToeTour.Board

  use Tensor

  @type t :: %__MODULE__{}

  @fields chips: %{o: "○", x: "×", new: "✓", empty: " "}, # to be used later in inspect
          board: Matrix.new([[" "]], 1, 1)

  def fields, do: @fields
  defstruct @fields

  #############################################################################

  @spec move!(t, {integer(), integer()}) :: t
  def move!(%__MODULE__{chips: chips} = board, {x, y}) do
    board =
      board
      |> extend_x(x)
      |> extend_y(y)
    put_in(board.board[Enum.max([0, y])][Enum.max([0, x])], chips.new)
  end

  @spec extension(t, integer(), :height | :width) :: [%Tensor{}]
  defp extension(board, num, dimension) do
    board.chips.empty
    |> List.duplicate(apply(Matrix, dimension, [board.board]))
    |> Vector.new()
    |> List.duplicate(num)
  end

  @spec from_columns([%Tensor{}]) :: %Tensor{}
  defp from_columns(columns) do
    columns
    |> Matrix.from_rows() # WTF there is no from_columns?!
    |> Matrix.transpose()
  end

  @spec extend_x(t, integer()) :: %Tensor{}
  defp extend_x(board, x) do
    result =
      case {x, Matrix.width(board.board) - x - 1} do
        {x, _} when x < 0 ->
          from_columns(extension(board, abs(x), :height) ++ Matrix.columns(board.board))
        {_, x} when x < 0 ->
          from_columns(Matrix.columns(board.board) ++ extension(board, abs(x), :height))
        _ ->
        board.board
      end
    %__MODULE__{board | board: result}
  end

  @spec from_rows([%Tensor{}]) :: %Tensor{}
  defp from_rows(rows), do: Matrix.from_rows(rows)

  @spec extend_y(t, integer()) :: %Tensor{}
  defp extend_y(board, y) do
    result =
      case {y, Matrix.height(board.board) - y - 1} do
        {y, _} when y < 0 ->
          from_rows(extension(board, abs(y), :width) ++ Matrix.rows(board.board))
        {_, y} when y < 0 ->
          from_rows(Matrix.rows(board.board) ++ extension(board, abs(y), :width))
        _ ->
        board.board
      end
    %__MODULE__{board | board: result}
  end

  #############################################################################

  defimpl String.Chars, for: Board do
    def to_string(%Board{board: board}) do
      Kernel.to_string(board)
    end
  end

  defimpl Inspect, for: Board do
    import Inspect.Algebra

    def inspect(%Board{board: board, chips: _chips}, opts) do
      concat ["#Board<", to_doc([board: board], opts)]
    end
  end
end
