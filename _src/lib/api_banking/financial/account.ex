defmodule ApiBanking.Financial.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :amount, :float
    field :number, :string

    belongs_to :user, ApiBanking.Financial.User
    has_many :transactions, ApiBanking.Financial.Transaction

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :number, :user_id])
    |> validate_required([:amount, :number, :user_id])
  end
end
