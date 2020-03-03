ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ApiBanking.Repo, :manual)

Faker.start()

ExUnit.start(formatters: [ExUnit.CLIFormatter])