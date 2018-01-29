defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  setup_all do
    {
      :ok,
      [
        account_1: %FinancialSystem.Account{balance: Money.new(:BRL, "10.0")},
        account_2: %FinancialSystem.Account{balance: Money.new(:BRL, "0.0")}
      ]
    }
  end

  test "Check balance of an account that doesn't have enough money", %{account_2: account} do
    assert FinancialSystem.has_enough(account, 10.0) == false
  end

  test "Check balance of an account that has enough money", %{account_1: account} do
    assert FinancialSystem.has_enough(account, 10.0) == true
  end

  test "Add some amount to a money struct", %{account_1: %FinancialSystem.Account{balance: money}} do
    value_to_add = 1.75
    
    expected_result = 
      value_to_add
      |> Decimal.new
      |> Decimal.add(money.amount)
      |> Money.new(:BRL)

    assert FinancialSystem.add(money, value_to_add) == expected_result
  end

  test "Subtract some amount from a money struct", %{account_1: %FinancialSystem.Account{balance: money}} do
    value_to_sub = Decimal.new(1.75)
    
    expected_result = 
      money.amount
      |> Decimal.sub(value_to_sub)
      |> Money.new(:BRL)

    assert FinancialSystem.sub(money, value_to_sub) == expected_result
  end

  test "User should be able to transfer money to another account", %{account_1: source_account, account_2: dest_account} do
    expected_result = {
      %FinancialSystem.Account{balance: Money.new(:BRL, "3.0")},
      %FinancialSystem.Account{balance: Money.new(:BRL, "7.0")},
    }

    assert FinancialSystem.transfer!(source_account, dest_account, 7.0) == expected_result
  end

  test "User cannot transfer if not enough money available on the account", %{account_1: dest_account, account_2: source_account} do
    assert FinancialSystem.transfer(source_account, dest_account, 5.0) == {:error, "Not enough money. (balance: #{source_account.balance.amount})"}
  end

  test "A transfer should be cancelled if an error occurs" , %{account_1: dest_account, account_2: source_account} do
    assert_raise RuntimeError, fn ->
      FinancialSystem.transfer!(source_account, dest_account, 5.0)
    end

  end
end
