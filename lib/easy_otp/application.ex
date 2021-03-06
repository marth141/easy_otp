defmodule EasyOtp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: EasyOtp.Worker.start_link(arg)
      # {EasyOtp.Worker, arg}
      # In this example, starts a Registry and DynamicSupervisor
      # Registry Docs: https://hexdocs.pm/elixir/1.13/Registry.html
      # DynamicSupervisor Docs: https://hexdocs.pm/elixir/1.13/DynamicSupervisor.html
      {Registry, name: EasyOtp.MyRegistry, keys: :unique},
      {DynamicSupervisor, name: EasyOtp.MyDynamicSupervisor, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EasyOtp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
