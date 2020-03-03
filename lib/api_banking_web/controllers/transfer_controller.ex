defmodule ApiBankingWeb.TransferController do
  use ApiBankingWeb, :controller

  use PhoenixSwagger

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Transfer

  action_fallback ApiBankingWeb.FallbackController

  def swagger_definitions do
    %{
      Transfer:
        swagger_schema do
          title("Transfer")
          description("A transfer of the app")

          properties do
            id(:integer, "transfer ID")
            amount(:float, "transfer amount", required: true)
            account_send_id(:string, "transfer account for send", required: true)
            account_received_id(:string, "transfer account for receiver", required: true)
            inserted_at(:string, "Creation timestamp", format: :datetime)
            updated_at(:string, "Update timestamp", format: :datetime)
          end

          example(%{
            amount: 1000,
            account_send_id: 1,
            account_received_id: 2,
          })
        end,
      TransferRequest:
        swagger_schema do
          title("TransferRequest")
          description("POST body for creating a Transfer")
          property(:transfer, Schema.ref(:Transfer), "The Transfer details")
        end,
      TransferResponse:
        swagger_schema do
          title("TransferResponse")
          description("Response schema for single Transfer")
          property(:data, Schema.ref(:Transfer), "The Transfer details")
        end,
      TransfersResponse:
        swagger_schema do
          title("TransfersReponse")
          description("Response schema for multiple Transfers")
          property(:data, Schema.array(:Transfer), "The Transfers details")
        end
    }
  end

  swagger_path(:create) do
    post("/api/transfers")
    summary("Create transfer")
    ApiBanking.CommonSwagger.authorization
    description("Creates a new transfer")
    consumes("application/json")
    produces("application/json")

    parameter(:user, :body, Schema.ref(:TransferRequest), "The Transfer details",
      example: %{
        amount: 1000,
        account_send_id: 1,
        account_received_id: 2,
      }
    )

    response(201, "Transfer created OK", Schema.ref(:TransferResponse),
      example: %{
        data: %{
          id: 6,
          amount: 100.0,
          account_received: %{
            id: 1,
            amount: 700.0,
            number: "fake_account_number",
            user_id: 3,
            inserted_at: "2020-01-30T20:44:20",
            updated_at: "2020-02-28T15:03:59",
          },
          account_received_id: 1,
          account_send: %{
            id: 2,
            amount: 400.0,
            number: "fake_account_number",
            user_id: 3,
            inserted_at: "2020-02-28T14:57:10",
            updated_at: "2020-02-28T15:03:59",
          },
          account_send_id: 2,
          transaction: %{
            amount: 100.0,
            id: 8,
            kind: "transfer",
            inserted_at: "2020-02-28T15:03:59",
            updated_at: "2020-02-28T15:03:59"
          },
          transaction_id: 8,
          inserted_at: "2020-02-28T15:03:59",
          updated_at: "2020-02-28T15:03:59"
        }
      }
    )
  end

  def create(conn, %{"transfer" => transfer_params}) do
    account_send = Financial.get_account!(transfer_params["account_send_id"])
    account_received = Financial.get_account!(transfer_params["account_received_id"])

    if account_send.amount > transfer_params["amount"] do
      case Financial.create_transaction(%{kind: "transfer", amount: transfer_params["amount"], account_id: transfer_params["account_send_id"]}) do
        {:ok, transaction} -> 
          with {:ok, %Transfer{} = transfer} <- Financial.create_transfer(transfer_params |> Map.put("transaction_id", transaction.id)) do
            execute_transfer(account_send, account_received, transaction.amount)
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.transfer_path(conn, :show, transfer))
            |> render("show.json", transfer: transfer)
          end
        {:error, _} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", error: "Error generate transaction, verify data")
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: "insufficient funds")
    end  
  end

  defp execute_transfer(account_send, account_received, amount) do
    Financial.update_account(account_send, %{amount: account_send.amount - amount})
    Financial.update_account(account_received, %{amount: account_received.amount + amount})
  end
end
