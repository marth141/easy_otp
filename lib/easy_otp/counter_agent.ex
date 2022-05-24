defmodule EasyOtp.Counter do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> 0 end, name: initial_value[:name])
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def increment do
    Agent.update(__MODULE__, &(&1 + 1))
  end
end
