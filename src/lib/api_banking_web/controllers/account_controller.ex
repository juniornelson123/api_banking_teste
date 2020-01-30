defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Financial
  alias ApiBanking.Financial.Account

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    accounts = Financial.list_accounts(user.id)
    render(conn, "index.json", accounts: accounts)
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

  def show(conn, %{"id" => id}) do
    account = Financial.get_account!(id)
    render(conn, "show.json", account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Financial.get_account!(id)
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    
    with {:ok, %Account{} = account} <- Financial.update_account(account, account_params |> Map.put("user_id", user.id)) do
      render(conn, "show.json", account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Financial.get_account!(id)

    with {:ok, %Account{}} <- Financial.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
