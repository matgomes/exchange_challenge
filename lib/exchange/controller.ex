defmodule Exchange.Controller do
  alias Exchange.Http.{ServiceA, ServiceB, ServiceC}

  @services [ServiceA, ServiceB, ServiceC]

  def best_rate(currency) do
    results =
      @services
      |> Enum.map(&Task.async(fn -> apply(&1, :get_rate, [currency]) end))
      |> Task.await_many()
      |> Enum.filter(&match?(%{value: _}, &1))

    if results == [] do
      :error
    else
      {:ok, Enum.min_by(results, fn r -> r.value end)}
    end
  end
end
