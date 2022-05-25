defmodule EasyOtp do
  @moduledoc """
  A small module showcasing making GenServers and Agents under a DynamicSupervisor with Registry.

  Would be good to check out these articles:
  - https://hexdocs.pm/elixir/1.13/Registry.html
  - https://hexdocs.pm/elixir/1.13/DynamicSupervisor.html
  - https://hexdocs.pm/elixir/1.13/Agent.html
  - https://hexdocs.pm/elixir/1.13/GenServer.html
  """

  @doc """
  Will create a Stack GenServer under the DynamicSupervisor.

  ## Parameters
  - `given_registry_name`
  - `given_registry_value`

  ## Returns
  - `{:ok, pid()}` on success

  """
  def genserver_stack_start(given_registry_name, given_registry_value) do
    name = {:via, Registry, {EasyOtp.MyRegistry, given_registry_name, given_registry_value}}

    DynamicSupervisor.start_child(
      EasyOtp.MyDynamicSupervisor,
      {EasyOtp.Stack, name: name}
    )
  end

  @doc """
  Will create a Counter Agent under the DynamicSupervisor.

  ## Parameters
  - `given_registry_name`
  - `given_registry_value`

  ## Returns
  - `{:ok, pid()}` on success

  """
  def agent_counter_start(given_registry_name, given_registry_value) do
    name = {:via, Registry, {EasyOtp.MyRegistry, given_registry_name, given_registry_value}}

    DynamicSupervisor.start_child(
      EasyOtp.MyDynamicSupervisor,
      {EasyOtp.Counter, name: name}
    )
  end

  @doc """
  Will lookup a named thing in the Registry.

  ## Parameters
  - `given_registry_name`

  ## Returns
  - `[{pid(), any()}]` on success

  """
  def registry_lookup(given_registry_name) do
    Registry.lookup(EasyOtp.MyRegistry, given_registry_name)
  end

  @doc """
  Reads the state of a given Stack GenServer pid.

  ## Parameters
  - `pid`

  ## Returns
  - `any()` on success

  """
  def genserver_stack_read(pid) do
    EasyOtp.Stack.read(pid)
  end

  @doc """
  Pushes an element into a Stack GenServer's state.

  ## Parameters
  - `pid`
  - `element`

  ## Returns
  - `:ok` on success

  """
  def genserver_stack_push(pid, element) do
    EasyOtp.Stack.push(pid, element)
  end

  @doc """
  Pops an element off a Stack GenServer's state.

  ## Parameters
  - `pid`

  ## Returns
  - `any()` on success

  """
  def genserver_stack_pop(pid) do
    EasyOtp.Stack.pop(pid)
  end

  @doc """
  Pops an element off a Stack GenServer's state.

  ## Parameters
  - `pid`

  ## Returns
  - `any()` on success

  """
  def genserver_stack_stop(pid) do
    EasyOtp.Stack.stop_call(pid)
  end

  @doc """
  Reads a Counter Agent's state.

  ## Parameters
  - `pid`

  ## Returns
  - `number()` on success

  """
  def agent_counter_read(pid) do
    EasyOtp.Counter.value(pid)
  end

  @doc """
  Increments a Counter Agent's state.

  ## Parameters
  - `pid`

  ## Returns
  - `:ok` on success

  """
  def agent_counter_increment(pid) do
    EasyOtp.Counter.increment(pid)
  end

  @doc """
  Stops a Counter Agent.

  ## Parameters
  - `pid`

  ## Returns
  - `:ok` on success

  """
  def agent_counter_stop(pid) do
    EasyOtp.Counter.stop(pid)
  end
end
