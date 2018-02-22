defmodule FinancialSystem.IMoney do
  @moduledoc """
  IMoney struct represent money using integers and some specified precision.
  The `amount` represent the smaller unit of the currency (e.g.: cents)
  All operations are done using intergers, to avoid floating point rounding errors.
  """

  alias FinancialSystem.IMoney

  defstruct amount: nil, precision: nil, currency: :USD
  @typedoc """
  A custom type that abstracts money using integers and arbitrary precision
  """
  @type t :: %FinancialSystem.IMoney{amount: integer, precision: integer, currency: atom}

  @doc """
  Create a a FinancialSystem.IMoney struct.  
  `amount` represent the smaller unit of the currency (e.g.: cents)

  ## Examples
      iex> FinancialSystem.IMoney.new(1500, :USD, 2)
      {:ok, %FinancialSystem.IMoney{amount: 1500, currency: :USD, precision: 2}}
  """
  @spec new(integer, atom, integer) :: {:ok, IMoney.t()} | {:error, String.t()}
  def new(amount, currency, precision \\ 2) do
    cond do
      amount == nil or amount <= 0 ->
        {:error, "IMoney with amount less or equal than zero is invalid"}

      not is_atom(currency) ->
        {:error, "Invalid currency"}

      true ->
        {:ok, %IMoney{amount: amount, precision: precision, currency: currency}}
    end
  end

  @doc """
  Similar to FinancialSystem.IMoney.new/3 but returns unwrapped

  ## Examples
      iex> FinancialSystem.IMoney.new!(1500, :USD, 2)
      %FinancialSystem.IMoney{amount: 1500, currency: :USD, precision: 2}
  """
  @spec new!(integer, atom, integer) :: FinancialSystem.IMoney.t() | no_return
  def new!(amount, currency, precision \\ 2) do
    case new(amount, currency, precision) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end

  @doc """
  Return the sum of two IMoneys, checking for precision and currency

  ## Examples
      iex> money_a = FinancialSystem.IMoney.new!(500, :BRL, 2)
      iex> money_b = FinancialSystem.IMoney.new!(500, :BRL, 2)
      iex> FinancialSystem.IMoney.add(money_a, money_b)
      FinancialSystem.IMoney.new!(1000, :BRL, 2)

      iex> money_a = FinancialSystem.IMoney.new!(500, :BRL, 2)
      iex> money_b = FinancialSystem.IMoney.new!(5000, :BRL, 3)
      iex> FinancialSystem.IMoney.add(money_a, money_b)
      FinancialSystem.IMoney.new!(10000, :BRL, 3)
  """
  @spec add(IMoney.t(), IMoney.t()) :: IMoney.t() | no_return
  def add(%IMoney{currency: currency_a}, %IMoney{currency: currency_b})
      when currency_a != currency_b do
    raise("Can't add moneys with different currency")
  end

  def add(%IMoney{precision: precision_a} = money_a, %IMoney{precision: precision_b} = money_b)
      when precision_a == precision_b do
    IMoney.new!(money_a.amount + money_b.amount, money_a.currency, precision_a)
  end

  def add(%IMoney{precision: precision_a} = money_a, %IMoney{precision: precision_b} = money_b)
      when precision_a > precision_b do
    normalized_amount_b = money_b.amount * pow_ten(precision_a - precision_b)
    IMoney.new!(money_a.amount + normalized_amount_b, money_a.currency, precision_a)
  end

  def add(%IMoney{precision: precision_a} = money_a, %IMoney{precision: precision_b} = money_b)
      when precision_a < precision_b do
    normalized_amount_a = money_a.amount * pow_ten(precision_b - precision_a)
    IMoney.new!(normalized_amount_a + money_b.amount, money_a.currency, precision_b)
  end

  @doc """
  Return the subtraction of two IMoneys, checking for precision and currency

  ## Examples
      iex> money_a = FinancialSystem.IMoney.new!(600, :BRL, 2)
      iex> money_b = FinancialSystem.IMoney.new!(500, :BRL, 2)
      iex> FinancialSystem.IMoney.sub(money_a, money_b)
      FinancialSystem.IMoney.new!(100, :BRL, 2)
  """
  @spec add(IMoney.t(), IMoney.t()) :: IMoney.t() | no_return
  def sub(money_a, %IMoney{amount: amount_b} = money_b) do
    negative_money_b = %IMoney{money_b | amount: amount_b * -1}
    add(money_a, negative_money_b)
  end

  def mult(%IMoney{amount: amount, precision: precision, currency: currency} = money, multiplier) do
    multiplier_precision = 
      String.split(multiplier, ".")
      |> List.last()
      |> String.length()

      whole_multiplier = 
        String.replace(multiplier, ".", "")
        |> trim_left_zeroes()
      
        IO.inspect whole_multiplier
        IO.inspect multiplier_precision

      new_amount = amount * whole_multiplier / pow_ten(multiplier_precision)
    
    # new_amount = amount * (whole_multiplier) / pow_ten(String.to_integer(multiplier_precision))
    # result = Money.new!(new_amount, currency, precision)
  end

  def trim_left_zeroes(number) do
    if String.first(number) == "0" do
        number |> String.slice(1..-1) |> trim_left_zeroes
    else
        String.to_integer(number)
    end    
  end

  @doc """
  String representation of an IMoney

  ## Examples
      iex> money = FinancialSystem.IMoney.new!(29999, :BRL, 2)
      iex> FinancialSystem.IMoney.to_string(money)
      "299.99"

      iex> money = FinancialSystem.IMoney.new!(29999, :BRL, 2)
      iex> FinancialSystem.IMoney.to_string(money, ",")
      "299,99"
  """
  @spec to_string(IMoney.t(), String.t()) :: String.t()
  def to_string(%IMoney{amount: amount, precision: precision}, separator \\ ".") do
    string_amount = Integer.to_string(amount)

    major_unit = 
      string_amount
      |> String.slice(0.. - precision - 1)
    
    minor_unit = 
      string_amount
      |> String.slice(- precision.. - 1)

    major_unit <> separator <> minor_unit
  end

  defp pow_ten(number) when is_integer(number) do
    trunc(:math.pow(10, number))
  end
end
