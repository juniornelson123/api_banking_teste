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
            id(:integer, "transaction ID")
            amount(:float, "transaction amount", required: true)
            kind(:string, "transaction kind (withdraw transfer)", required: true)
            account_id(:integer, "transaction account_id", required: true)
            inserted_at(:string, "Creation timestamp", format: :datetime)
            updated_at(:string, "Update timestamp", format: :datetime)
          end

          example(%{
            amount: 2000,
            kind: "withdraw",
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
    get("/api/transactions")
    summary("All Transactions (Backoffice)")
    ApiBanking.CommonSwagger.authorization
    description("List all transactions in the database(only user admin)")
    produces("application/json")

    response(200, "OK", Schema.ref(:TransactionResponse),
      example: %{
        data: [
          %{
            id: 1,
            amount: 2000,
            kind: "withdraw",
            account_id: 1,
            inserted_at: "2017-02-08T12:34:55Z",
            updated_at: "2017-02-12T13:45:23Z"
          },
          %{
            id: 2,
            account_id: 2,
            amount: 100.0,
            kind: "transfer",
            transfer: %{
              id: 3,
              account_received: %{
                amount: 600.0,
                id: 1,
                user_id: 3,
                number: "user.id",
                inserted_at: "2020-01-30T20:44:20",
                updated_at: "2020-02-28T15:04:10",
              },
              account_received_id: 1,
              account_send: %{
                id: 2,
                amount: 400.0,
                number: "user.id",
                user_id: 3,
                inserted_at: "2020-02-28T14:57:10",
                updated_at: "2020-02-28T15:03:59",
              },
              account_send_id: 2,
            },
            inserted_at: "2020-02-28T15:01:24",
            updated_at: "2020-02-28T15:01:24"
          }
        ]
      }
    )
  end

  def index(conn, _) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    if user.admin do
      transactions = Financial.list_transactions
      render(conn, "index.json", transactions: transactions)
    else
      conn
        |> put_status(:unauthorized)
        |> render("error.json", error: "Not authorized, you must be an admin to access this feature")
    end
  end

  swagger_path(:my_transaction) do
    get("/api/my_transactions/{account_id}")
    summary("My Transactions")
    ApiBanking.CommonSwagger.authorization
    description("List all my transactions with account in the database")
    produces("application/json")

    response(200, "OK", Schema.ref(:TransactionResponse),
      example: %{
        data: [
          %{
            id: 1,
            amount: 2000,
            kind: "withdraw",
            account_id: 1,
            inserted_at: "2017-02-08T12:34:55Z",
            updated_at: "2017-02-12T13:45:23Z"
          },
          %{
            id: 2,
            account_id: 2,
            amount: 100.0,
            kind: "transfer",
            transfer: %{
              id: 3,
              account_received: %{
                amount: 600.0,
                id: 1,
                user_id: 3,
                number: "user.id",
                inserted_at: "2020-01-30T20:44:20",
                updated_at: "2020-02-28T15:04:10",
              },
              account_received_id: 1,
              account_send: %{
                id: 2,
                amount: 400.0,
                number: "user.id",
                user_id: 3,
                inserted_at: "2020-02-28T14:57:10",
                updated_at: "2020-02-28T15:03:59",
              },
              account_send_id: 2,
            },
            inserted_at: "2020-02-28T15:01:24",
            updated_at: "2020-02-28T15:01:24"
          }
        ]
      }
    )
  end

  def my_transaction(conn, %{"account_id" => account_id}) do
    transactions = Financial.list_transactions(account_id)
    render(conn, "index.json", transactions: transactions)
  end

  swagger_path(:create) do
    post("/api/transactions")
    summary("New withdraw")
    ApiBanking.CommonSwagger.authorization
    description("Creates a new withdraw")
    consumes("application/json")
    produces("application/json")

    parameter(:transaction, :body, Schema.ref(:TransactionRequest), "The Transaction details",
      example: %{
        amount: 1000,
        account_id: 1,
      }
    )

    response(201, "Transaction created OK", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 2,
          account_id: 2,
          amount: 100.0,
          kind: "transfer",
          transfer: %{
            id: 3,
            account_received: %{
              amount: 600.0,
              id: 1,
              user_id: 3,
              number: "user.id",
              inserted_at: "2020-01-30T20:44:20",
              updated_at: "2020-02-28T15:04:10",
            },
            account_received_id: 1,
            account_send: %{
              id: 2,
              amount: 400.0,
              number: "user.id",
              user_id: 3,
              inserted_at: "2020-02-28T14:57:10",
              updated_at: "2020-02-28T15:03:59",
            },
            account_send_id: 2,
          },
          inserted_at: "2020-02-28T15:01:24",
          updated_at: "2020-02-28T15:01:24"
        }
      }
    )
  end

  def create(conn, %{"transaction" => transaction_params}) do
    account = Financial.get_account!(transaction_params["account_id"])
    if account.amount > transaction_params["amount"] do
      with {:ok, %Transaction{} = transaction} <- Financial.create_transaction(transaction_params |> Map.put("kind", "withdraw")) do
        decrease_balance(transaction.amount, account)
        send_email(conn)
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
        |> render("show.json", transaction: transaction)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: "insufficient funds")
    end

  end

  swagger_path(:show) do
    summary("Show transaction")
    description("Show a transaction by ID")
    ApiBanking.CommonSwagger.authorization
    produces("application/json")
    parameter(:id, :path, :integer, "transaction ID", required: true, example: 1)

    response(200, "OK", Schema.ref(:TransactionResponse),
      example: %{
        data: %{
          id: 2,
          account_id: 2,
          amount: 100.0,
          kind: "transfer",
          transfer: %{
            id: 3,
            account_received: %{
              amount: 600.0,
              id: 1,
              user_id: 3,
              number: "user.id",
              inserted_at: "2020-01-30T20:44:20",
              updated_at: "2020-02-28T15:04:10",
            },
            account_received_id: 1,
            account_send: %{
              id: 2,
              amount: 400.0,
              number: "user.id",
              user_id: 3,
              inserted_at: "2020-02-28T14:57:10",
              updated_at: "2020-02-28T15:03:59",
            },
            account_send_id: 2,
          },
          inserted_at: "2020-02-28T15:01:24",
          updated_at: "2020-02-28T15:01:24"
        }
      }
    )
  end


  def show(conn, %{"id" => id}) do
    transaction = Financial.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  defp decrease_balance(amount, account) do
    Financial.update_account(account, %{amount: account.amount - amount})
  end

  defp send_email(conn) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    IO.puts "Send email to #{user.email}"
  end

end
