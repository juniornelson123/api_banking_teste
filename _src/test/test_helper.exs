ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ApiBanking.Repo, :manual)

Faker.start()

Bureaucrat.start
ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])