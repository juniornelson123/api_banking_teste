defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router
    
  pipeline :jwt_ensure do
    plug ApiBanking.AuthPipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiBankingWeb do
    pipe_through :api
    
    post "/sign_in", SessionController, :login
    
    resources "/users", UserController, only: [:create]
  end
  
  scope "/api", ApiBankingWeb do
    pipe_through [:api, :jwt_ensure]
    
    get "/my_user", SessionController, :show
    put "/update_user", UserController, :update
    resources "/users", UserController, except: [:update, :edit, :new]
    get "/my_transactions/:account_id", TransactionController, :my_transaction
    resources "/transactions", TransactionController, only: [:index, :create, :show]
    resources "/transfers", TransferController, only: [:create, :show]
    resources "/accounts", AccountController, except: [:edit, :new]
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :api_banking, swagger_file: "swagger.json")
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Api Banking"
      }
    }
  end
end
