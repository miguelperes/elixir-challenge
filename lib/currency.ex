defmodule FinancialSystem.Currency do
  
  def parse_file(file_name) do
    file_name
      |> File.read!
      |> String.split("\n")
      |> Enum.map(fn(x) ->
        [currency, rate] = String.split(x, ":")
        
        currency_key = currency
        |> String.trim("\"")
        |> String.to_atom

        {currency_key, String.to_float(rate)}
      end)
  end

  def convert(value, same_currency, same_currency), do: value

  def convert(value, :USD, to_currency) do
    rates = FinancialSystem.Currency.parse_file("currency_rates.txt")
    value * rates[to_currency] |> Float.round(2)
  end

  def convert(value, from_currency, :USD) do
    rates = FinancialSystem.Currency.parse_file("currency_rates.txt")
    value / rates[from_currency] |> Float.round(2)
  end

  def convert(value, from_currency, to_currency) do
    usd_value = FinancialSystem.Currency.convert(value, from_currency, :USD)
    FinancialSystem.Currency.convert(usd_value, :USD, to_currency)
  end

  def convert(value, exchange_rate), do: Float.round(value * exchange_rate, 2)

end
