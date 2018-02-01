defmodule FinancialSystem.Currency do
  @moduledoc """
  Documentation for FinancialSystem.Currency.
  """

  def parse_file(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn x ->
      [currency, rate] = String.split(x, ":")

      currency_key =
        currency
        |> String.trim("\"")
        |> String.to_atom()

      {currency_key, String.to_float(rate)}
    end)
  end

  def convert(value, same_currency, same_currency) do
    case valid_currency?(same_currency) do
      true -> {:ok, value}
      false -> {:error, "Currency (#{same_currency}) not compliant with ISO 4217"}
    end
  end

  def convert(value, :USD, to_currency) do
    case valid_currency?(to_currency) do
      true ->
        rates = FinancialSystem.Currency.parse_file("currency_rates.txt")
        converted_value = (value * rates[to_currency]) |> Float.round(2)
        {:ok, converted_value}

      false ->
        {:error, "Currency (#{to_currency}) not compliant with ISO 4217"}
    end
  end

  def convert(value, from_currency, :USD) do
    case valid_currency?(from_currency) do
      true ->
        rates = FinancialSystem.Currency.parse_file("currency_rates.txt")
        converted_value = (value / rates[from_currency]) |> Float.round(2)
        {:ok, converted_value}

      false ->
        {:error, "Currency (#{from_currency}) not compliant with ISO 4217"}
    end
  end

  def convert(value, from_currency, to_currency) do
    usd_value = FinancialSystem.Currency.convert!(value, from_currency, :USD)
    FinancialSystem.Currency.convert!(usd_value, :USD, to_currency)
  end

  def convert(value, exchange_rate), do: Float.round(value * exchange_rate, 2)

  def convert!(value, currency_a, currency_b) do
    case convert(value, currency_a, currency_b) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end

  def valid_currency?(currency_to_check) do
    FinancialSystem.Currency.parse_file("currency_rates.txt")
    |> Keyword.keys()
    |> Enum.any?(fn currency -> currency == currency_to_check end)
  end
end
