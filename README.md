# Exchange
Elixir solution to a challenge of aggregating results of 3 apis

Based on [Zanfranceschi](https://twitter.com/zanfranceschi)'s challenge  
Original tweet: https://twitter.com/zanfranceschi/status/1548344242010869763  
Instructions repository: https://github.com/zanfranceschi/desafio-01-cotacoes    

## Running
Client api:

	$ docker run --rm -p 8080:80 zanfranceschi/desafio-01-cotacoes

Application:

    $ mix run --no-halt
    $ curl http://localhost:4040/api/exchange-rate/USD

## Testing

    $ mix test
