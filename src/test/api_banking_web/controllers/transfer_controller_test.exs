defmodule ApiBankingWeb.TransferControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Financial
  
  @create_attrs %{
    amount: 1
  }
  
  def fixture(:account) do
    {:ok, account} = Financial.create_account(
      %{
        amount: 1000,
        number: "some number",
        user_id: fixture(:user).id
      }
    )
    account
  end

  def fixture(:transfer) do
    {:ok, transfer} = Financial.create_transfer(@create_attrs |> Map.put(:transaction_id, fixture(:transaction).id) |> Map.put(:account_send_id, fixture(:account).id)  |> Map.put(:account_received_id, fixture(:account).id))
    transfer
  end

  def fixture(:transaction) do
    {:ok, transaction} = Financial.create_transaction(
      %{
        amount: 1,
        kind: "some kind",
        account_id: fixture(:account).id
      }
    )
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

  setup %{conn: conn} do
    {:ok, token, _} = ApiBanking.Guardian.encode_and_sign(fixture(:user))
    headers = put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "Bearer #{token}")
    {:ok, conn: headers}
  end

 
  describe "create transfer" do
    test "renders transfer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: @create_attrs |> Map.put(:transaction_id, fixture(:transaction).id) |> Map.put(:account_send_id, fixture(:account).id)  |> Map.put(:account_received_id, fixture(:account).id))
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end
  end

end
