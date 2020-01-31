defmodule ApiBankingWeb.TransactionController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Transaction

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, %{"account_id" => account_id}) do
    transactions = Financial.list_transactions(account_id)
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Financial.create_transaction(transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Financial.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Financial.get_transaction!(id)

    with {:ok, %Transaction{} = transaction} <- Financial.update_transaction(transaction, transaction_params) do
      render(conn, "show.json", transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Financial.get_transaction!(id)

    with {:ok, %Transaction{}} <- Financial.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
