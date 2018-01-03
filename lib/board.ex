require Integer

defmodule TicTacToeTour.Board do
  @moduledoc """
  The board definition.
  """

  alias TicTacToeTour.{Board, Utils}

  use Tensor

  @type t :: %__MODULE__{}

  @default_chips %{o: "○", x: "×", new: "✓", empty: " "}

  defstruct list: [],
            chips: @default_chips,
            status: :ok

  #############################################################################

  @spec as_list(t) :: list
  @doc """
  Return the board a list of moves, normalized so the board starts at (0, 0)
  """
  def as_list(%Board{} = board), do: Utils.normalize(board).list

  @spec as_matrix(t) :: Matrix
  @doc """
  Return the board as a Tensor.Matrix. Uses the given chips to fill it.
  """
  def as_matrix(%Board{} = board) do
    board
    |> as_sparse_map
    |> as_matrix(board.chips)
  end

  def as_matrix(map, %{empty: default}) when map == %{}, do: Matrix.new([[default]], 1)
  def as_matrix(%{} = map, %{empty: default}) do
    [max_x, max_y] =
      map
      |> Map.keys()
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.max/1)
    Matrix.from_sparse_map(map, max_x + 1, max_y + 1, default)
  end

  defp as_sparse_map(%Board{chips: %{x: x, o: o}} = board) do
    board
    |> as_list
    |> :lists.reverse()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip(Stream.cycle([x, o]))
    |> Map.new()
  end

  #############################################################################

  defimpl String.Chars, for: Board do
    def to_string(%Board{} = board) do
      board
      |> Board.as_matrix()
      |> pretty_print_matrix
    end

    defp pretty_print_matrix(%Tensor{} = matrix, with_spaces \\ true) do
      width =
        if with_spaces,
          do: Matrix.width(matrix) * 2 - 1,
          else: Matrix.width(matrix)

      [border, spacer] = Enum.map(["═", " "], &String.duplicate(&1, width))
      separator = if with_spaces, do: " ", else: ""

      [
        "╔═#{border}═╗",
        "║ #{spacer} ║",
        matrix |> Matrix.rows() |> Enum.map(&(&1 |> Vector.to_list() |> Enum.join(separator)))
        |> Enum.map(&"║ #{&1} ║"),
        "║ #{spacer} ║",
        "╚═#{border}═╝"
      ]
      |> List.flatten()
      |> Enum.join("\n")
    end
  end

  defimpl Inspect, for: Board do
    import Inspect.Algebra

    def inspect(%Board{} = board, opts) do
      concat([
        "#Board<",
        to_doc(
          [board: Board.as_matrix(board), status: board.status, last_turn: Utils.last_turn(board)],
          opts
        )
      ])
    end
  end
end
