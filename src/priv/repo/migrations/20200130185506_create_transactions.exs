defmodule ApiBanking.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :kind, :string
      add :amount, :float
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:account_id])
  end
end
