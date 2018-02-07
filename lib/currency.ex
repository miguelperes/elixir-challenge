defmodule FinancialSystem.Currency do
  @moduledoc """
  Implements functions to handle currency operations.
  """

  @doc """
  Parse a text file (in the format `"CURRENCY_CODE":EXCHANGE_RATE` per line), into a Keyword List
  """
  @spec parse_file(String.t()) :: [key: float]
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

  @doc false
  def convert(value, currency_a, currency_b) when currency_a == currency_b do
    case valid_currency?(currency_a) do
      true -> {:ok, value}
      false -> {:error, "Currency (#{currency_a}) not compliant with ISO 4217"}
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

  @doc """
  Converts a `value` from `currency_a` to `currency_b`  
  Returns `{:ok, converted_value}` on successful conversion, otherwise `{:error, reason}`

  ## Examples

      iex> FinancialSystem.Currency.convert(1.0, :USD, :BRL)
      {:ok, 3.16}

      iex> FinancialSystem.Currency.convert(3.16, :BRL, :USD)
      {:ok, 1.00}
  """
  @spec convert(float, atom, atom) :: {:ok, float} | {:error, String.t()}
  def convert(value, from_currency, to_currency) do
    usd_value = FinancialSystem.Currency.convert!(value, from_currency, :USD)
    FinancialSystem.Currency.convert!(usd_value, :USD, to_currency)
  end

  @doc """
  Returns a converted value, given an exchange rate

  ## Examples
      iex> FinancialSystem.Currency.convert!(10.0, 0.8) # Canadian Dollar exchange rate
      8.0      
  """
  @spec convert(float, float) :: {:ok, float} | {:error, String.t()}
  def convert(value, exchange_rate) do
    case exchange_rate > 0 do
      true ->
        {:ok, Float.round(value * exchange_rate, 2)}

      false ->
        {:error, "Invalid exchange rate"}
    end
  end

  @spec convert!(float, float) :: float | no_return
  def convert!(value, exchange_rate) do
    case convert(value, exchange_rate) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end

  @doc """
  Converts a `value` from `currency_a` to `currency_b`  
  Similar to `convert/3` but returns unwrapped.

  ## Examples

      iex> FinancialSystem.Currency.convert!(1.0, :USD, :BRL)
      3.16

      iex> FinancialSystem.Currency.convert!(3.16, :BRL, :USD)
      1.00
  """
  @spec convert!(float, atom, atom) :: float | no_return
  def convert!(value, currency_a, currency_b) do
    case convert(value, currency_a, currency_b) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end

  @doc """
  Check if a currency code is compliant to ISO 4217  
  Returns `boolean`
  ## Examples

      iex> FinancialSystem.Currency.valid_currency?(:USD)
      true
      
      iex> FinancialSystem.Currency.valid_currency?(:BBB)
      false
  """
  @spec valid_currency?(atom) :: boolean
  def valid_currency?(currency_to_check) do
    FinancialSystem.Currency.parse_file("currency_rates.txt")
    |> Keyword.keys()
    |> Enum.any?(fn currency -> currency == currency_to_check end)
  end
end
