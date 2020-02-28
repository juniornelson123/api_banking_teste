defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  use PhoenixSwagger

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Account

  action_fallback ApiBankingWeb.FallbackController

  def swagger_definitions do
    %{
      Account:
        swagger_schema do
          title("Account")
          description("A account of the app")

          properties do
            id(:integer, "account ID")
            amount(:float, "account amount", required: true)
            number(:string, "account number", required: true)
            user_id(:integer, "Password address", required: true)
            inserted_at(:string, "Creation timestamp", format: :datetime)
            updated_at(:string, "Update timestamp", format: :datetime)
          end

          example(%{
            amount: 2000,
            number: "12312321",
            user_id: 1
          })
        end,
      AccountRequest:
        swagger_schema do
          title("AccountRequest")
          description("POST body for creating a account")
          property(:account, Schema.ref(:Account), "The account details")
        end,
      AccountResponse:
        swagger_schema do
          title("AccountResponse")
          description("Response schema for single account")
          property(:data, Schema.ref(:Account), "The account details")
        end,
      AccountsResponse:
        swagger_schema do
          title("AccountsReponse")
          description("Response schema for multiple accounts")
          property(:data, Schema.array(:Account), "The accounts details")
        end
    }
  end

  swagger_path(:index) do
    get("/api/accounts")
    summary("My Accounts")
    ApiBanking.CommonSwagger.authorization
    description("List all my accounts in the database")
    produces("application/json")

    response(200, "OK", Schema.ref(:AccountsResponse),
      example: %{
        data: [
          %{
            id: 1,
            amount: 2000,
            number: "12312321",
            user_id: 1,
            inserted_at: "2017-02-08T12:34:55Z",
            updated_at: "2017-02-12T13:45:23Z"
          },
          %{
            id: 2,
            amount: 2000,
            number: "22312321",
            user_id: 1,
            inserted_at: "2017-02-08T12:34:55Z",
            updated_at: "2017-02-12T13:45:23Z"
          }
        ]
      }
    )
  end

  def index(conn, _params) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    accounts = Financial.list_accounts(user.id)
    render(conn, "index.json", accounts: accounts)
  end

  swagger_path(:create) do
    post("/api/accounts")
    summary("Create account")
    ApiBanking.CommonSwagger.authorization
    description("Creates a new account")
    consumes("application/json")
    produces("application/json")

    parameter(:user, :body, Schema.ref(:AccountRequest), "The Account details",
      example: %{}
    )

    response(201, "Account created OK", Schema.ref(:AccountResponse),
      example: %{
        data: %{
          id: 1,
          amount: 1.0e0,
          number: "12312321",
          user_id: 1,
          inserted_at: "2017-02-08T12:34:55Z",
          updated_at: "2017-02-12T13:45:23Z"
        }
      }
    )
  end

  def create(conn, _params) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    account_params = %{number: "user.id", amount: 1000, user_id: user.id}
    with {:ok, %Account{} = account} <- Financial.create_account(account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  swagger_path(:show) do
    summary("Show Account")
    description("Show a account by ID")
    ApiBanking.CommonSwagger.authorization
    produces("application/json")
    parameter(:id, :path, :integer, "Account ID", required: true, example: 1)

    response(200, "OK", Schema.ref(:AccountResponse),
      example: %{
        data: %{
          id: 1,
          amount: 1.0e0,
          number: "12312321",
          user_id: 1,
          inserted_at: "2017-02-08T12:34:55Z",
          updated_at: "2017-02-12T13:45:23Z"
        }
      }
    )
  end
  
  def show(conn, %{"id" => id}) do
    account = Financial.get_account!(id)
    render(conn, "show.json", account: account)
  end

  swagger_path(:delete) do
    PhoenixSwagger.Path.delete("/api/accounts/{id}")
    summary("Delete account")
    description("Delete a account by ID")
    ApiBanking.CommonSwagger.authorization
    parameter(:id, :path, :integer, "account ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
  end

  def delete(conn, %{"id" => id}) do
    account = Financial.get_account!(id)

    with {:ok, %Account{}} <- Financial.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
