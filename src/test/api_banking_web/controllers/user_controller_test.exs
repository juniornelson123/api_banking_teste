defmodule ApiBankingWeb.UserControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Financial
  alias ApiBanking.Financial.User

  @create_attrs %{
    username: Faker.Name.name(),
    name: "some name",
    password: "some password"
  }
  @update_attrs %{
    username: Faker.Name.name(),
    name: "some updated name",
    password: "some updated password"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Financial.create_user(@create_attrs |> Map.put(:username, Faker.Name.name()))
    user
  end

  setup %{conn: conn} do
    {:ok, token, _} = ApiBanking.Guardian.encode_and_sign(fixture(:user))
    headers = put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "Bearer #{token}")
    {:ok, conn: headers}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      username = Faker.Name.name()
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs |> Map.put(:username, username)) |> doc(name: "Name for user", username: "Username for user", password: "Password for user")
      assert %{"id" => id} = json_response(conn, 201)["data"]

    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
  
end
