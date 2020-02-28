defmodule ApiBankingWeb.AccountControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Financial
  
  @create_attrs %{
    amount: 1000,
    number: "some number"
  }

  def fixture(:user) do
    {:ok, user} = Financial.create_user(%{
      username: Faker.Name.name(),
      name: "some name",
      password: "some password"
    })
    user
  end

  def fixture(:account) do
    {:ok, account} = Financial.create_account(@create_attrs |> Map.put(:user_id, fixture(:user).id))
    account
  end

  setup %{conn: conn} do
    {:ok, token, _} = ApiBanking.Guardian.encode_and_sign(fixture(:user))
    headers = put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "Bearer #{token}")
    {:ok, conn: headers}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @create_attrs |> Map.put(:user_id, fixture(:user).id))
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end
  end

  describe "delete account" do
    setup [:create_account]

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete(conn, Routes.account_path(conn, :delete, account))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_path(conn, :show, account))
      end
    end
  end

  defp create_account(_) do
    account = fixture(:account)
    {:ok, account: account}
  end
end
