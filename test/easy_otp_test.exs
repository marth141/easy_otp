defmodule EasyOtpTest do
  use ExUnit.Case
  doctest EasyOtp

  test "greets the world" do
    assert EasyOtp.hello() == :world
  end
end
