defmodule Exchange.Http.ServiceC do
  use Tesla

  alias Exchange.Event

  @config Application.compile_env!(:exchange, __MODULE__)

  plug Tesla.Middleware.BaseUrl, @config[:base_url]
  plug Tesla.Middleware.JSON

  def get_rate(currency) do
    req_body = %{
      tipo: currency,
      callback: @config[:webhook_url]
    }

    with {:ok, %{status: 202, body: body}} <- post("/servico-c/cotacao", req_body),
         %{"cid" => cid} <- body,
         %{"v" => v, "f" => f} <- Event.await(cid) do
      %{value: v / f}
    else
      _ -> nil
    end
  end
end
