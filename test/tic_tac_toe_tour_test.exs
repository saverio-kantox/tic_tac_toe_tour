defmodule TicTacToeTourTest do
  use ExUnit.Case
  doctest TicTacToeTour

  test "greets the world" do
    assert TicTacToeTour.hello() == :world
  end
end
