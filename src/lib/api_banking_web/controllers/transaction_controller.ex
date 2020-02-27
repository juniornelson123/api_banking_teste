defmodule ApiBankingWeb.TransactionController do
  use ApiBankingWeb, :controller

  use PhoenixSwagger

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Transaction

  action_fallback ApiBankingWeb.FallbackController

  def swagger_definitions do
    %{
      Transaction:
        swagger_schema do
          title("Transaction")
          description("A transaction of the app")

          properties do
            field :amount, :float
            field :kind, :string
            belongs_to :account, ApiBanking.Financial.Account

            id(:integer, "transaction ID")
            amount(:float, "transaction amount", required: true)
            kind(:string, "transaction number", required: true)
            account_id(:integer, "transaction account_id", required: true)
            inserted_at(:string, "Creation timestamp", format: :datetime)
            updated_at(:string, "Update timestamp", format: :datetime)
          end

          example(%{
            amount: 2000,
            kind: "normal",
            account_id: 1
          })
        end,
      TransactionRequest:
        swagger_schema do
          title("TransactionRequest")
          description("POST body for creating a Transaction")
          property(:transaction, Schema.ref(:Transaction), "The Transaction details")
        end,
      TransactionResponse:
        swagger_schema do
          title("TransactionResponse")
          description("Response schema for single Transaction")
          property(:data, Schema.ref(:Transaction), "The Transaction details")
        end,
      TransactionsResponse:
        swagger_schema do
          title("TransactionsReponse")
          description("Response schema for multiple Transactions")
          property(:data, Schema.array(:Transaction), "The Transactions details")
        end
    }
  end

  swagger_path(:index) do
    get("/api/transactions?account_id=1")
    summary("My Transactions")
    ApiBanking.CommonSwagger.authorization
    description("List all my transactions in the database")
    produces("application/json")

    response(200, "OK", Schema.ref(:TransactionResponse),
      example: %{
        data: [
          %{
            id: 1,
            amount: 2000,
            kind: "normal",
            account_id: 1,
            inserted_at: "2017-02-08T12:34:55Z",
            updated_at: "2017-02-12T13:45:23Z"
          },
          %{
            id: 2,
            amount: 2000,
            kind: "normal",
            account_id: 1,
            inserted_at: "2017-02-08T12:34:55Z",
            updated_at: "2017-02-12T13:45:23Z"
          }
        ]
      }
    )
  end

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
