defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  alias FinancialSystem.Money, as: Money

  setup_all do
    {
      :ok,
      [
        account_1: FinancialSystem.Account.new("10.0", :BRL),
        account_2: FinancialSystem.Account.new("0.0", :BRL),
        account_3: FinancialSystem.Account.new("200.0", :BRL),
        account_4: FinancialSystem.Account.new("600.0", :BRL),
        usd_account_50: FinancialSystem.Account.new("50.0", :USD)
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
      |> Decimal.new()
      |> Decimal.add(money.amount)
      |> Money.new!(:BRL)

    assert FinancialSystem.add(money, value_to_add) == expected_result
  end

  test "Subtract some amount from a money struct", %{
    account_1: %FinancialSystem.Account{balance: money}
  } do
    value_to_sub = Decimal.new(1.75)

    expected_result =
      money.amount
      |> Decimal.sub(value_to_sub)
      |> Money.new!(:BRL)

    assert FinancialSystem.sub(money, value_to_sub) == expected_result
  end

  test "Subtract a value greater than the Money amount", %{
    account_1: %FinancialSystem.Account{balance: money}
  } do
    value_to_sub = Decimal.new(11.0)

    assert_raise RuntimeError, fn ->
      FinancialSystem.sub(money, value_to_sub)
    end
  end

  test "User should be able to transfer money to another account", %{
    account_1: source_account,
    account_2: dest_account
  } do
    expected_result = {
      FinancialSystem.Account.new("3.0", :BRL),
      FinancialSystem.Account.new("7.0", :BRL)
    }

    assert FinancialSystem.transfer!(source_account, dest_account, 7.0) == expected_result
  end

  test "User cannot transfer if not enough money available on the account", %{
    account_1: dest_account,
    account_2: source_account
  } do
    assert FinancialSystem.transfer(source_account, dest_account, 5.0) ==
             {:error, "Not enough money. (balance: #{source_account.balance.amount})"}
  end

  test "A transfer should be cancelled if an error occurs", %{
    account_1: dest_account,
    account_2: source_account
  } do
    assert_raise RuntimeError, fn ->
      FinancialSystem.transfer!(source_account, dest_account, 5.0)
    end
  end

  test "A transfer can be splitted between 2 or more accounts",
       %{account_4: source_account} = context do
    expected_result = {
      FinancialSystem.Account.new("300.0", :BRL),
      [
        FinancialSystem.Account.new("110.0", :BRL),
        FinancialSystem.Account.new("100.0", :BRL),
        FinancialSystem.Account.new("300.0", :BRL)
      ]
    }

    assert FinancialSystem.transfer!(
             source_account,
             [context.account_1, context.account_2, context.account_3],
             300.0
           ) == expected_result
  end

  test "A multiple account transfer should fail if source account doesn't have anough money available",
       %{account_4: source_account} = context do
    assert_raise RuntimeError, fn ->
      FinancialSystem.transfer!(
        source_account,
        [context.account_1, context.account_2, context.account_3],
        600.01
      )
    end
  end

  test "User should be able to exchange money between different currencies", context do
    expected_result = {
      FinancialSystem.Account.new("150.0", :BRL),
      FinancialSystem.Account.new("65.8", :USD)
    }

    assert FinancialSystem.transfer!(context.account_3, context.usd_account_50, 50.0) ==
             expected_result
  end

  test "Multiple account transfer with different weights (total of 300, but 100 for one account and 200 to the other)",
       %{account_4: source_account} = context do
    expected_result = {
      FinancialSystem.Account.new("300.0", :BRL),
      [
        FinancialSystem.Account.new("210.0", :BRL),
        FinancialSystem.Account.new("100.0", :BRL)
      ]
    }

    assert FinancialSystem.weighted_transfer!(
             source_account,
             [context.account_1, context.account_2],
             300.0,
             [2, 1]
           ) == expected_result
  end

  test "Multiple account transfer with weights, but not enough money to transfer",
       %{account_4: source_account} = context do
    assert_raise RuntimeError, fn ->
      FinancialSystem.weighted_transfer!(
        source_account,
        [context.account_1, context.account_2],
        999.0,
        [2, 1, 4]
      )
    end
  end
end
