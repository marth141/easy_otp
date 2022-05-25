defmodule EasyOtp.Stack do
  # Copied from https://hexdocs.pm/elixir/1.13/GenServer.html#module-client-server-apis

  use GenServer, restart: :temporary

  # Client

  def start_link(args) when is_list(args) do
    GenServer.start_link(__MODULE__, [:hello], name: args[:name])
  end

  def read(pid) do
    GenServer.call(pid, :read)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def stop_call(pid) do
    GenServer.call(pid, :stop)
  end

  def stop_cast(pid) do
    GenServer.cast(pid, :stop)
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end
end
