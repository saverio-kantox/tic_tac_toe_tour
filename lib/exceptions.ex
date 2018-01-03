defmodule TicTacToeTour.NotImplemented do
  defexception [:feature, :hint, :message]

  def exception(feature: feature, hint: hint) do
    message = "Feature [#{inspect(feature)}] is not yet implemented. Hint: “#{hint}”."
    %TicTacToeTour.NotImplemented{feature: feature, hint: hint, message: message}
  end

  def exception(feature: feature), do: exception(feature: feature, hint: "¿?")
end
