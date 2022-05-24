defmodule EasyOtp do
  @moduledoc """
  A small module showcasing making GenServers and Agents under a DynamicSupervisor with Registry.
  """

  @doc """
  Will create a Stack GenServer under the DynamicSupervisor.

  ## Parameters
  - `given_registry_name`
  - `given_registry_value`

  ## Examples

      iex> EasyOtp.genserver_stack_start("genserver", [:registry_value])
      {:ok, pid}

  """
  def genserver_stack_start(given_registry_name, given_registry_value) do
    name = {:via, Registry, {EasyOtp.MyRegistry, given_registry_name, given_registry_value}}

    {:ok, pid} =
      DynamicSupervisor.start_child(
        EasyOtp.MyDynamicSupervisor,
        {EasyOtp.Stack, name: name}
      )

    {:ok, pid}
  end

  @doc """
  Will create a Counter Agent under the DynamicSupervisor.

  ## Parameters
  - `given_registry_name`
  - `given_registry_value`

  ## Examples

      iex> EasyOtp.agent_counter_start("agent", [:registry_value])
      {:ok, pid}

  """
  def agent_counter_start(given_registry_name, given_registry_value) do
    name = {:via, Registry, {EasyOtp.MyRegistry, given_registry_name, given_registry_value}}

    {:ok, pid} =
      DynamicSupervisor.start_child(
        EasyOtp.MyDynamicSupervisor,
        {EasyOtp.Counter, name: name}
      )

    {:ok, pid}
  end

  @doc """
  Will lookup a named thing in the Registry.

  ## Parameters
  - `given_registry_name`

  ## Examples

      iex> EasyOtp.registry_lookup("genserver")
      [{pid, :registry_value}]

  """
  def registry_lookup(given_registry_name) do
    Registry.lookup(EasyOtp.MyRegistry, given_registry_name)
  end

  @doc """
  Reads the state of a given Stack GenServer pid.

  ## Parameters
  - `pid`

  ## Examples

      iex> EasyOtp.genserver_stack_read(pid)
      state

  """
  def genserver_stack_read(pid) do
    EasyOtp.Stack.read(pid)
  end

  @doc """
  Pushes an element into a Stack GenServer's state.

  ## Parameters
  - `pid`
  - `element`

  ## Examples

      iex> EasyOtp.genserver_stack_push(pid, element)
      :ok

  """
  def genserver_stack_push(pid, element) do
    EasyOtp.Stack.push(pid, element)
  end

  @doc """
  Pops an element off a Stack GenServer's state.

  ## Parameters
  - `pid`

  ## Examples

      iex> EasyOtp.genserver_stack_pop(pid)
      popped_state

  """
  def genserver_stack_pop(pid) do
    EasyOtp.Stack.pop(pid)
  end

  @doc """
  Reads a Counter Agent's state.

  ## Parameters
  - `pid`

  ## Examples

      iex> EasyOtp.agent_counter_read(pid)
      state

  """
  def agent_counter_read(pid) do
    EasyOtp.Counter.value(pid)
  end

  @doc """
  Increments a Counter Agent's state.

  ## Parameters
  - `pid`

  ## Examples

      iex> EasyOtp.agent_counter_read(pid)
      state

  """
  def agent_counter_increment(pid) do
    EasyOtp.Counter.increment(pid)
  end
end
