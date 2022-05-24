defmodule EasyOtp.Counter do
  # Copied from https://hexdocs.pm/elixir/1.13/Agent.html#module-examples

  use Agent

  def start_link(args) when is_list(args) do
    Agent.start_link(fn -> 0 end, name: args[:name])
  end

  def value(pid) do
    Agent.get(pid, & &1)
  end

  def increment(pid) do
    Agent.update(pid, &(&1 + 1))
  end
end
