defmodule Exchange.Http.ServiceB do
  use Tesla

  @base_url Application.compile_env!(:exchange, __MODULE__)[:base_url]

  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON

  def get_rate(currency) do
    with {:ok, %{status: 200, body: body}} <- get("/servico-b/cotacao", query: [curr: currency]),
         %{"cotacao" => %{"valor" => valor, "fator" => fator}} <- body do
      %{value: String.to_integer(valor) / fator}
    else
      _ -> nil
    end
  end
end
