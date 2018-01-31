defmodule CurrencyTest do
  use ExUnit.Case
  doctest FinancialSystem.Currency

  test "Return same amount when converting from a currency to the same currency" do
    assert FinancialSystem.Currency.convert(200.0, :BRL, :BRL) == 200.0
  end

  test "Check conversion from USD to another currency" do
    assert FinancialSystem.Currency.convert(1.0, :USD, :BRL) == 3.16
  end

  test "Check conversion from some currency to USD" do
    assert FinancialSystem.Currency.convert(5.0, :BRL, :USD) == 1.58
  end

  test "Check conversion of two currencies, neither of them being USD" do
    assert FinancialSystem.Currency.convert(10.0, :EUR, :SEK) == 97.61
  end

  test "Check conversion using exchange rate instead of currency symbols. (Not using rates cache)" do
    assert FinancialSystem.Currency.convert(10.0, 3.15) == Float.round(10.0 * 3.15, 2)
  end

end