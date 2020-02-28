defmodule ApiBanking.Financial.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field :amount, :float
    
    belongs_to :account_send, ApiBanking.Financial.Account
    belongs_to :account_received, ApiBanking.Financial.Account
    belongs_to :transaction, ApiBanking.Financial.Transaction

    timestamps()
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
    |> cast(attrs, [:amount, :account_send_id, :account_received_id, :transaction_id])
    |> validate_required([:amount, :account_send_id, :account_received_id, :transaction_id])
  end
end


