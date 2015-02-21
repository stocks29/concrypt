defmodule Concrypt.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_server(env_key, env_iv) do
    Supervisor.start_child(__MODULE__, worker(Concrypt.Server, [[env_key, env_iv]]))
  end

  def init(:ok) do
    children = [
      # worker(Concrypt.Server, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end