defmodule Exchange.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Exchange.Router, port: 4040},
      %{id: Exchange.Event, start: {Exchange.Event, :start_link, []}}
    ]

    opts = [strategy: :one_for_one, name: Exchange.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
