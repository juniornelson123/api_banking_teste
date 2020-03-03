defmodule ApiBankingWeb.SessionController do
  use ApiBankingWeb, :controller

  use PhoenixSwagger
  
  def swagger_definitions do
    %{
      Auth:
        swagger_schema do
          title("Auth")
          description("Authentication for api")

          properties do
            id(:integer, "User ID")
            username(:string, "Session username", required: true)
            password(:string, "Session password", required: true)
          end

          example(%{
            username: "joegomes",
            password: "12345678"
          })
        end,
      AuthRequest:
        swagger_schema do
          title("AuthRequest")
          description("POST body for creating a Auth")
          property(:user, Schema.ref(:Auth), "The Auth details")
        end,
      AuthResponse:
        swagger_schema do
          title("AuthResponse")
          description("Response schema for single Auth")
          property(:data, Schema.ref(:Auth), "The Auth details")
        end,
      AuthsResponse:
        swagger_schema do
          title("AuthsReponse")
          description("Response schema for multiple Auths")
          property(:data, Schema.array(:Auth), "The Auths details")
        end  
    }
  end

  swagger_path(:show) do
    summary("Profile")
    description("Show profile")
    ApiBanking.CommonSwagger.authorization
    produces("application/json")
    
    response(200, "OK", Schema.ref(:AuthResponse),
      example: %{
        data: %{
          id: 1,
          name: "Joel",
          password: "encode",
          username: "joel4",
          inserted_at: "2017-02-08T12:34:55Z",
          updated_at: "2017-02-12T13:45:23Z"
        }
      }
    )
  end

  def show(conn, _params) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

  swagger_path(:login) do
    post("/api/sign_in")
    summary("Sign in user")
    description("Sign in user")
    consumes("application/json")
    produces("application/json")

    parameter(:user, :body, Schema.ref(:AuthRequest), "The Auth details",
      example: %{
        user: %{username: "joe1", password: "123456"}
      }
    )

    response(200, "Sign in success", Schema.ref(:AuthResponse),
      example: %{
        data: %{
          token: "et..",
        }
      }
    )
    
    response(404, "Sign in error", Schema.ref(:AuthResponse),
      example: %{
        data: %{
          error: "Username or password invalid",
        }
      }
    )
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case ApiBanking.Financial.authenticate_user_api(username, password) do
      {:ok, token, _claims} ->
        conn 
        |> render("jwt.json", jwt: token)
      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "Username or password invalid")
    end
  end
end