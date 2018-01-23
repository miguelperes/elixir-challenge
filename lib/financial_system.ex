defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  """

  def transfer(source_account, destination_account, value) do
    case source_account.balance >= value do
      true ->
        { 
          :ok,
          {
            %FinancialSystem.Account{source_account | balance: source_account.balance - value}, 
            %FinancialSystem.Account{destination_account | balance: destination_account.balance + value}
          }
        }
      false ->
        {:error, "Not enough money. (#{source_account.balance})"}
    end
  end

  def transfer!(source_account, destination_account, value) do
    case transfer(source_account, destination_account, value) do
      {:ok, result} -> result
      {:error, reason} -> reason
    end
  end

end
