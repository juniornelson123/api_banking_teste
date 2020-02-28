defmodule ApiBanking.Financial.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :name, :string
    field :password, :string
    field :admin, :boolean, default: false    
    has_many :accounts, ApiBanking.Financial.Account
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :password, :admin])
    |> validate_required([:name, :username, :password])
    |> unique_constraint(:username)
    |> put_password_hash
  
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
