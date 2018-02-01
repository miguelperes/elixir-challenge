defmodule FinancialSystem.Account do
  @moduledoc """
  Documentation for FinancialSystem.Account.
  """

  defstruct account_id: nil, balance: Money.new!(:BRL, 0)
end
