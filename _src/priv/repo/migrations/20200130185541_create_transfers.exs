defmodule ApiBanking.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :amount, :float
      add :account_send_id, references(:accounts, on_delete: :nothing)
      add :account_received_id, references(:accounts, on_delete: :nothing)
      add :transaction_id, references(:transactions, on_delete: :nothing)

      timestamps()
    end

    create index(:transfers, [:account_send_id])
    create index(:transfers, [:account_received_id])
    create index(:transfers, [:transaction_id])
  end
end
