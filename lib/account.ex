defmodule FinancialSystem.Account do
  defstruct account_id: nil, balance: Money.new!(:BRL, 0)
end