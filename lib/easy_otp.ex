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

  def easy_genserver() do
    name = {:via, Registry, {EasyOtp.MyRegistry, "genserver", [:hello]}}

    {:ok, pid} =
      DynamicSupervisor.start_child(EasyOtp.MyDynamicSupervisor, {EasyOtp.Stack, name: name})

    EasyOtp.Stack.read(pid)
  end

  def easy_agent() do
    name = {:via, Registry, {EasyOtp.MyRegistry, "agent", [:hello]}}

    {:ok, agent} =
      DynamicSupervisor.start_child(
        EasyOtp.MyDynamicSupervisor,
        {EasyOtp.Counter, [name: name]}
      )

    Registry.lookup(EasyOtp.MyRegistry, "agent")

    Agent.get(agent, & &1)
  end
end
