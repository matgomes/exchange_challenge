defmodule Exchange.Http.ServiceA do
  use Tesla

  @base_url Application.compile_env!(:exchange, __MODULE__)[:base_url]

  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON

  def get_rate(currency) do
    with {:ok, %{status: 200, body: body}} <- get("/servico-a/cotacao", query: [moeda: currency]),
         %{"cotacao" => cotacao} <- body do
      %{value: cotacao / 1}
    else
      _ -> nil
    end
  end
end
