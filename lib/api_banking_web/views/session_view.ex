defmodule ApiBankingWeb.SessionView do
  use ApiBankingWeb, :view

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, SessionView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      name: user.name,
      password: user.password}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{token: jwt}
  end
end
