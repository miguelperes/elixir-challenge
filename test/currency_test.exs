defmodule CurrencyTest do
  use ExUnit.Case
  doctest FinancialSystem.Currency

  test "Return same amount when converting from a currency to the same currency" do
    assert FinancialSystem.Currency.convert!(200.0, :BRL, :BRL) == 200.0
  end

  test "Check conversion from USD to another currency" do
    assert FinancialSystem.Currency.convert!(1.0, :USD, :BRL) == 3.16
  end

  test "Check conversion from some currency to USD" do
    assert FinancialSystem.Currency.convert!(5.0, :BRL, :USD) == 1.58
  end

  test "Check conversion of two currencies, neither of them being USD" do
    assert FinancialSystem.Currency.convert(10.0, :EUR, :SEK) == 97.61
  end

  test "Check conversion using exchange rate instead of currency symbols. (Not using rates cache)" do
    assert FinancialSystem.Currency.convert(10.0, 3.15) == Float.round(10.0 * 3.15, 2)
  end

  # This test was replaced by all the other tests below
  # test "Currencies should be in compliance with ISO 4217" do
  #   assert :false
  # end

  test "Check a valid currency symbol (in compliance with ISO 4217)" do
    assert FinancialSystem.Currency.valid_currency?(:USD) == true
  end

  test "Check an invalid currency symbol (not in compliance with ISO 4217)" do
    assert FinancialSystem.Currency.valid_currency?(:AAA) == false
  end

  test "Fail when trying to convert TO an invalid currency" do
    assert_raise RuntimeError, fn ->
      FinancialSystem.Currency.convert!(200.0, :BRL, :BBB)
    end
  end

  test "Fail when trying to convert FROM an invalid currency" do
    assert_raise RuntimeError, fn ->
      FinancialSystem.Currency.convert!(200.0, :BBB, :BRL)
    end
  end

  test "Fail when trying to convert invalid currency to itself, instead of just return the value" do
    assert_raise RuntimeError, fn ->
      FinancialSystem.Currency.convert!(200.0, :BBB, :BBB)
    end
  end

end