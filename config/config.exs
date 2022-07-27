import Config

config :exchange, Exchange.Http.ServiceA, base_url: "http://localhost:8080"

config :exchange, Exchange.Http.ServiceB, base_url: "http://localhost:8080"

config :exchange, Exchange.Http.ServiceC,
  base_url: "http://localhost:8080",
  webhook_url: "http://host.docker.internal:4040/api/webhook"
