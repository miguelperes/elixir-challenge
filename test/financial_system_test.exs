defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  setup_all do
    {
      :ok,
      [
        account_1: %FinancialSystem.Account{balance: 10.0},
        account_2: %FinancialSystem.Account{balance: 0.0}
      ]
    }
  end

  test "User should be able to transfer money to another account", %{account_1: source_account, account_2: dest_account} do
    expected_result = {
      %FinancialSystem.Account{balance: 3.0},
      %FinancialSystem.Account{balance: 7.0},
    }

    assert FinancialSystem.transfer!(source_account, dest_account, 7.0) == expected_result
  end

  test "Check balance of an account that doesn't have enough money", %{account_2: account} do
    assert FinancialSystem.has_enough(account, 10.0) == false
  end

  test "Check balance of an account that has enough money", %{account_1: account} do
    assert FinancialSystem.has_enough(account, 10.0) == true
  end

  test "User cannot transfer if not enough money available on the account", %{account_1: source_account, account_2: dest_account} do
    assert FinancialSystem.transfer(dest_account, source_account, 5.0) == {:error, "Not enough money. (balance: #{dest_account.balance})"}
  end

  test "A transfer should be cancelled if an error occurs" do
    assert :false
  end

  test "A transfer can be splitted between 2 or more accounts" do
    assert :false
  end

  test "User should be able to exchange money between different currencies" do
    assert :false
  end

  test "Currencies should be in compliance with ISO 4217" do
    assert :false
  end
end
