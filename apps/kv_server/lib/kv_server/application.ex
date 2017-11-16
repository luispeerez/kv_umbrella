defmodule KVServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised

    #port = String.to_integer(System.get_env("PORT") || raise "missing $PORT env var")
    port = 4040

    children = [
      {Task.Supervisor, name: KVServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> KVServer.accept(4040) end},restart: :permanent)
      #{Task, fn->KVServer.accept(port) end}
      # Starts a worker by calling: KVServer.Worker.start_link(arg)
      # {KVServer.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KVServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
