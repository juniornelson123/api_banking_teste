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
    resources "/users", UserController, except: [:edit, :new]
    resources "/transactions", TransactionController, except: [:edit, :new]
    resources "/transfers", TransferController, except: [:edit, :new]
    resources "/accounts", AccountController, except: [:edit, :new]
  end
end
