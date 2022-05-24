defmodule EasyOtp do
  @moduledoc """
  Documentation for `EasyOtp`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> EasyOtp.hello()
      :world

  """
  def hello do
    :world
  end

  def make_dynamically_supervised_genserver() do
    name = {:via, Registry, {EasyOtp.MyRegistry, "genserver", [:hello]}}

    {:ok, pid} =
      DynamicSupervisor.start_child(EasyOtp.MyDynamicSupervisor, {EasyOtp.Stack, name: name})

    {:ok, pid}
  end

  def make_dynamically_supervised_agent() do
    name = {:via, Registry, {EasyOtp.MyRegistry, "agent", [:hello]}}

    {:ok, pid} =
      DynamicSupervisor.start_child(
        EasyOtp.MyDynamicSupervisor,
        {EasyOtp.Counter, [name: name]}
      )

    {:ok, pid}
  end

  def lookup_agent() do
    Registry.lookup(EasyOtp.MyRegistry, "agent")
  end

  def lookup_genserver() do
    Registry.lookup(EasyOtp.MyRegistry, "genserver")
  end

  def read_stack_genserver(pid) do
    EasyOtp.Stack.read(pid)
  end

  def read_counter_agent(pid) do
    EasyOtp.Counter.value(pid)
  end
end
