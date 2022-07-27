defmodule ExchangeTest do
  use ExUnit.Case
  use Plug.Test

  setup do
    bypass = Bypass.open(port: 8080)
    {:ok, bypass: bypass}
  end

  def wait_until(p) do
    p.() || wait_until(p)
  end

  def json_response(status, body) do
    fn conn ->
      conn
      |> put_resp_header("content-type", "application/json")
      |> resp(status, body)
    end
  end

  test "It will return the min value from the 3 responses", %{bypass: bypass} do
    [a, b, c] = response_list = Enum.take_random(1..10, 3)
    correlation_id = "a96d7ed7-b3ef-4a99-9f64-bf9be928b4c2"

    Bypass.expect_once(
      bypass,
      "GET",
      "/servico-a/cotacao",
      json_response(200, ~s|{"cotacao": #{a}}|)
    )

    Bypass.expect_once(
      bypass,
      "GET",
      "/servico-b/cotacao",
      json_response(200, ~s|{"cotacao": {"valor": "#{b * 1000}", "fator": 1000}}|)
    )

    Bypass.expect_once(
      bypass,
      "POST",
      "/servico-c/cotacao",
      json_response(202, ~s|{"cid": "#{correlation_id}"}|)
    )

    req =
      Task.async(fn ->
        conn(:get, "/api/exchange-rate/USD")
        |> Exchange.Router.call(%{})
      end)

    wait_until(fn ->
      Registry.lookup(Exchange.Event, correlation_id) != []
    end)

    conn(:post, "/api/webhook", ~s|{"v": #{c * 1000}, "f": 1000, "cid": "#{correlation_id}"}|)
    |> put_req_header("content-type", "application/json")
    |> Exchange.Router.call(%{})

    resp = Task.await(req)

    assert resp.resp_body == ~s|{"value":#{Enum.min(response_list) / 1}}|
  end

  test "It will return 404 if can't match any route" do
    resp =
      conn(:get, "/api/some-not-found-url")
      |> Exchange.Router.call(%{})

    assert resp.status == 404
  end
end
