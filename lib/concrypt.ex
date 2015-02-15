defmodule Concrypt do
  use Application

  def start(_type, _args) do
    start
  end

  def start do
    Concrypt.Supervisor.start_link
  end
end
