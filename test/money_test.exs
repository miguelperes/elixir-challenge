defmodule MoneyTest do
  use ExUnit.Case
  doctest FinancialSystem.Money

  alias FinancialSystem.Money, as: Money

  test "Create a Money struct using separate integers representation" do
    assert Money.new!(200, 55, :BRL) == %Money{amount: Decimal.new("200.55"), currency: :BRL}
  end

  test "Create a Money struct using string representation" do
    assert Money.new!("200.55", :BRL) == %Money{amount: Decimal.new("200.55"), currency: :BRL}
  end

  test "Raise error when creating money using FinancialSystem.Money.new!/3 and an invalid currency" do
    assert_raise RuntimeError, fn ->
      Money.new!("200.55", :STP)
    end
  end

  test "Raise error when creating money using FinancialSystem.Money.new!/2 and an invalid currency" do
    assert_raise RuntimeError, fn ->
      Money.new!(200, 55, :STP)
    end
  end
end
