defmodule ApiBankingWeb.TransferController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Transfer

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, %{transaction_id: transaction_id}) do
    transfers = Financial.list_transfers(transaction_id)
    render(conn, "index.json", transfers: transfers)
  end

  def create(conn, %{"transfer" => transfer_params}) do
    with {:ok, %Transfer{} = transfer} <- Financial.create_transfer(transfer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transfer_path(conn, :show, transfer))
      |> render("show.json", transfer: transfer)
    end
  end

  def show(conn, %{"id" => id}) do
    transfer = Financial.get_transfer!(id)
    render(conn, "show.json", transfer: transfer)
  end

  def update(conn, %{"id" => id, "transfer" => transfer_params}) do
    transfer = Financial.get_transfer!(id)

    with {:ok, %Transfer{} = transfer} <- Financial.update_transfer(transfer, transfer_params) do
      render(conn, "show.json", transfer: transfer)
    end
  end

  def delete(conn, %{"id" => id}) do
    transfer = Financial.get_transfer!(id)

    with {:ok, %Transfer{}} <- Financial.delete_transfer(transfer) do
      send_resp(conn, :no_content, "")
    end
  end
end
