defmodule ApiBankingWeb.TransactionControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Financial

  @account_create_attrs %{
    amount: 1000,
    number: "some number"
  }

  @create_attrs %{
    amount: 120.5,
    kind: "some kind"
  }

  def fixture(:transaction) do
    {:ok, transaction} = Financial.create_transaction(@create_attrs |> Map.put(:account_id, fixture(:account).id))
    transaction
  end

  def fixture(:user) do
    {:ok, user} = Financial.create_user(%{
      username: Faker.Name.name(),
      name: "some name",
      password: "some password"
    })
    user
  end

  def fixture(:account) do
    {:ok, account} = Financial.create_account(@account_create_attrs |> Map.put(:user_id, fixture(:user).id))
    account
  end

  setup %{conn: conn} do
    {:ok, token, _} = ApiBanking.Guardian.encode_and_sign(fixture(:user))
    headers = put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "Bearer #{token}")
    {:ok, conn: headers}
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @create_attrs |> Map.put(:account_id, fixture(:account).id))
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end
  end
end
