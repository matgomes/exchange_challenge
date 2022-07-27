defmodule Exchange.Router do
  use Plug.Router
  alias Exchange.Controller

  plug :match

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason

  plug :dispatch

  get "/api/exchange-rate/:currency" do
    response = Controller.best_rate(currency)

    case response do
      {:ok, response_body} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(response_body))

      :error ->
        send_resp(conn, 500, "")
    end
  end

  post "/api/webhook" do
    body = conn.body_params
    Exchange.Event.publish(body["cid"], body)

    send_resp(conn, 200, "")
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, ~s|{"message": "not found"}|)
  end
end
