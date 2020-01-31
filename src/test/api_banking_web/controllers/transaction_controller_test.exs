defmodule ApiBankingWeb.TransactionControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Transaction

  @account_create_attrs %{
    amount: 1000,
    number: "some number"
  }

  @create_attrs %{
    amount: 120.5,
    kind: "some kind"
  }
  @update_attrs %{
    amount: 456.7,
    kind: "some updated kind"
  }
  @invalid_attrs %{amount: nil, kind: nil}

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
  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @create_attrs |> Map.put(:account_id, fixture(:account).id))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 120.5,
               "kind" => "some kind"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transaction" do
    setup [:create_transaction]

    test "renders transaction when data is valid", %{conn: conn, transaction: %Transaction{id: id} = transaction} do
      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @update_attrs |> Map.put(:account_id, fixture(:account).id))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 456.7,
               "kind" => "some updated kind"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end
    end
  end

  defp create_transaction(_) do
    transaction = fixture(:transaction)
    {:ok, transaction: transaction}
  end
end
