defmodule FinancialSystem.Account do
  @moduledoc """
  Define struct and functions related to Account.
  """

  defstruct account_id: nil, balance: Money.new!(:BRL, 0)

  @typedoc """
  A custom type that represents a `FinancialSystem.Account` struct
  """
  @type t :: %FinancialSystem.Account{account_id: integer(), balance: Money.t()}

  @doc """
  Create a new Account struct

  ## Examples
      iex> FinancialSystem.Account.new("150.75", :USD)
      %FinancialSystem.Account{balance: Money.new!("150.75", :USD)}  
      
      iex> FinancialSystem.Account.new("150.75", :USD, 123456)
      %FinancialSystem.Account{balance: Money.new!("150.75", :USD), account_id: 123456}  
  """
  @spec new(Money.t(), atom, integer) :: FinancialSystem.Account.t()
  def new(balance, currency, id \\ nil) do
    %FinancialSystem.Account{balance: Money.new!(balance, currency), account_id: id}
  end
end
