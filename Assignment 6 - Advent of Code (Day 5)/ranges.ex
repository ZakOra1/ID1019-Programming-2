defmodule Ranges do
  def solve(input) do
    data = parse_text(input)
    seeds = List.keyfind(data, :seeds, 0) |> elem(1)
    map_keys =
      [:seed_to_soil,
      :soil_to_fertilizer,
      :fertilizer_to_water,
      :water_to_light,
      :light_to_temperature,
      :temperature_to_humidity,
      :humidity_to_location]

    final_location = transform(seeds, data, map_keys)
    |> Enum.min()
  end


  def parse_text(text) do
    text
    |> String.split("\n\n")
    |> Enum.map(&parse_section/1)
  end

  def parse_section(section) do
    [key | value] = String.split(section, ":", parts: 2)
    key = key
    |> String.replace(" map", "")
    |> String.replace("-", "_")
    |> String.to_atom()
    value = value
    |> List.first()
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&Enum.reject(&1, fn x -> x == "" end))
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)

    value = if key == :seeds, do: List.flatten(value), else: value

    {key, value}
  end

  def transform(seeds, data, map_keys) do
    Enum.reduce(map_keys, seeds, fn key, seeds ->
      map = List.keyfind(data, key, 0) |> elem(1)
      apply_transform(seeds, map)
    end)
  end

  def apply_transform(seeds, map) do
    Enum.map(seeds, fn seed ->
      case find_transform(seed, map) do
        nil -> seed
        new_seed -> new_seed
      end
    end)
  end

  def find_transform(seed, map) do
    Enum.find_value(map, fn [dest, src, range] ->
      if seed in src..(src + range - 1), do: dest + (seed - src), else: nil
    end)
  end

end
