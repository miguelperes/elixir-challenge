defmodule FinancialSystem.Money do
  @moduledoc """
  Define struct and functions related to Money.
  It uses Decimal arithmetid, to avoid floating point rounding issues.
  """
  alias FinancialSystem.Currency, as: Currency

  defstruct amount: Decimal.new(0), currency: :USD

  @typedoc """
  A custom type that abstracts money
  """
  @type t :: %FinancialSystem.Money{amount: Decimal.t(), currency: atom}

  @doc """
  Create a a FinancialSystem.Money struct passing separately major unit of the currency (e.g.: dollars) and the minor unit (e.g.: cents) as integers

  ## Examples
      iex> FinancialSystem.Money.new(150, 75, :USD)
      {:ok, %FinancialSystem.Money{amount: Decimal.new("150.75"), currency: :USD}}
  """
  @spec new(integer, integer, atom) :: {:ok, FinancialSystem.Money.t()} | {:error, String.t()}
  def new(major_unit, minor_unit, currency) when is_integer(major_unit) and is_integer(minor_unit) do
    string_amount = Integer.to_string(major_unit) <> "." <> Integer.to_string(minor_unit)
    new(string_amount, currency)
  end

  @doc """
  Similar to FinancialSystem.Money.new/3 but returns unwrapped

  ## Examples
      iex> FinancialSystem.Money.new!(150, 75, :USD)
      %FinancialSystem.Money{amount: Decimal.new("150.75"), currency: :USD}
  """
  @spec new!(integer, integer, atom) :: FinancialSystem.Money.t() | no_return
  def new!(major_unit, minor_unit, currency) do
    case new(major_unit, minor_unit, currency) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end

  @doc """
  Create a a FinancialSystem.Money struct passing a string representation of the amount

  ## Examples
      iex> FinancialSystem.Money.new("150.75", :USD)
      {:ok, %FinancialSystem.Money{amount: Decimal.new("150.75"), currency: :USD}}
  """
  @spec new(String.t(), atom) :: {:ok, FinancialSystem.Money.t()} | {:error, String.t()}
  def new(string_amount, currency) do
    case Currency.valid_currency?(currency) do
      true ->
        {:ok, %FinancialSystem.Money{amount: Decimal.new(string_amount), currency: currency}}

      false ->
        {:error, "'#{currency}' is not a valid currency"}
    end
  end

  @doc """
  Similar to FinancialSystem.Money.new/2 but returns unwrapped

  ## Examples
      iex> FinancialSystem.Money.new!("150.75", :USD)
      %FinancialSystem.Money{amount: Decimal.new("150.75"), currency: :USD}
  """
  @spec new!(String.t(), atom) :: FinancialSystem.Money.t() | no_return
  def new!(string_amount, currency) do
    case new(string_amount, currency) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end
end
