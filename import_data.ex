defmodule ImportData do
  @moduledoc false

  def importLinesFromCSV(name) do
    data = File.read!(name) |> String.split("\n")
    count = length(data)
    IO.puts "Imported #{count} lines"
    data
  end

  def convert(line) do
    [date, time, length, width, val] = String.split(line, ",")
    date = date |> String.split("-") |> Enum.reverse()
           |>  Enum.map(&String.to_integer/1) |> List.to_tuple()
    length = String.to_float(length)
    width = String.to_float(width)
    val = String.strip(val)
    val = String.to_integer(val)
    time = String.split(time, ":")
    time = time ++ ["0"]
    time = time |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    %{:datetime => {date, time}, :location => {width, length}, :pollutionLevel => val}
  end


  def indentifyStations(data) do
    data = data |> Enum.map(fn(x) -> convert(x) end) |> Enum.uniq_by(fn(x) -> elem(x,0) end)
    length(data)
  end

end
