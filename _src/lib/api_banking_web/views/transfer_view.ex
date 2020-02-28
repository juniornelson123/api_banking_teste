defmodule ApiBankingWeb.TransferView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.{ TransferView, AccountView, TransactionView}
  alias ApiBanking.Repo

  def render("index.json", %{transfers: transfers}) do
    %{data: render_many(transfers, TransferView, "transfer.json")}
  end

  def render("show.json", %{transfer: transfer}) do
    %{data: render_one(transfer, TransferView, "transfer.json")}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("transfer.json", %{transfer: transfer}) do
    transfer = transfer |> Repo.preload([:transaction, :account_send, :account_received])
    %{
      id: transfer.id,
      amount: transfer.amount,
      account_send_id: transfer.account_send_id,
      account_received_id: transfer.account_received_id,
      transaction_id: transfer.transaction_id,
      transaction: render_one(transfer.transaction, TransactionView, "transaction.json"),
      account_send: render_one(transfer.account_send, AccountView, "account.json"),
      account_received: render_one(transfer.account_received, AccountView, "account.json"),
      inserted_at: transfer.inserted_at,
      updated_at: transfer.updated_at,
    }
  end

  def render("transfer_simple.json", %{transfer: transfer}) do
    transfer = transfer |> Repo.preload([:account_send, :account_received])
    %{
      id: transfer.id,
      account_received_id: transfer.account_received_id,
      account_send_id: transfer.account_send_id,
      account_send: render_one(transfer.account_send, AccountView, "account.json"),
      account_received: render_one(transfer.account_received, AccountView, "account.json"),
    }
  end
end
