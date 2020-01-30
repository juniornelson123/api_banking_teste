defmodule ApiBankingWeb.SessionController do
  use ApiBankingWeb, :controller

  def show(conn, _params) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case ApiBanking.Financial.authenticate_user_api(username, password) do
      {:ok, token, _claims} ->
        conn 
        |> render("jwt.json", jwt: token)
      _ ->
        conn
        |> render("error.json", error: "Username or password invalid")
    end
  end
end