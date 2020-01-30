defmodule ApiBanking.Financial.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :float
    field :kind, :string
    belongs_to :account, ApiBanking.Financial.Account
    has_one :transfer, ApiBanking.Financial.Transfer
    
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:kind, :amount, :account_id])
    |> validate_required([:kind, :amount, :account_id])
  end
end
