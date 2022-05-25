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
  - `registry` (*type:* `atom()`)
  - `dynamic_supervisor` (*type:* `atom()`)
  - `registry_name` (*type:* `any()`)
  - `optional_params`
    - `:registry_value` - (*type:* `any()`) - defaults to nil


  ## Returns
  - `{:ok, pid()}` on success

  """
  def genserver_stack_start(registry, dynamic_supervisor, registry_name, opts \\ []) do
    registry_value = Keyword.get(opts, :registry_value, nil)

    name = {:via, Registry, {registry, registry_name, registry_value}}

    DynamicSupervisor.start_child(
      dynamic_supervisor,
      {EasyOtp.Stack, name: name}
    )
  end

  @doc """
  Will create a Counter Agent under the DynamicSupervisor.

  ## Parameters
  - `registry` (*type:* `atom()`)
  - `dynamic_supervisor` (*type:* `atom()`)
  - `registry_name` (*type:* `any()`)
  - `optional_params`
    - `:registry_value` - (*type:* `any()`) - defaults to nil

  ## Returns
  - `{:ok, pid()}` on success

  """
  def agent_counter_start(registry, dynamic_supervisor, registry_name, opts \\ []) do
    registry_value = Keyword.get(opts, :registry_value, nil)

    name = {:via, Registry, {registry, registry_name, registry_value}}

    DynamicSupervisor.start_child(
      dynamic_supervisor,
      {EasyOtp.Counter, name: name}
    )
  end

  @doc """
  Will lookup a named thing in the Registry.

  ## Parameters
  - `registry` (*type:* `atom()`)
  - `registry_key` (*type:* `any()`)

  ## Returns
  - `[{pid(), any()}]` on success

  """
  def registry_lookup(registry, registry_key) do
    Registry.lookup(registry, registry_key)
  end

  @doc """
  Returns the keys in a Registry linked to a DynamicSupervisor.

  ## Parameters
  - `registry` (*type:* `atom()`)
  - `dynamic_supervisor` (*type:* `atom()`)

  ## Returns
  - `[%{"registry_key" => any(), "pid" => pid(), "module" => atom()}]` on success

  """
  def registry_read(registry, dynamic_supervisor) do
    DynamicSupervisor.which_children(dynamic_supervisor)
    |> Enum.map(fn {_a, pid, _worker, [module]} ->
      [key] = Registry.keys(registry, pid)
      %{"registry_key" => key, "pid" => pid, "module" => module}
    end)
  end

  @doc """
  Reads the state of a given Stack GenServer pid.

  ## Parameters
  - `pid` (*type:* `pid()`)

  ## Returns
  - `any()` on success

  """
  def genserver_stack_read(pid) do
    EasyOtp.Stack.read(pid)
  end

  @doc """
  Pushes an element into a Stack GenServer's state.

  ## Parameters
  - `pid` (*type:* `pid()`)
  - `element` (*type:* `any()`)

  ## Returns
  - `:ok` on success

  """
  def genserver_stack_push(pid, element) do
    EasyOtp.Stack.push(pid, element)
  end

  @doc """
  Pops an element off a Stack GenServer's state.

  ## Parameters
  - `pid` (*type:* `pid()`)

  ## Returns
  - `any()` on success

  """
  def genserver_stack_pop(pid) do
    EasyOtp.Stack.pop(pid)
  end

  @doc """
  Stops a Stack GenServer.

  ## Parameters
  - `pid` (*type:* `pid()`)

  ## Returns
  - `:ok` on success

  """
  def genserver_stack_stop(pid) do
    EasyOtp.Stack.stop_call(pid)
  end

  @doc """
  Reads a Counter Agent's state.

  ## Parameters
  - `pid` (*type:* `pid()`)

  ## Returns
  - `number()` on success

  """
  def agent_counter_read(pid) do
    EasyOtp.Counter.value(pid)
  end

  @doc """
  Increments a Counter Agent's state.

  ## Parameters
  - `pid` (*type:* `pid()`)

  ## Returns
  - `:ok` on success

  """
  def agent_counter_increment(pid) do
    EasyOtp.Counter.increment(pid)
  end

  @doc """
  Stops a Counter Agent.

  ## Parameters
  - `pid` (*type:* `pid()`)

  ## Returns
  - `:ok` on success

  """
  def agent_counter_stop(pid) do
    EasyOtp.Counter.stop(pid)
  end
end
