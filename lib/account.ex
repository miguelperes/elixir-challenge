defmodule FinancialSystem.Account do
  @moduledoc """
  Define struct and functions related to Account.
  """
  alias FinancialSystem.Money, as: Money

  defstruct account_id: nil, balance: Money.new!(0, :BRL)

  @typedoc """
  A custom type that abstracts an account
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
  @spec new(String.t(), atom, integer | nil) :: FinancialSystem.Account.t()
  def new(balance_amount, currency, id \\ nil) do
    %FinancialSystem.Account{balance: Money.new!(balance_amount, currency), account_id: id}
  end
end
