defmodule ApiBankingWeb.TransactionView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.{ TransferView, TransactionView }
  alias ApiBanking.Repo

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("transaction.json", %{transaction: transaction}) do
    transaction = transaction |> Repo.preload([:account, :transfer])
    %{
      id: transaction.id,
      kind: transaction.kind,
      amount: transaction.amount,
      account_id: transaction.account_id,
      transfer: render_one(transaction.transfer, TransferView, "transfer_simple.json"),
      inserted_at: transaction.inserted_at,
      updated_at: transaction.updated_at,
    }
  end
end
