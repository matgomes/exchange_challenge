defmodule Exchange.Event do
  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def await(receiver) do
    {:ok, _} = Registry.register(__MODULE__, receiver, [])

    receive do
      {:response, message} -> message
    after
      5000 -> nil
    end
  end

  def publish(receiver, message) do
    Registry.dispatch(__MODULE__, receiver, fn [{pid, _} | _] ->
      send(pid, {:response, message})
    end)
  end
end
