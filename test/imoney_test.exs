defmodule IMoneyTest do
  use ExUnit.Case
  doctest FinancialSystem.IMoney

  alias FinancialSystem.IMoney

  test "IMoney struct creation" do
    expected = %IMoney{amount: 1550, currency: :BRL, precision: 2}
    assert IMoney.new!(1550, :BRL) == expected
  end

  test "IMoney struct creation with invalid parameters" do
    assert_raise RuntimeError, fn ->
      IMoney.new!(0, :USD)
    end
  end

  test "IMoney add operation" do
    money_a = IMoney.new!(1550, :BRL, 2)
    money_b = IMoney.new!(277, :BRL, 2)

    assert IMoney.add(money_a, money_b) == IMoney.new!(1827, :BRL, 2)
  end

  test "IMoney add operation for different precisions" do
    money_a = IMoney.new!(1550, :BRL, 2)
    money_b = IMoney.new!(2770, :BRL, 3)

    assert IMoney.add(money_a, money_b) == IMoney.new!(18_270, :BRL, 3)
  end

  test "IMoney add operation for different precisions (first param with greater precision)" do
    money_a = IMoney.new!(1550, :BRL, 2)
    money_b = IMoney.new!(2770, :BRL, 3)

    assert IMoney.add(money_b, money_a) == IMoney.new!(18_270, :BRL, 3)
  end

  test "Add IMoneys with different currency" do
    money_a = IMoney.new!(1550, :BRL, 2)
    money_b = IMoney.new!(50, :USD, 2)

    assert_raise RuntimeError, fn ->
      IMoney.add(money_a, money_b)
    end
  end

  test "Show string representation of an IMoney" do
    money = IMoney.new!(1550, :BRL, 2)
    assert IMoney.to_string(money) == "15.50"
  end

  test "Show string representation of an IMoney with custom separator" do
    money = IMoney.new!(15_500, :BRL, 3)
    assert IMoney.to_string(money, ",") == "15,500"
  end

  test "IMoney ultiplication" do
    money = IMoney.new!(1500, :BRL, 2)
    assert IMoney.mult(money, 0.5) == IMoney.new!(750, :BRL, 2)
  end
end
