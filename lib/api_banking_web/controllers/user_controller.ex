defmodule ApiBankingWeb.UserController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

  alias ApiBanking.Financial
  alias ApiBanking.Financial.User

  action_fallback ApiBankingWeb.FallbackController

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the app")

          properties do
            id(:integer, "User ID")
            name(:string, "User name", required: true)
            username(:string, "Username address", format: :username, required: true)
            password(:string, "Password address", format: :password, required: true)
            inserted_at(:string, "Creation timestamp", format: :datetime)
            updated_at(:string, "Update timestamp", format: :datetime)
          end

          example(%{
            name: "Joe",
            username: "joe@gmail.com",
            password: "12345678"
          })
        end,
      UserRequest:
        swagger_schema do
          title("UserRequest")
          description("POST body for creating a user")
          property(:user, Schema.ref(:User), "The user details")
        end,
      UserResponse:
        swagger_schema do
          title("UserResponse")
          description("Response schema for single user")
          property(:data, Schema.ref(:User), "The user details")
        end,
      UsersResponse:
        swagger_schema do
          title("UsersReponse")
          description("Response schema for multiple users")
          property(:data, Schema.array(:User), "The users details")
        end
    }
  end

  swagger_path(:create) do
    post("/api/users")
    summary("Create user")
    description("Creates a new user")
    consumes("application/json")
    produces("application/json")

    parameter(:user, :body, Schema.ref(:UserRequest), "The user details",
      example: %{
        user: %{name: "Joe", username: "joe1", password: "123456"}
      }
    )

    response(201, "User created OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 1,
          name: "Joe",
          username: "joe1",
          password: "encode",
          inserted_at: "2020-02-08T12:34:55Z",
          updated_at: "2020-02-12T13:45:23Z"
        }
      }
    )
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Financial.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  swagger_path(:update) do
    put("/api/update_user")
    summary("Update my user")
    description("Update all attributes of a user")
    ApiBanking.CommonSwagger.authorization
    consumes("application/json")
    produces("application/json")

    parameters do
      user(:body, Schema.ref(:UserRequest), "The user details",
        example: %{
          user: %{name: "Joe", username: "joe4"}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 3,
          name: "Joe",
          username: "joe5",
          inserted_at: "2017-02-08T12:34:55Z",
          updated_at: "2017-02-12T13:45:23Z"
        }
      }
    )
  end

  def update(conn, %{"user" => user_params}) do
    user = ApiBanking.Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <- Financial.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end