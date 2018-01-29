defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  """

  def transfer(source_account, destination_account, value) do
    case FinancialSystem.has_enough(source_account, value) do
      true ->
        { 
          :ok,
          {
            %FinancialSystem.Account{source_account | balance: FinancialSystem.sub(source_account.balance, value)},  
            %FinancialSystem.Account{destination_account | balance: FinancialSystem.add(destination_account.balance, value)}
          }
        }

      false ->
        {:error, "Not enough money. (balance: #{source_account.balance.amount})"}
    end
  end

  def transfer!(source_account, destination_account, value) do
    case transfer(source_account, destination_account, value) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end

  def add(money, value) when is_float(value) or is_integer(value) or is_binary(value) do
    FinancialSystem.add(money, Decimal.new(value))
  end

  def add(%Money{amount: amount, currency: currency}, value) do
    amount
    |> Decimal.add(value)
    |> Money.new(currency)
  end

  def sub(money, value) when is_float(value) or is_integer(value) do
    FinancialSystem.sub(money, Decimal.new(value))
  end

  def sub(%Money{amount: amount, currency: currency}, value) do
    amount
    |> Decimal.sub(value)
    |> Money.new(currency)
  end

  def has_enough(%FinancialSystem.Account{balance: money}, value) do
    Decimal.to_float(money.amount) >= value
  end

end
