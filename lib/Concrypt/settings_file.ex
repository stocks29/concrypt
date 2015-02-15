defmodule Concrypt.SettingsFile do

  def stream!(path) do
    File.stream!(path)
    |> Stream.filter(&(not comment(&1)))
    |> Stream.filter(&(not empty(&1)))
    |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    [app, key, val] = line 
    |> String.strip
    |> String.split("|")
    {_to_type(app), _to_type(key), val}
  end

  defp comment("#" <> _), do: true
  defp comment(_), do: false

  defp empty(line), do: String.strip(line) == ""

  defp _to_type(":" <> name), do: String.to_atom(name)
  defp _to_type(name), do: name
  
end