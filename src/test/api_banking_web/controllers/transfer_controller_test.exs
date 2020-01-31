defmodule ApiBankingWeb.TransferControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Transfer

  @create_attrs %{
    amount: 120.5
  }
  @update_attrs %{
    amount: 456.7
  }
  @invalid_attrs %{amount: nil}
  
  def fixture(:account) do
    {:ok, account} = Financial.create_account(
      %{
        amount: 120.5,
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
        amount: 120.5,
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

  describe "index" do
    test "lists all transfers", %{conn: conn} do
      conn = get(conn, Routes.transfer_path(conn, :index, transaction_id: fixture(:transaction).id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transfer" do
    test "renders transfer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: @create_attrs |> Map.put(:transaction_id, fixture(:transaction).id) |> Map.put(:account_send_id, fixture(:account).id)  |> Map.put(:account_received_id, fixture(:account).id))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transfer_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: @invalid_attrs |> Map.put(:transaction_id, fixture(:transaction).id) |> Map.put(:account_send_id, fixture(:account).id)  |> Map.put(:account_received_id, fixture(:account).id))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transfer" do
    setup [:create_transfer]

    test "renders transfer when data is valid", %{conn: conn, transfer: %Transfer{id: id} = transfer} do
      conn = put(conn, Routes.transfer_path(conn, :update, transfer), transfer: @update_attrs |> Map.put(:transaction_id, fixture(:transaction).id) |> Map.put(:account_send_id, fixture(:account).id)  |> Map.put(:account_received_id, fixture(:account).id))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transfer_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transfer: transfer} do
      conn = put(conn, Routes.transfer_path(conn, :update, transfer), transfer: @invalid_attrs |> Map.put(:transaction_id, fixture(:transaction).id) |> Map.put(:account_send_id, fixture(:account).id)  |> Map.put(:account_received_id, fixture(:account).id))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transfer" do
    setup [:create_transfer]

    test "deletes chosen transfer", %{conn: conn, transfer: transfer} do
      conn = delete(conn, Routes.transfer_path(conn, :delete, transfer))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transfer_path(conn, :show, transfer))
      end
    end
  end

  defp create_transfer(_) do
    transfer = fixture(:transfer)
    {:ok, transfer: transfer}
  end
end
